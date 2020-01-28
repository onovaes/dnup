# Shell Script para atualização de DN nas VM's

Atualiza o SGI, o core, roda as migrations e testes unitários. 

A partir da versão 2.1.39, todos os DN'S, nas VM's devem ser atualizados somente via script

wget -O - https://raw.githubusercontent.com/onovaes/dnup/master/dnup.sh | bash

