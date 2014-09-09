#NodeJS and brew should be preinstalled

#Installing NODE Global modules
sudo npm install -g nodemon
sudo npm install -g gulp
sudo npm install -g coffee-script

#Updating Brew
cd /usr/local
git checkout .
brew update
brew install mongodb

#Setting up DB
mkdir ./db
