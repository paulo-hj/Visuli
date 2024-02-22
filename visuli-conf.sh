#!/bin/bash

echo "Bem-vindo à instalação do Visuli!"

# Solicitar ao usuário as portas que deseja verificar se estão abertas
read -p "Por favor, insira as portas que deseja verificar se estão abertas (separadas por espaço): " portas

# Modificar o arquivo visuli-main para incluir as portas a serem verificadas
sed -i "s/\(portas=\"\)[^\"]*/\1$portas/" visuli-main

chmod +x visuli-main
sudo cp visuli-main /usr/local/bin/

sudo mkdir -p /var/www/html/visuli-main
