# Shell Script para atualização de DN nas VM's e na CDN

Atualiza o SGI, o Core, Roda as migrations e testes unitários. 

## Core e SGI (Cpanel)
    wget -O - https://raw.githubusercontent.com/onovaes/dnup/master/dnup.sh | bash

## CDN
    wget -O - https://raw.githubusercontent.com/onovaes/dnup/master/cdnup.sh | bash

