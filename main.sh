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
    echo "<!DOCTYPE html>" >> visuli.html
    echo "<html lang='pt-BR'>" >> visuli.html
    echo "<head>" >> visuli.html
    echo "<meta charset='UTF-8'>" >> visuli.html
    echo "<meta http-equiv='refresh' content='$refreshTimePage'>" >> visuli.html
    echo "<title>$titulo v$versao</title>" >> visuli.html
    echo "</head>" >> visuli.html
    echo "<body>" >> visuli.html
}

htmlFinal(){
      echo "<body/></html>" >> visuli.html
}

limparaArquivo(){
    > visuli.html
}

memoriaInfo(){
    echo "<h2>Memória:</h2>" >> visuli.html
    free -mh >> visuli.html
    echo "<hr>" >> visuli.html
}

diskInfo(){
    echo "<h2>Espaço em disco:</h2>" >> visuli.html
    df -h >> visuli.html
    echo "<hr>" >> visuli.html
}

loadAverage(){
    echo "<h2>Load average</h2>" >> visuli.html
    uptime | awk -F 'load average:' '{print $2}' >> visuli.html
    echo "<hr>" >> visuli.html
}

usuarios(){
    echo "<h2>Usuário logados:</h2>" >> visuli.html
    echo "<p class='userson'>Tem <b>\"$(who | wc -l)\"</b> usuários logados.</p>" >> visuli.html
    echo "<pre>$(who -s)</pre>" >> visuli.html
    echo "<hr>" >> visuli.html
}

limparaArquivo
htmlInicio
memoriaInfo
diskInfo
loadAverage
usuarios
htmlFinal
