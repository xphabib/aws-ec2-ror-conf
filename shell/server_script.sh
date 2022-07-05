RUBY_VERSION="2.6.3"
NODE_VERSION="16.14.2"
POSTGRES_USER="habib"
POSTGRES_DB="testDB"
POSTGRES_HOST="127.0.0.1"
GIT_REPO="https://github.com/xphabib/newspaper.git"
GIT_USER="Habib"
GIT_EMAIL="habib@gmail.com"
MAIN_DIR="app"
APP_DIR="newspaper"
APP_NAME="Habibi"
DEFENDENCIY=true

if ! [ -x "$(command -v rvm)" ]; then
    echo 'rvm is not installed.'
    echo 'rvm install processing...'
    sudo apt-get update
    echo '-----gnupg2------'
    sudo apt install gnupg2
    gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    cd /tmp
    echo '-----curl------'
    sudo apt install curl
    curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
    curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
    echo '-----rvm------'
    curl -sSL https://get.rvm.io -o rvm.sh
    cat /tmp/rvm.sh | bash -s stable --rails
    DIR="/home/$USER/.rvm/scripts/rvm"
    source $DIR
    rvm install $RUBY_VERSION
    rvm use --default $RUBY_VERSION
    ruby -v
else
    DIR="/home/$USER/.rvm/scripts/rvm"
    echo $DIR
    source $DIR
    rvm install $RUBY_VERSION
    rvm use --default $RUBY_VERSION
    ruby -v
fi

if ! [ -x "$(command -v rails)" ]; then
    echo "rails installing..."
    #gem install rails
else
    echo "=============rails already installd for this version======="
    rails -v
fi

if ! [ -x "$(command -v bundle)" ]; then
    echo "bundler installing..."
    gem install bundler
else
    echo "===========bundler already installd for this version============"
    bundler -v
fi


# if ! [ -x "$(command -v nvm)" ]; then
#     DIR="/home/$USER/.nvm/nvm.sh"
#     curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh -o install_nvm.sh
#     bash install_nvm.sh
#     echo $DIR
#     source $DIR
#     nvm install $NODE_VERSION
#     nvm use $NODE_VERSION
#     node -v
# else
#     DIR="/home/$USER/.nvm/nvm.sh"
#     echo $DIR
#     source $DIR
#     nvm use $NODE_VERSION
#     node -v
# fi

#############yarn#######
if ! [ -x "$(command -v yarn)" ]; then
    echo "---------yarn--------"
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update && sudo apt install yarn
    yarn -v
else
    echo "========yarn already installed========="
    yarn -v
fi


#######nginx##########
if ! [ -x "$(command -v nginx)" ]; then
    echo "---------nginx--------"
    sudo apt-get install nginx
    sudo systemctl nginx redis.service
else
    echo "========nginx already installed========="
    sudo systemctl nginx redis.service
fi

#######nginx##########
if ! [ -x "$(command -v redis-server)" ]; then
    echo "---------redis--------"
    sudo apt update
    sudo apt install redis-server
    sudo nano /etc/redis/redis.conf -> supervised systemd
    sudo systemctl restart redis.service
else
    echo "========redis already installed========="
    sudo systemctl restart redis.service
fi

#######postgresql##########
if ! [ -x "$(command -v psql)" ]; then
    echo "---------postgresql--------"
    sudo apt-get install postgresql postgresql-contrib libpq-dev
    sudo -u postgres createuser -s $POSTGRES_USER
    echo "-------setup psql-----------"
    echo "Enter the command below and enter your password"
    echo "\password $POSTGRES_USER"
    sudo -u postgres psql
    sudo -u postgres createdb -O $POSTGRES_USER $POSTGRES_DB
    sudo service postgresql restart
    echo "enter \q for exit"
    psql -U $POSTGRES_USER -h $POSTGRES_HOST $POSTGRES_DB
    echo "=======work fine========="
else
    echo "========postgresql postgresql installed========="
    sudo service postgresql restart
fi

#######postgresql##########
if ! [ -x "$(command -v git)" ]; then
    sudo apt-get install git-core
    git --version
    git config --global user.name $GIT_USER
    git config --global user.email $GIT_EMAIL
else
    echo "========git already installed========="
fi

if $DEFENDENCIY; then
    #############dependency##########
    echo "1. Failed to build gem native extension: json"
    sudo apt-get install libgmp3-dev
    echo "2. Failed to build gem native extension: rmagick"
    sudo apt-get install libmagickwand-dev
    #3. Failed to build gem native extension: mysql2
    #Solution: sudo apt-get install libmysqlclient-dev
    #4. ExecJS::RuntimeUnavailable: Could not find a JavaScript runtime
    #Solution: sudo apt-get install nodejs
    #5. Failed to build gem native extension: pg
    #Solution: sudo apt-get install libpq-dev
fi


if [ -d "$MAIN_DIR" ]; then
    cd $MAIN_DIR
else
    mkdir $MAIN_DIR
    cd $MAIN_DIR
fi

if [ -d "$APP_DIR" ]; then
    cd $APP_DIR
    ruby -v
    bundle install
else
    # rails new $APP_NAME
    # cd $APP_NAME
    # bundle install
    ruby -v
    git clone $GIT_REPO
    cd $APP_DIR
    bundle install
fi