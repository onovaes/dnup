#!/bin/bash

#alias para git no cpanel
alias git="/usr/local/cpanel/3rdparty/bin/git"

printf "\n"


# Atualizando o sgi
cd ~/public_html/dothnews/
echo 'Atualizando o SGI...'
git pull
printf "\n"



#atualiza o core do dothnews
echo 'Atualizando o core do dothnews...'
cd ~/public_html/
git pull
printf "\n"


#SETA PERMISSAO CORRETA
echo 'Permissão 644 em arquivos executaveis'
chmod 644 ~/public_html/dothnews/index.php
chmod 644 ~/public_html/image.php  
chmod 644 ~/public_html/index.php
printf "\n"

#testes untiarios
php ~/public_html/index.php utest
