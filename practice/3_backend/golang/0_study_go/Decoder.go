package main

// import (
// 	"fmt"
// 	"github.com/ethereum/go-ethereum/common"
// 	"log"
// 	"math/big"
// )

// func main() {
// 	networkURL := "https://api.avax-test.network/ext/bc/C/rpc"
// 	InitNetwork(networkURL)

// 	walletPublicAddress, walletPrivateAddress := ImportWallet("653......fa") // Private Key Here
// 	config := PrepareTransaction(walletPublicAddress, walletPrivateAddress)

// 	contractAddress := common.HexToAddress("0x0585C2794c545BE869b4f398fD1bFD62E16D86eb")
// 	store, err := Storage.NewStorage(contractAddress, client)
// 	if err != nil {
// 		log.Fatalf("An error occurred while establishing a connection with the smart contract : %v", err)
// 	}

// 	tx, err := store.Store(config, big.NewInt(23))
// 	if err != nil {
// 		log.Fatalf("An error occurred while writing data to smart contract : %v", err)
// 	}
// 	fmt.Println("Writing process transaction: ", tx.Hash().Hex())

// 	callOpts := &bind.CallOpts{
// 		Pending: true,
// 	}
// 	value, err := store.Retrieve(callOpts)
// 	if err != nil {
// 		log.Fatalf("An error occurred while reading data from smart contract : %v", err)
// 	}
// 	fmt.Println("Reading process result : ", value)
// }

