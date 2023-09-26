#!/bin/bash

printf "\n\nHOME ATUAL: "
echo $HOME


###########################
### BEGIN ATUALIZANDO O SGI
printf "\n\n"
cd ~/public_html/dothnews/

printf "\n"
echo 'Set file mode FALSE no GIT'
/usr/local/cpanel/3rdparty/bin/git config core.fileMode false

echo 'Versao atual do SGI '
/usr/local/cpanel/3rdparty/bin/git describe

printf "\n"
echo 'Iniciando PULL do SGI ...'
/usr/local/cpanel/3rdparty/bin/git pull 

insert_config_in_htaccess()
{
    htaccess_file=~/public_html/dothnews/.htaccess

    if [ ! -f $htaccess_file ]; then
        echo "#----------------------------------------------------------------cp:ppd" >> $htaccess_file
        echo "# Section managed by cPanel: Password Protected Directories     -cp:ppd" >> $htaccess_file
        echo "# - Do not edit this section of the htaccess file!              -cp:ppd" >> $htaccess_file
        echo "#----------------------------------------------------------------cp:ppd" >> $htaccess_file
        echo "AuthType Basic" >> $htaccess_file
        echo 'AuthName "Protected Folder"' >> $htaccess_file
        echo 'AuthUserFile "/$home/.htpasswds/public_html/dothnews/passwd"' >> $htaccess_file
        echo "Require valid-user" >> $htaccess_file 
        echo "#----------------------------------------------------------------cp:ppd" >> $htaccess_file
        echo "# End section managed by cPanel: Password Protected Directories -cp:ppd"  >> $htaccess_file
        echo "#----------------------------------------------------------------cp:ppd" >> $htaccess_file
    fi
}

#Gera o txt com as infos nde versao
DESCRIBE_VERSION=$(/usr/local/cpanel/3rdparty/bin/git describe)
BRANCH_NAME=$(/usr/local/cpanel/3rdparty/bin/git rev-parse --abbrev-ref HEAD)
DEPLOY_DATE=$(date)
echo "$DESCRIBE_VERSION-$BRANCH_NAME" > version.txt
echo "$DEPLOY_DATE" >> version.txt

### END ATUALIZANDO O SGI
#########################



#########################
### BEGIN ATUALIZA O CORE
printf "\n\n"
cd ~/public_html/

echo 'Set file mode FALSE no GIT'
/usr/local/cpanel/3rdparty/bin/git config core.fileMode false

echo 'Versao atual do CORE DO NEWS '
/usr/local/cpanel/3rdparty/bin/git describe
printf "\n"

echo 'Iniciando PULL do core ...'
/usr/local/cpanel/3rdparty/bin/git pull 

#Gera o txt com as infos nde versao
DESCRIBE_VERSION=$(/usr/local/cpanel/3rdparty/bin/git describe)
BRANCH_NAME=$(/usr/local/cpanel/3rdparty/bin/git rev-parse --abbrev-ref HEAD)
DEPLOY_DATE=$(date)
echo "$DESCRIBE_VERSION-$BRANCH_NAME" > version.txt
echo "$DEPLOY_DATE" >> version.txt

### END ATUALIZA O CORE
#######################



#SETA PERMISSOES CORRETAS  image.php e index.php
printf "\n\n"
echo 'Seta Permissão 644 nos arquivos image.php e index.php'
chmod 644 ~/public_html/image.php  
chmod 644 ~/public_html/index.php
printf "\n"

#SETA PERMISSOES CORRETAS todos arquivos
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

    printf "\nInicia testes Unitários:\n"
    php ~/public_html/index.php utest
fi



echo 'Versao implementada: '
cat version.txt
