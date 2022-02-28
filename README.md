# Shell Script para atualização de DN nas VM's 

Atualiza o SGI, o Core, Roda as migrations e testes unitários. 

A partir da versão 2.1.39, todos os DN'S, nas VM's devem ser atualizados somente via script

## Executa 
    wget -O - https://raw.githubusercontent.com/onovaes/dnup/master/dnup.sh | bash

## Executa e salva a saída em dnup.log
    wget -O - https://raw.githubusercontent.com/onovaes/dnup/master/dnup.sh | bash > ~/dnup.log

