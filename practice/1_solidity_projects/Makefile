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

NETWORK_ARGS := http://localhost:8545 --private-key $(PRIVATE_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvvv
endif

date := $(shell date "+%Y-%m-%d")

anvil:
	@anvil --state $(TORA_PATH)/anvilstate/state.json

anvilDay:
	@anvil --state $(TORA_PATH)/anvilstate/$(date).state.json

c3deploy:
	@forge clean && forge script script/3_erc721/DeployNFTStore.s.sol:DeployNFTStore --rpc-url $(NETWORK_ARGS) 

c4deploy:
	@forge clean && forge script script/4_upgradableERC20/TokenDeploy.s.sol:TokenDeploy --rpc-url $(NETWORK_ARGS) 

c4update:
	@forge clean && forge script script/4_upgradableERC20/TokenDeploy.s.sol:TokenUpdate --rpc-url $(NETWORK_ARGS)

c5deploy:
	@forge clean && forge script script/5_bankWithVue/ERC2612Deploy.s.sol:ERC2612Deploy --rpc-url $(NETWORK_ARGS) 