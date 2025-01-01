# set env this env's private key is anvil's default settings
mv env.template .env
## fullfil env
vim .env
source .env

# install dependency
make install

# deploy and update the contract
make cupdate