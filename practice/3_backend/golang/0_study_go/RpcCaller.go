package main

import (
	"context"
	"fmt"
	"log"
	"math"
	"math/big"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
)

func main() {
	client, err := ethclient.Dial("http://localhost:8545")
	addStr := "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"

	if err != nil {
		log.Fatal(err)
	}

	number, err := client.BlockNumber(context.Background())
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(number)

	address := common.HexToAddress(addStr)
	balance, err := client.BalanceAt(context.Background(), address, nil)
	if err != nil {
		log.Fatal(err)
	}

	fbalance := new(big.Float).SetInt(balance)
	fbalance = new(big.Float).Quo(fbalance, big.NewFloat(math.Pow10(18)))

	fmt.Println(fbalance)

	pbalance, err := client.PendingBalanceAt(context.Background(), address)
	if err != nil {
		log.Fatal(err)
	}

	ptbalance := new(big.Float).SetInt(pbalance)
	ptbalance = new(big.Float).Quo(ptbalance, big.NewFloat(math.Pow10(18)))

	fmt.Println(ptbalance)

}
