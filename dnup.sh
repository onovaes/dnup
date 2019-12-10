#!/bin/bash

#alias para git no cpanel
alias git="/usr/local/cpanel/3rdparty/bin/git"

# Atualizando o sgi
printf "\n"
cd ~/public_html/dothnews/
echo 'Atualizando o SGI...'
git pull

#ATUALIZA O CORE
printf "\n"
echo 'Atualizando o core do dothnews...'
cd ~/public_html/
git pull

#SETA PERMISSOES CORRETAS
printf "\n"
echo 'Permissão 644 em arquivos executaveis'
chmod 644 ~/public_html/dothnews/index.php
chmod 644 ~/public_html/image.php  
chmod 644 ~/public_html/index.php
printf "\n"


#MIGRATIONS
php ~/public_html/index.php update migrate


#TESTES UNTIARIOS
php ~/public_html/index.php utest
