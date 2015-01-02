#NodeJS and brew should be preinstalled

#Installing NODE Global modules
sudo npm install -g node-dev gulp coffee-script

# ValidateCommitMessage Hook
# TODO: Not sure why -s isnt working
ln -s ./setup/validate-commit-msg.coffee ./.git/hooks/commit-msg

cd /usr/local
git checkout .
brew update
brew install mongodb

#Setting up DB
mkdir ./db