#!/bin/bash

installVisuli() {
    echo "Bem-vindo à instalação do Visuli!"

    # Verificar se o Apache está instalado
    if ! command -v apache2 >/dev/null 2>&1; then
        echo "O Apache não está instalado no sistema."
        read -p "Você deseja instalar o Apache agora? (s/n): " install_apache
        if [[ $install_apache == "s" || $install_apache == "S" ]]; then
            # Instalar o Apache
            sudo apt-get update
            sudo apt-get install apache2
        else
            echo "A instalação do Visuli foi abortada. O Apache é necessário para executar o Visuli."
            exit 1
        fi
    else
        echo "O Apache já está instalado no sistema."
        read -p "Deseja continuar com a instalação do Visuli? (s/n): " continue_installation
        if [[ $continue_installation != "s" && $continue_installation != "S" ]]; then
            echo "A instalação do Visuli foi cancelada."
            exit 1
        fi
    fi
    
    read -p "Por favor, insira o intervalo de tempo desejado para a execução da rotina (em minutos, pressione Enter para usar o padrão de 5 minutos): " tempoMinutos

    # Verificar se o valor fornecido é de fato um número
    re='^[0-9]+$'
    if ! [[ $tempoMinutos =~ $re ]]; then
        if [[ -z "$tempoMinutos" ]]; then
            tempoMinutos=5
            echo "Nenhum valor foi fornecido. O valor padrão de 5 minutos será utilizado."
        else
            echo "Erro: Por favor, insira um valor numérico para o intervalo de tempo."
            exit 1
        fi
    fi

    # Converter o intervalo de tempo para segundos
    tempoSegundos=$((tempoMinutos * 60))

    # Configurar o intervalo de tempo no script visuli-main
    sed -i "s/refreshPagina=\"[0-9]*\"/refreshPagina=\"$tempoSegundos\"/" visuli-main

    read -p "Por favor, insira as portas que deseja verificar se estão abertas (separadas por espaço): " portas

    # Modificar o arquivo visuli-main para incluir as portas a serem verificadas
    sed -i "s/\(portas=\"\)[^\"]*/\1$portas/" visuli-main

    # Mover o script para /usr/local/bin/ e tornar exceutavel
    sudo cp visuli-main /usr/local/bin/
    chmod +x visuli-main

    # Cria o diretório
    sudo mkdir -p /var/www/html/visuli-main
    
    # Configura o cron job
    echo "*/$tempoMinutos * * * * root /usr/local/bin/visuli-main" > /etc/cron.d/visuli
    chmod +x /etc/cron.d/visuli

    # Lista de funções disponíveis
    funcoes=("systemInfo" "memoriaInfo" "diskInfo" "loadAverage" "logUsuarios" "log_size" "checkPortas")

    echo "Selecione as funções que deseja desabilitar (separadas por espaço):"
    for ((i = 0; i < ${#funcoes[@]}; i++)); do
        echo "$(($i + 1)). ${funcoes[i]}"
    done
    read -p "Opções: " escolhas

    # Verifica se as escolhas do usuário são válidas e modifica o arquivo visuli-main
    for escolha in $escolhas; do
        index=$(($escolha - 1))
        if [[ $index -ge 0 && $index -lt ${#funcoes[@]} ]]; then
            sed -i "s/${funcoes[index]}()/#${funcoes[index]}()/" visuli-main
        fi
    done

    # Move o arquivo de dar permissão
    sudo cp visuli-conf /usr/local/bin/
    chmod +x /usr/local/bin/visuli-conf

    echo "Instalação concluída com sucesso!"
}

adjusteRoutinaIntervalo() {
    read -p "Por favor, insira o intervalo de tempo desejado para a execução da rotina (em minutos, pressione Enter para usar o padrão de 5 minutos): " tempoMinutos

    # Verificar se o valor fornecido é um número
    re='^[0-9]+$'
    if ! [[ $tempoMinutos =~ $re ]]; then
        if [[ -z "$tempoMinutos" ]]; then
            # Definir um valor padrão de 5 minutos se nenhum valor for fornecido
            tempoMinutos=5
            echo "Nenhum valor foi fornecido. O valor padrão de 5 minutos será utilizado."
        else
            echo "Erro: Por favor, insira um valor numérico para o intervalo de tempo."
            exit 1
        fi
    fi

    # Converter o intervalo de tempo para segundos
    tempoSegundos=$((tempoMinutos * 60))

    # Configurar o intervalo de tempo no script visuli-main
    sed -i "s/refreshPagina=\"[0-9]*\"/refreshPagina=\"$tempoSegundos\"/" visuli-main

    # Configurar o cron job
    echo "*/$tempoMinutos * * * * root /usr/local/bin/visuli-main" > /etc/cron.d/visuli
    chmod +x /etc/cron.d/visuli

    echo "Intervalo da rotina ajustado com sucesso!"
}

configureFuncao() {
    funcoes=("systemInfo" "memoriaInfo" "diskInfo" "loadAverage" "logUsuarios" "log_size" "checkPortas")

    echo "Selecione as funções que deseja desabilitar (separadas por espaço):"
    for ((i = 0; i < ${#funcoes[@]}; i++)); do
        echo "$(($i + 1)). ${funcoes[i]}"
    done
    read -p "Opções: " escolhas

    # Verifica se as escolhas do usuário são válidas e modifica o arquivo visuli-main
    for escolha in $escolhas; do
        index=$(($escolha - 1))
        if [[ $index -ge 0 && $index -lt ${#funcoes[@]} ]]; then
            sed -i "s/${funcoes[index]}()/#${funcoes[index]}()/" visuli-main
        fi
    done

    echo "Funções configuradas com sucesso!"
}

configurePortas() {
    # Solicitar ao usuário as portas que deseja verificar se estão abertas
    read -p "Por favor, insira as portas que deseja verificar se estão abertas (separadas por espaço): " portas

    # Modificar o arquivo visuli-main para incluir as portas a serem verificadas
    sed -i "s/\(portas=\"\)[^\"]*/\1$portas/" visuli-main

    echo "Portas configuradas com sucesso!"
}

echo "Bem-vindo ao Visuli!"
echo "Por favor, selecione uma opção:"
echo "1. Instalação"
echo "2. Ajuste no intervalo da rotina"
echo "3. Configuração de funções"
echo "4. Configuração de portas"
read -p "Opção: " opcao

case $opcao in
    1) installVisuli ;;
    2) adjusteRoutinaIntervalo ;;
    3) configureFuncao ;;
    4) configurePortas ;;
    *) echo "Opção inválida. Por favor, selecione uma opção válida." ;;
esac
