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
/usr/bin/git pull 

printf "\n"
echo 'Nova Versão Instalada:'
/usr/bin/git describe 

#Gera o txt com as infos no formato CSV
DESCRIBE_VERSION=$(/usr/bin/git describe)
BRANCH_NAME=$(/usr/bin/git rev-parse --abbrev-ref HEAD)
DEPLOY_DATE=$(date)
echo "$DESCRIBE_VERSION-$BRANCH_NAME" > version.txt
echo "$DEPLOY_DATE" >> version.txt

#SETA PERMISSOES CORRETAS  image.php e index.php
printf "\n\n"
echo 'Seta Permissão 644 nos arquivos image.php e index.php'
chmod 644 ~/public_html/image.php  
printf "\n"


echo 'Arquivo version.txt final ->'
cat version.txt