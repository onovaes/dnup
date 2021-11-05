#!/bin/bash


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
echo 'Atualizando o SGI...'
/usr/local/cpanel/3rdparty/bin/git pull && /usr/local/cpanel/3rdparty/bin/git describe --always > version.txt
echo "DATE_DEPLOY="$(date) >> version.txt
printf "\n"
echo 'Nova versao do SGI '
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
echo 'Atualizando o core do dothnews...'
/usr/local/cpanel/3rdparty/bin/git pull && /usr/local/cpanel/3rdparty/bin/git describe > version.txt
echo "DATE_DEPLOY="$(date) >> version.txt
printf "\n"
echo 'Nova versao do CORE do NEWS '
cat version.txt



#SETA PERMISSOES CORRETAS
printf "\n\n"
echo 'Permissão 644 em arquivos executaveis'
chmod 644 ~/public_html/image.php  
chmod 644 ~/public_html/index.php
printf "\n"

#SETA PERMISSOES CORRETAS
printf "\n\n"
echo 'Seta 755 to diretorios and 644 to files na pasta SGI'
find ~/public_html/dothnews -type d -print0 | xargs -0 chmod 0755
find ~/public_html/dothnews -type f -print0 | xargs -0 chmod 0644
printf "\n"

#VERSAO DO PHP
printf "\n\n"
echo 'Versão do PHP'
php -v


#MIGRATIONS
printf "\n\nInicio Migrations\n"
#php ~/public_html/index.php dnutils pre_migration
#php ~/public_html/index.php update migrate
php ~/public_html/dothnews/index.php update migrate


#TESTES UNTIARIOS
#php ~/public_html/index.php utest

#TEMPORARIAMENTE - GOOGLE ANALYTICS MAI LIDAS
#php ~/public_html/index.php dnutils google mais_lidas

echo 'Versao implementada: '
cat version.txt
