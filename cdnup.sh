#!/bin/bash

#Printa Home Atual SOMENTE A NIVEL DE INFORMACAO
printf "\n\nHOME ATUAL: "
echo $HOME

printf "\n\n"
cd ~/public_html/

# Garantindo que o git esteja com fileMode false
printf "\n"
echo 'Set file mode FALSE no GIT'
/usr/bin/git config core.fileMode false

echo 'Versao atual da CDN: '
git describe
printf "\n"

echo 'Iniciando PULL  ...'
/usr/bin/git pull && /usr/bin/git describe > version.txt

#get current branch
/usr/bin/git rev-parse --abbrev-ref HEAD >> version.txt

echo "DATE_DEPLOY="$(date) >> version.txt
printf "\n"
echo 'Versão do Core Implementada:'
cat version.txt
### END ATUALIZA O CORE

#CSV info files version.csv
DESCRIBE_VERSION=$(/usr/bin/git describe)
BRANCH_NAME=$(/usr/bin/git rev-parse --abbrev-ref HEAD)
echo -ne "$DESCRIBE_VERSION, $BRANCH_NAME" > version.csv

#SETA PERMISSOES CORRETAS  image.php e index.php
printf "\n\n"
echo 'Seta Permissão 644 nos arquivos image.php e index.php'
chmod 644 ~/public_html/image.php  
printf "\n"


echo 'Arquivo version.txt final ->'
cat version.txt