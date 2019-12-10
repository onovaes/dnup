#!/bin/bash


# ATUALIZANDO O SGI
printf "\n"
cd ~/public_html/dothnews/
echo 'Atualizando o SGI...'
/usr/local/cpanel/3rdparty/bin/git pull


# ATUALIZA O CORE
printf "\n"
echo 'Atualizando o core do dothnews...'
cd ~/public_html/
/usr/local/cpanel/3rdparty/bin/git pull


#SETA PERMISSOES CORRETAS
printf "\n"
echo 'Permissão 644 em arquivos executaveis'
chmod 644 ~/public_html/dothnews/index.php
chmod 644 ~/public_html/image.php  
chmod 644 ~/public_html/index.php
printf "\n"


#MIGRATIONS
php ~/public_html/index.php dnutils pre_migration
php ~/public_html/index.php update migrate
php ~/public_html/dothnews/index.php update migrate


#TESTES UNTIARIOS
php ~/public_html/index.php utest

#TEMPORARIAMENTE - GOOGLE ANALYTICS MAI LIDAS
php ~/public_html/index.php dnutils google mais_lidas
