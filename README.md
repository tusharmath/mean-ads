[![wercker status](https://app.wercker.com/status/854f646fa6b5501c8b7b13e4c70f0b02/m "wercker status")](https://app.wercker.com/project/bykey/854f646fa6b5501c8b7b13e4c70f0b02)

Application Setup

1. Install NodeJS, HomeBrew
2. Node Modules: node-dev gulp coffee-script
2. Install MongoDb, Redis

Git Commit Hooks
`ln -s ./setup/validate-commit-msg.coffee ./.git/hooks/commit-msg`


Start the server
Mongo: `mongod --dbpath ~/.db`

Start the node server
nodejs: `nodemon server.coffee --watch backend`


TODO: Use common templates for updated and edit
