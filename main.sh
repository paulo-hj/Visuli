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


memoriaInfo() {
    echo "<pre>" > visuli.html
    echo "Memória:" >> visuli.html
    free -mh >> visuli.html

}

diskInfo() {
    echo "" >> visuli.html
    echo "Espaço em disco:" >> visuli.html
    df -h >> visuli.html
    echo "</pre>" >> visuli.html
}


memoriaInfo
diskInfo
