# Shell Script para atualização de DN nas VM's 

Atualiza o SGI, o Core, Roda as migrations e testes unitários. 

A partir da v2.1.39 do core, e da v1.3.0 da CDN, fazer deploy somente com esse script.

## Core e SGI 
    wget -O - https://raw.githubusercontent.com/onovaes/dnup/master/dnup.sh | bash > ~/dnup.log


## CDN
    wget -O - https://raw.githubusercontent.com/onovaes/dnup/master/cdnup.sh | bash > ~/cdnup.log

