#!/bin/sh
#-------------------------------------------------------------------#
# AUTOR: Paulo Henrique
# LINKEDIN: https://www.linkedin.com/in/paulo-henrique-oj/
# GITHUB: https://github.com/paulo-hj
#-------------------------------------------------------------------#

# Configuracao
refreshTimePage='5'
versao="1.5"

cssCod(){
    echo "
    body {background-color: #e7edea; color: black; font-family: monospace, sans-serif; max-width: 1000px; margin: 0 auto; padding: 0 10px; font-size: 14px;}
    h1 {
    color: #46685b; text-align: center; margin-top: 0; padding: 35px 20px 0;
    }
    .titulo {font-size: 28px; color: #46685b;}
    .versao {font-size: 14px; color: #999; margin-left: 867px; display: block;}
    .linhatitulo {width: 100%; background-color: gray; padding: 0.3%;}
    .verificaok {width: 50%; color: white; background-color: green; padding: 0.7%;}
    .verificaproblema {width: 50%; color: black; background-color: yellow; padding: 0.7%;}
    .verificaalerta {width: 50%; color: black; background-color: red; padding: 0.7%;}
    pre {white-space: pre-wrap; word-wrap: break-word;}
    hr {margin-top: 3%; margin-bottom: 3%; border-color: gray; border-style: dotted;}
    @media only screen and (max-width: 600px) {
        body {font-size: 13px;}
        .portopen, .portdown, .linhatitulo, .verificaok, .verificaproblema, .verificaalerta {width: 94%; padding: 3%; margin-bottom: 3%;}
    }"
}

htmlInicio(){
    css="$(cssCod)"
    echo "
    <!DOCTYPE html>
    <html lang='pt-BR'>
    <head>
        <title>Visuli $versao</title>
        <meta charset='UTF-8'>
        <!--<meta http-equiv='refresh' content='$refreshTimePage'> -->
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <style>
            $css
        </style>
    </head>
    <body>
        <div id='main'>
            <h1>
                <span class="titulo">Visuli</span>
                <span class="versao">Versão: $versao</span>
            </h1>
            <p class='linhatitulo'> </p><br><br>
    "
} >> visuli.html

htmlFinal(){
    # Salva todas as linhas, exceto a última, em um novo arquivo temporário
    head -n -1 visuli.html > temp.html
    # Move o arquivo temporário de volta para o arquivo original
    mv temp.html visuli.html

    echo "<br><br>
    <p class='linhatitulo'> </p><br><br><br>
    <body/></html>" >> visuli.html
}

limparArquivo(){
    > visuli.html
}

memoriaInfo(){
    echo "<h2>Memória</h2>"
    echo "<pre>$(free -mh)</pre>"
    echo "<hr>"
} >> visuli.html

diskInfo(){
    caminho=$(df -h 2>/dev/null | grep '/$' | awk '{print $1}')
    valor=$(df -h 2>/dev/null | grep '/$' | awk '{print $5}' | tr -d %)
    dicototal=$(df -H 2>/dev/null | grep -vE "^Filesystem|tmpfs|none|cdrom|udev")

    echo "<h2>Disk</h2>"

    if [ "$valor" -le 70 ]; then
        echo "<p class='verificaok'><b>Armazenamento normal:</b> $caminho com ${valor}% usado!</p>"
    elif [ "$valor" -lt 90 ]; then
        echo "<p class='verificaproblema'><b>Armazenamento moderado:</b> $caminho com ${valor}% usado!</p>"
    elif [ "$valor" -ge 90 ]; then
        echo "<p class='verificaalerta'><b>Armazenamento alto:</b> $caminho com ${valor}% usado!</p>"
    fi

    echo "<pre>$dicototal</pre>"
    echo "<hr>"
} >> visuli.html

loadAverage(){
    load=$(uptime | awk -F 'load average:' '{print $2}')
    load1=$(echo "$load" | awk '{print int($1)}')  # Arredondar para o inteiro mais próximo

    echo "<h2>Load average</h2>"

    if [ "$load1" -ge 10 ]; then
        echo "<p class='verificaalerta'><b>Processamento alto:</b> Load $load</p>"
    elif [ "$load1" -ge 5 ]; then
        echo "<p class='verificaproblema'><b>Processamento moderado:</b> Load $load</p>"
    else
        echo "<p class='verificaok'><b>Processamento normal:</b> Load $load</p>"
    fi
    echo "<hr>"
} >> visuli.html

logUsuarios(){
    echo "<h2>Log de usuários</h2>"
    echo "Tem $(who | wc -l) usuários logados! <br>"
    echo "<pre>$(who -s)</pre>"
    echo "<hr>"
} >> visuli.html

systemInfo(){
    . /etc/os-release
    echo "<h2>Informações do sistema</h2>"
    echo "<b>IP:</b> $(hostname -i)<br>"
    echo "<b>Hostname:</b> $(hostname)<br>"
    echo "<b>Distribuição:</b> $PRETTY_NAME <br>"
    echo "<b>Kernel:</b> $(uname -r)<br>"
    echo "<b>Uptime:</b> $(uptime -p | sed 's/up//')<br>"
    echo "<hr>"
} >> visuli.html

log_size(){
    echo "<h2>TOP 8 log size</h2>"
    echo "<pre>$(du -hs /var/log/* | sort -hr | grep -vE '^0' | head -n 10)</pre>"
    echo "<hr>"
} >> visuli.html

limparArquivo
htmlInicio
systemInfo
memoriaInfo
diskInfo
loadAverage
logUsuarios
log_size
htmlFinal
