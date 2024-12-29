-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil 

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install foundry-rs/forge-std --no-commit && forge install OpenZeppelin/openzeppelin-foundry-upgrades --no-commit && forge install OpenZeppelin/openzeppelin-contracts-upgradeable --no-commit

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

## anvil --load-state and --dump-state 
date := $(shell date "+%Y-%m-%d")

anvilStable:
	@anvil --state $(TORA_PATH)/anvilstate/state.json

anvilDay:
	@anvil --state $(TORA_PATH)/anvilstate/$(date).state.json

## deploy dapp on ethereum

UPPERCASE_STRING = $(shell echo "$(1)" | tr '[:lower:]' '[:upper:]')

NETWORK_ARGS := --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
ifeq ($(ARGS),)
NETWORK := ANVIL
PRIVATE_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
PUB_ADDRESS=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
else 
	NETWORK := $(call UPPERCASE_STRING,$(ARGS))
	NETWORK_ARGS += --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvvv
endif

RPC_URL := $(value $(NETWORK)_RPC_URL)

printParameter:
	@echo NETWORK=$(NETWORK) && echo RPC_URL=$(RPC_URL) && echo PUB_ADDRESS=$(PUB_ADDRESS) 

c3deploy:
	@printParameter && forge clean && forge script script/3_erc721/DeployNFTStore.s.sol:DeployNFTStore  $(NETWORK_ARGS) 

c4deploy:
	@printParameter && forge clean && forge script script/4_upgradableERC20/TokenDeploy.s.sol:TokenDeploy $(NETWORK_ARGS) 

c4update:
	@printParameter && forge clean && forge script script/4_upgradableERC20/TokenDeploy.s.sol:TokenUpdate $(NETWORK_ARGS)

c5deploy:
	@printParameter && forge clean && forge script script/5_bankWithVue/ERC2612Deploy.s.sol:ERC2612Deploy $(NETWORK_ARGS) 
