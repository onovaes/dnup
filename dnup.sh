#!/bin/bash


#VERSAO DO PHP SOMENTE A NIVEL DE INFORMACAO
printf "\n\nVersão do PHP:\n"
php -v

#Printa Home Atual SOMENTE A NIVEL DE INFORMACAO
printf "\n\nHOME ATUAL: "
echo $HOME


### ATUALIZANDO O SGI
printf "\n\n"
cd ~/public_html/dothnews/

# Garantindo que o git esteja com fileMode false
printf "\n"
echo 'Set file mode no GIT'
/usr/local/cpanel/3rdparty/bin/git config core.fileMode false

echo 'Versao atual do SGI '
/usr/local/cpanel/3rdparty/bin/git describe
printf "\n"
echo 'Iniciando PULL do SGI ...'
/usr/local/cpanel/3rdparty/bin/git pull && /usr/local/cpanel/3rdparty/bin/git describe --always > version.txt
echo "DATE_DEPLOY="$(date) >> version.txt
printf "\n"
echo 'Versão do SGI Implementada:'
cat version.txt

### ATUALIZA O CORE
printf "\n\n"
cd ~/public_html/

# Garantindo que o git esteja com fileMode false
printf "\n"
echo 'Set file mode no GIT'
/usr/local/cpanel/3rdparty/bin/git config core.fileMode false

echo 'Versao atual do CORE DO NEWS '
/usr/local/cpanel/3rdparty/bin/git describe
printf "\n"
echo 'Iniciando PULL do core ...'
/usr/local/cpanel/3rdparty/bin/git pull && /usr/local/cpanel/3rdparty/bin/git describe > version.txt
echo "DATE_DEPLOY="$(date) >> version.txt
printf "\n"
echo 'Versão do Core Implementada:'
cat version.txt



#SETA PERMISSOES CORRETAS
printf "\n\n"
echo 'Seta Permissão 644 nos arquivos image.php e index.php'
chmod 644 ~/public_html/image.php  
chmod 644 ~/public_html/index.php
printf "\n"

#SETA PERMISSOES CORRETAS
printf "\n\n"
echo 'Seta Permissão 755 para 644 para files na pasta SGI'
find ~/public_html/dothnews -type d -print0 | xargs -0 chmod 0755
find ~/public_html/dothnews -type f -print0 | xargs -0 chmod 0644
printf "\n"



# MIGRATIONS
printf "\n\nINICIO MIGRATIONS:\n"

if test -f "/usr/local/bin/php"; then
    /usr/local/bin/php ~/public_html/index.php dnutils pre_migration
    printf "\n"
    /usr/local/bin/php ~/public_html/index.php update migrate
    printf "\n"
    /usr/local/bin/php ~/public_html/dothnews/index.php update migrate
    printf "\nFIM MIGRATIONS:\n"

    /usr/local/bin/php ~/public_html/index.php utest
else
    php ~/public_html/index.php dnutils pre_migration
    printf "\n"
    php ~/public_html/index.php update migrate
    printf "\n"
    php ~/public_html/dothnews/index.php update migrate
    printf "\nFIM MIGRATIONS:\n"

    php ~/public_html/index.php utest
fi



echo 'Versao implementada: '
cat version.txt
