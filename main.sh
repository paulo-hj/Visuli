#!/bin/sh
#-------------------------------------------------------------------#
# AUTOR: Paulo Henrique
# LINKEDIN: https://www.linkedin.com/in/paulo-henrique-oj/
# GITHUB: https://github.com/paulo-hj
#-------------------------------------------------------------------#

# Configuracao
refreshTimePage='60'
titulo="visuli"
versao="1.0"


memoriaInfo(){
    echo "Memória:" >> visuli.html
    free -mh >> visuli.html
    echo "" >> visuli.html

}

diskInfo(){
    echo "" >> visuli.html
    echo "Espaço em disco:" >> visuli.html
    df -h >> visuli.html
    echo "" >> visuli.html
}

loadAverage(){
    echo "" >> visuli.html
    echo "Load average" >> visuli.html
    uptime | awk -F 'load average:' '{print $2}' >> visuli.html
    echo "" >> visuli.html
}


memoriaInfo
diskInfo
loadAverage
