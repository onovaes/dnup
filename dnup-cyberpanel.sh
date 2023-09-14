#!/bin/bash

printf "\n\nHOME ATUAL:"
echo $HOME

# Verifica se o script está sendo executado como root
if [ "$(id -u)" == "0" ]; then
   echo "This script must NOT be run as root" 1>&2
   exit 1
fi


######################################
# INSTALACAO/ATUALIZACAo DO CORE BEGIN
if [ ! -d ~/public_html/application ]; then
    printf "\nVerifique antes de continuar:\n\n"
    printf "  1. A chave pública dothnews_key.pub deve estar vinculada ao Access Key do Repositórios, Core, Sgi e Tema\n"
    printf "  2. O diretório $HOME/public_html/ deve estar vazio\n"
    read -p "Deseja Prosseguir com nova instalação? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
    printf "\n\n"
    echo '... Clonando o CORE do NEWS'
    GIT_SSH_COMMAND='ssh -i ~/.ssh/dothnews_key -o IdentitiesOnly=yes' git clone git@bitbucket.org:dothcom/dothnews.git ~/public_html/
else
    printf "\n\n"
    echo '... Atualizando o CORE do NEWS'
    cd ~/public_html/
    GIT_SSH_COMMAND='ssh -i ~/.ssh/dothnews_key -o IdentitiesOnly=yes' git pull
fi
## INSTALACAO/ATUALIZACAo DO CORE END
######################################


#####################################
# INSTALACAO/ATUALIZACAo DO SGI BEGIN
if [ ! -d ~/public_html/dothnews ]; then
    read -p "Nova instalação SGI? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
    printf "\n\n"
    echo '... Clonando o SGI'
    GIT_SSH_COMMAND='ssh -i ~/.ssh/dothnews_key -o IdentitiesOnly=yes' git clone git@bitbucket.org:dothcom/sgi5.git ~/public_html/dothnews
else
    printf "\n\n"
    echo '... Atualizando o SGI'
    cd ~/public_html/dothnews/
    GIT_SSH_COMMAND='ssh -i ~/.ssh/dothnews_key -o IdentitiesOnly=yes' git pull
fi

if [ ! -f ~/public_html/.htaccess ]; then
    printf "\n\n"
    echo '... Copiando o .htaccess'
    cp ~/public_html/pipeline/htaccess/.htaccess  .htaccess
fi
## INSTALACAO/ATUALIZACAo DO SGI END
####################################




##################################################################################
## SETA PERMISSOES CORRETAS  image.php e index.php, em arquivos e diretorios BEGIN
printf "\n\n"
echo 'Seta Permissão 644 nos arquivos image.php e index.php'
chmod 644 ~/public_html/image.php  
chmod 644 ~/public_html/index.php
chmod 644 ~/public_html/dothnews/index.php
printf "\n"

echo 'Seta Permissão 755 para 644 para files na pasta SGI'
find ~/public_html/dothnews -type d -print0 | xargs -0 chmod 0755
find ~/public_html/dothnews -type f -print0 | xargs -0 chmod 0644
printf "\n"
## SETA PERMISSOES CORRETAS  image.php e index.php, em arquivos e diretorios END
##################################################################################


#########################
## GERA version.txt BEGIN
cd ~/public_html/
gera_versao

cd ~/public_html/dothnews/
gera_versao 

gera_versao()
{
    printf "\n\n"
    echo '... Gerando version.txt'
    DESCRIBE_VERSION=$(GIT_SSH_COMMAND='ssh -i ~/.ssh/dothnews_key -o IdentitiesOnly=yes' git describe)
    BRANCH_NAME=$(GIT_SSH_COMMAND='ssh -i ~/.ssh/dothnews_key -o IdentitiesOnly=yes' git rev-parse --abbrev-ref HEAD)
    DEPLOY_DATE=$(date)
    echo "$DESCRIBE_VERSION-$BRANCH_NAME" > version.txt
    echo "$DEPLOY_DATE" >> version.txt
}
## GERA version.txt END
#######################


#####################
## DEPLOY THEME BEGIN
DIRETORIO_THEME=$(basename $HOME)
echo $DIRETORIO_THEME
if [ ! -d ~/public_html/application/themes/$DIRETORIO_THEME ]; then

    # input your repo name
    printf "\n\n"
    read -p "Enter Bitbucket Theme Repo Name (Ex: dothcom/veja-o-bem): " REPONAME

    echo 'Clonando $REPONAME tema em ~/public_html/application/themes/$DIRETORIO_THEME'
    GIT_SSH_COMMAND='ssh -i ~/.ssh/dothnews_key -o IdentitiesOnly=yes' git clone git@bitbucket.org:$REPONAME.git ~/public_html/application/themes/$DIRETORIO_THEME
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
