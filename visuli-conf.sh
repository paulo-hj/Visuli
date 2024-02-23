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
            echo "========================================"
            echo "A instalação do Visuli foi abortada. O Apache é necessário para executar o Visuli."
            exit 1
        fi
    else
        echo "========================================"
        echo "O Apache já está instalado no sistema."
        read -p "Deseja continuar com a instalação do Visuli? (s/n): " continue_installation
        if [[ $continue_installation != "s" && $continue_installation != "S" ]]; then
            echo "========================================"
            echo "A instalação do Visuli foi cancelada."
            exit 1
        fi
    fi
    
    # Configura no apache o arquivo visuli.html como principal
    sudo sed -i '/<Directory \/var\/www\/>/ {N;N;N; a\    DirectoryIndex visuli.html
    }' /etc/apache2/apache2.conf

    systemctl restart apache2

    # Move o script e tornar executavel
    sudo cp visuli-main.sh /usr/local/bin/
    chmod +x /usr/local/bin/visuli-main.sh

    echo "========================================"
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

    # Configura o cron job
    echo "*/$tempoMinutos * * * * root /usr/local/bin/visuli-main.sh" > /etc/cron.d/visuli
    chmod +x /etc/cron.d/visuli

    # Converter o intervalo de tempo para segundos
    tempoSegundos=$((tempoMinutos * 60))

    # Configurar o intervalo de tempo no script visuli-main
    sed -i "s/refreshPagina=\"[0-9]*\"/refreshPagina=\"$tempoSegundos\"/" /usr/local/bin/visuli-main.sh

    read -p "Por favor, insira as portas que deseja verificar se estão abertas (separadas por espaço): " portas

    # Modificar o arquivo visuli-main para incluir as portas a serem verificadas
    sed -i "s/\(portas=\"\)[^\"]*/\1$portas/" /usr/local/bin/visuli-main.sh

    funcoes=("systemInfo" "memoriaInfo" "diskInfo" "loadAverage" "logUsuarios" "log_size" "checkPortas")

    sed -i '157,163s/^#//' /usr/local/bin/visuli-main.sh
    echo "Selecione as funções que deseja desabilitar (separadas por espaço):"
    for ((i = 0; i < ${#funcoes[@]}; i++)); do
        echo "$(($i + 1)). ${funcoes[i]}"
    done
    read -p "Opções: " escolhas

    # Comenta as funções selecionadas pelo usuário
    for escolha in $escolhas; do
        index=$(($escolha + 156))
        if [[ $index -ge 157 && $index -le 163 ]]; then
            sed -i "${index}s/^/#/" /usr/local/bin/visuli-main.sh
        fi
    done

    # Move o arquivo de dar permissão   
    sudo cp visuli-conf.sh /usr/local/bin/
    chmod +x /usr/local/bin/visuli-conf.sh

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

    # Configurar o intervalo de tempo no script visuli-main.sh
    sed -i "s/refreshPagina=\"[0-9]*\"/refreshPagina=\"$tempoSegundos\"/" /usr/local/bin/visuli-main.sh

    # Configurar o cron job
    echo "*/$tempoMinutos * * * * root /usr/local/bin/visuli-main.sh" > /etc/cron.d/visuli
    chmod +x /etc/cron.d/visuli

    echo "Intervalo da rotina ajustado com sucesso!"
}

configureFuncao() {
    funcoes=("systemInfo" "memoriaInfo" "diskInfo" "loadAverage" "logUsuarios" "log_size" "checkPortas")

    sed -i '157,163s/^#//' /usr/local/bin/visuli-main.sh
    echo "Selecione as funções que deseja desabilitar (separadas por espaço):"
    for ((i = 0; i < ${#funcoes[@]}; i++)); do
        echo "$(($i + 1)). ${funcoes[i]}"
    done
    read -p "Opções: " escolhas

    # Comenta as funções selecionadas pelo usuário
    for escolha in $escolhas; do
        index=$(($escolha + 156))
        if [[ $index -ge 157 && $index -le 163 ]]; then
            sed -i "${index}s/^/#/" /usr/local/bin/visuli-main.sh
        fi
    done
    echo "Funções configuradas com sucesso!"
}

configurePortas() {
    # Solicitar ao usuário as portas que deseja verificar se estão abertas
    read -p "Por favor, insira as portas que deseja verificar se estão abertas (separadas por espaço): " portas

    # Modificar o arquivo visuli-main.sh para incluir as portas a serem verificadas
    sed -i "s/\(portas=\"\)[^\"]*/\1$portas/" /usr/local/bin/visuli-main.sh

    echo "Portas configuradas com sucesso!"
}

while true; do
    echo "========================================"
    echo "Bem-vindo ao Visuli!"
    echo "========================================"
    echo "Por favor, selecione uma opção:"
    echo "1. Instalação"
    echo "2. Ajuste no intervalo da rotina"
    echo "3. Configuração de funções"
    echo "4. Configuração de portas"
    echo "0. Sair"
    read -p "Opção: " opcao

    case $opcao in
        1) installVisuli;;
        2) adjusteRoutinaIntervalo;;
        3) configureFuncao;;
        4) configurePortas;;
        0) exit 0;;
        *) echo "Opção inválida. Por favor, selecione uma opção válida."
            continue;;
    esac
done
