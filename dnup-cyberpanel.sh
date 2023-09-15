#!/bin/bash


##########################
# Algumas validações BEGIN
if [ "$(id -u)" == "0" ]; then
   echo "This script must NOT be run as root" 1>&2
   exit 1
fi


if [ ! -f ~/.ssh/dothnews_key ]; then
    echo "Chave dothnews_key não encontrada em ~/.ssh/dothnews_key" 1>&2
    exit 1
fi

if [ -z ${THEME_REPOSITORY+x} ]; then
    echo "THEME_REPOSITORY env var is unset" 1>&2
    exit 1
fi
# Algumas validações END
########################




######################################
# INSTALACAO/ATUALIZACAo DO CORE BEGIN
if [ ! -d ~/public_html/application ]; then
    printf "\nVerifique antes de continuar:\n\n"
    printf "  1. A chave pública dothnews_key.pub deve estar vinculada ao Access Key do Repositórios, Core, Sgi e Tema;\n"
    printf "  2. O diretório $HOME/public_html/ deve estar vazio;\n"
    printf "\n\n"

    #read -p "Press enter to continue or Ctrl+C to exit"

    printf "\n\n"
    printf "... Clonando o CORE do NEWS"
    GIT_SSH_COMMAND='ssh -i ~/.ssh/dothnews_key -o IdentitiesOnly=yes' git clone git@bitbucket.org:dothcom/dothnews.git ~/public_html/
else
    printf "\n\n"
    printf "... Atualizando o CORE do DOTHNEWS em $HOME/public_html/"
    cd ~/public_html/
    GIT_SSH_COMMAND='ssh -i ~/.ssh/dothnews_key -o IdentitiesOnly=yes' git pull
fi
## INSTALACAO/ATUALIZACAo DO CORE END
######################################


#####################################
# INSTALACAO/ATUALIZACAo DO SGI BEGIN
if [ ! -d ~/public_html/dothnews ]; then
    #read -p "Press enter to continue or Ctrl+C to exit"
    printf "\n\n"
    printf "... Clonando o SGI"
    GIT_SSH_COMMAND='ssh -i ~/.ssh/dothnews_key -o IdentitiesOnly=yes' git clone git@bitbucket.org:dothcom/sgi5.git ~/public_html/dothnews
else
    printf "\n\n"
    printf "... Atualizando o SGI em $HOME/public_html/dothnews/"
    cd ~/public_html/dothnews/
    GIT_SSH_COMMAND='ssh -i ~/.ssh/dothnews_key -o IdentitiesOnly=yes' git pull
fi

if [ ! -f ~/public_html/.htaccess ]; then
    printf "\n\n"
    printf "... Copiando o .htaccess para $HOME/public_html/"
    cp ~/public_html/pipeline/htaccess/.htaccess  ~/public_html/.htaccess
fi
## INSTALACAO/ATUALIZACAo DO SGI END
####################################




##################################################################################
## SETA PERMISSOES CORRETAS  image.php e index.php, em arquivos e diretorios BEGIN
printf "\n\n"
printf "Seta Permissão 644 nos arquivos image.php e index.php"
chmod 644 ~/public_html/image.php  
chmod 644 ~/public_html/index.php
chmod 644 ~/public_html/dothnews/index.php
printf "\n"

printf "Seta Permissão 755 para 644 para files na pasta SGI"
find ~/public_html/dothnews -type d -print0 | xargs -0 chmod 0755
find ~/public_html/dothnews -type f -print0 | xargs -0 chmod 0644
printf "\n"
## SETA PERMISSOES CORRETAS  image.php e index.php, em arquivos e diretorios END
##################################################################################


#########################
## GERA version.txt BEGIN
gera_versao()
{
    printf "\n\n"
    printf "... Gerando version.txt"
    DESCRIBE_VERSION=$(GIT_SSH_COMMAND='ssh -i ~/.ssh/dothnews_key -o IdentitiesOnly=yes' git describe)
    BRANCH_NAME=$(GIT_SSH_COMMAND='ssh -i ~/.ssh/dothnews_key -o IdentitiesOnly=yes' git rev-parse --abbrev-ref HEAD)
    DEPLOY_DATE=$(date)
    echo "$DESCRIBE_VERSION-$BRANCH_NAME" > version.txt
    echo "$DEPLOY_DATE" >> version.txt
}

cd ~/public_html/
gera_versao

cd ~/public_html/dothnews/
gera_versao
## GERA version.txt END
#######################


#####################
## DEPLOY THEME BEGIN
DIRETORIO_THEME=$(basename $HOME)
echo $DIRETORIO_THEME
if [ ! -d ~/public_html/application/themes/$DIRETORIO_THEME ]; then
    echo 'Clonando $THEME_REPOSITORY tema em ~/public_html/application/themes/$DIRETORIO_THEME'
    GIT_SSH_COMMAND='ssh -i ~/.ssh/dothnews_key -o IdentitiesOnly=yes' git clone git@bitbucket.org:$THEME_REPOSITORY.git ~/public_html/application/themes/$DIRETORIO_THEME
else
    printf "Atualizando o tema em ~/public_html/application/themes/$DIRETORIO_THEME\n"
    cd ~/public_html/application/themes/$DIRETORIO_THEME
    GIT_SSH_COMMAND='ssh -i ~/.ssh/dothnews_key -o IdentitiesOnly=yes' git pull
fi
## DEPLOY THEME END
###################


############################
## MIGRATIONS E TESTES BEGIN
printf "\n\nINICIO MIGRATIONS:\n"
/usr/local/lsws/lsphp56/bin/php ~/public_html/index.php dnutils pre_migration
/usr/local/lsws/lsphp56/bin/php ~/public_html/index.php update migrate
/usr/local/lsws/lsphp56/bin/php ~/public_html/dothnews/index.php update migrate
/usr/local/lsws/lsphp56/bin/php ~/public_html/index.php utest
printf "\nFIM MIGRATIONS:\n"
## MIGRATIONS E TESTES END
##########################
