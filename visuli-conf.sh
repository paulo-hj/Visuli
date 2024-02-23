#!/bin/bash

installVisuli() {
    # Verificar se o Apache está instalado
    if ! command -v apache2 >/dev/null 2>&1; then
        echo "O Apache não está instalado no sistema."
        read -p "Você deseja instalar o Apache agora? (s/n): " install_apache
        if [[ $install_apache == "s" || $install_apache == "S" ]]; then
            echo
            sudo apt-get update
            sudo apt-get install apache2
        else
            echo -e "____________________________________________________________\n"
            echo -e "A instalação do Visuli foi abortada. O Apache é necessário para executar o Visuli. \n"
            exit 1
        fi
    else
        echo -e "____________________________________________________________\n"
        echo "O Apache já está instalado no sistema."
        read -p "Deseja continuar com a instalação do Visuli? (s/n): " continue_installation
        if [[ $continue_installation != "s" && $continue_installation != "S" ]]; then
            echo -e "____________________________________________________________\n"
            echo -e "A instalação do Visuli foi cancelada.\n"
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

    echo -e "____________________________________________________________\n"
    read -p "Por favor, insira o intervalo de tempo desejado para a execução da rotina (em minutos, pressione Enter para usar o padrão de 5 minutos): " tempoMinutos

    # Verificar se o valor fornecido é de fato um número
    re='^[0-9]+$'
    if ! [[ $tempoMinutos =~ $re ]]; then
        if [[ -z "$tempoMinutos" ]]; then
            tempoMinutos=5
            echo -e "____________________________________________________________\n"
            echo "Nenhum valor foi fornecido. O valor padrão de 5 minutos será utilizado."
        else
            echo -e "____________________________________________________________\n"
            echo "Erro: Por favor, insira um valor numérico para o intervalo de tempo."
            echo
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

    echo -e "____________________________________________________________\n"
    read -p "Por favor, insira as portas que deseja verificar se estão abertas (separadas por espaço): " portas

    # Modificar o arquivo visuli-main para incluir as portas a serem verificadas
    sed -i "s/\(portas=\"\)[^\"]*/\1$portas/" /usr/local/bin/visuli-main.sh

    funcoes=("systemInfo" "memoriaInfo" "diskInfo" "loadAverage" "logUsuarios" "log_size" "checkPortas")

    sed -i '157,163s/^#//' /usr/local/bin/visuli-main.sh
    echo -e "____________________________________________________________\n"
    echo "Selecione as funções que deseja desabilitar (separadas por espaço):"
    echo
    for ((i = 0; i < ${#funcoes[@]}; i++)); do
        echo "$(($i + 1)). ${funcoes[i]}"
    done
    echo
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

    echo -e "\n----------------------------------------"
    echo -e "Instalação concluída com sucesso!\n----------------------------------------"
    echo
    exit 0
}

adjusteRoutinaIntervalo() {
    echo -e "____________________________________________________________\n"
    read -p "Por favor, insira o intervalo de tempo desejado para a execução da rotina (em minutos, pressione Enter para usar o padrão de 5 minutos): " tempoMinutos

    # Verificar se o valor fornecido é um número
    re='^[0-9]+$'
    if ! [[ $tempoMinutos =~ $re ]]; then
        if [[ -z "$tempoMinutos" ]]; then
            # Definir um valor padrão de 5 minutos se nenhum valor for fornecido
            tempoMinutos=5
            echo "\nNenhum valor foi fornecido. O valor padrão de 5 minutos será utilizado."
        else
            echo -e "\nErro: Por favor, insira um valor numérico para o intervalo de tempo."
            echo
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

    echo -e "\n----------------------------------------"
    echo -e "Intervalo da rotina ajustado com sucesso!\n----------------------------------------"
}

configureFuncao() {
    funcoes=("systemInfo" "memoriaInfo" "diskInfo" "loadAverage" "logUsuarios" "log_size" "checkPortas")

    sed -i '157,163s/^#//' /usr/local/bin/visuli-main.sh
    echo -e "____________________________________________________________\n"
    echo "Selecione as funções que deseja desabilitar (separadas por espaço):"
    echo
    for ((i = 0; i < ${#funcoes[@]}; i++)); do
        echo "$(($i + 1)). ${funcoes[i]}"
    done
    echo
    read -p "Opções: " escolhas

    # Comenta as funções selecionadas pelo usuário
    for escolha in $escolhas; do
        index=$(($escolha + 156))
        if [[ $index -ge 157 && $index -le 163 ]]; then
            sed -i "${index}s/^/#/" /usr/local/bin/visuli-main.sh
        fi
    done

    echo -e "\n----------------------------------------"
    echo -e "Funções configuradas com sucesso!\n----------------------------------------"
}

configurePortas() {
    # Solicitar ao usuário as portas que deseja verificar se estão abertas
    echo -e "____________________________________________________________\n"
    read -p "Por favor, insira as portas que deseja verificar se estão abertas (separadas por espaço): " portas

    # Modificar o arquivo visuli-main.sh para incluir as portas a serem verificadas
    sed -i "s/\(portas=\"\)[^\"]*/\1$portas/" /usr/local/bin/visuli-main.sh

    echo -e "\n----------------------------------------"
    echo -e "Portas configuradas com sucesso!\n----------------------------------------"
}

while true; do
    echo -e "\n"
    echo "========================================"
    echo -e "Bem-vindo ao Visuli!\n========================================"
    echo -e "\nPor favor, selecione uma opção:"
    echo
    echo "1. Instalação"
    echo "2. Ajuste no intervalo da rotina"
    echo "3. Configuração de funções"
    echo "4. Configuração de portas"
    echo -e "0. Sair\n"
    read -p "Opção: " opcao

    case $opcao in
        1) installVisuli;;
        2) adjusteRoutinaIntervalo;;
        3) configureFuncao;;
        4) configurePortas;;
        0) echo
            echo -e "----------------------------------------\nSaindo..."
            echo -e "----------------------------------------\n"
            exit 0;;
        *) echo -e "\n----------------------------------------"
            echo -e "Opção inválida. Por favor, verifique.\n----------------------------------------"
            continue;;
    esac
done
