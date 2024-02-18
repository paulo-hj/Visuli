#!/bin/sh
#-------------------------------------------------------------------#
# AUTOR: Paulo Henrique
# LINKEDIN: https://www.linkedin.com/in/paulo-henrique-oj/
# GITHUB: https://github.com/paulo-hj
#-------------------------------------------------------------------#

# Configuracao
refreshTimePage='60'
titulo="Visuli"
versao="1.0"

htmlInicio(){
    echo "<!DOCTYPE html>"
    echo "<html lang='pt-BR'>"
    echo "<head>"
    echo "<meta charset='UTF-8'>"
    #echo "<meta http-equiv='refresh' content='$refreshTimePage'>"
    echo "<title>$titulo v$versao</title>"
    echo "</head>"
    echo "<body>"
} >> visuli.html

htmlFinal(){
      echo "<body/></html>" >> visuli.html
}

limparaArquivo(){
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

    if [ "$valor" -le 50 ]; then
        echo "<p class='diskok'>BOM: $caminho com ${valor}% usado!</p>"
    elif [ "$valor" -lt 90 ]; then
        echo "<p class='diskwarning'>ALERTA: $caminho com ${valor}% usado!</p>"
    elif [ "$valor" -ge 90 ]; then
        echo "<p class='diskdanger'>DISCO CHEIO: $caminho com ${valor}% usado!</p>"
    fi

    echo "<pre>$dicototal</pre>"
    echo "<hr>"
} >> visuli.html

loadAverage(){
    echo "<h2>Load average</h2>"
    uptime | awk -F 'load average:' '{print $2}'
    echo "<hr>"
} >> visuli.html

usuarios(){
    echo "<h2>Usuário logados</h2>"
    echo "<p class='userson'>Tem <b>\"$(who | wc -l)\"</b> usuários logados.</p>"
    echo "<pre>$(who -s)</pre>"
    echo "<hr>"
} >> visuli.html

systemInfo(){
  . /etc/os-release
  echo "<h2>Informações do sistema</h2>"
  echo "<b>Hostname: $(hostname)</b>"
  echo "<b>Distribuition:</b> "$PRETTY_NAME" </br>"
  echo "<b>Kernel:</b> "$(uname -r)"<br>"
  echo "<b>Uptime:</b> "$(uptime -p | sed 's/up//')"</p>"
  echo "<hr>" 
} >> visuli.html


limparaArquivo
htmlInicio
systemInfo
memoriaInfo
diskInfo
loadAverage
usuarios
htmlFinal
