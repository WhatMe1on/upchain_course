package main

import (
	"context"
	"fmt"
	"log"
	"math/big"
	"os"
	"strings"

	"github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/tidwall/gjson"
)

// 0: contract NFTERC721 0x5FC8d32690cc91D4c39d9d3abcBD16989F875707
// 1: contract NFTStore 0xa513E6E4b8f2a923D98304ec87F64353C4D5C853
// 2: contract TORATokenInNFT 0x0165878A594ca255338adfa4d48449f69242Eb8F
type LogTransfer struct {
	From    common.Address
	To      common.Address
	tokenId *big.Int
}

type LogApproval struct {
	Owner    common.Address
	Approved common.Address
	tokenId  *big.Int
}

func check(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

const uri = "http://localhost:8545"
const addressStr = "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0"
const abiFile = "/home/ccacr/project/upchain_course/practice/1_solidity_projects/out/NFT.sol/NFTERC721.json"
const TransferSig = "Transfer(address,address,uint256)"
const ApprovalSig = "Approval(address,address,uint256)"

func main() {
	client, err := ethclient.Dial(uri)
	check(err)

	contractAddress := common.HexToAddress(addressStr)
	query := ethereum.FilterQuery{
		FromBlock: big.NewInt(0),
		ToBlock:   big.NewInt(3000),
		Addresses: []common.Address{
			contractAddress,
		},
	}

	logs, err := client.FilterLogs(context.Background(), query)
	check(err)

	dat, err := os.ReadFile(abiFile)
	check(err)
	value := gjson.Get(string(dat), "abi")

	contractAbi, err := abi.JSON(strings.NewReader(value.String()))
	check(err)

	logTransferSig := []byte(TransferSig)
	LogApprovalSig := []byte(ApprovalSig)
	logTransferSigHash := crypto.Keccak256Hash(logTransferSig)
	logApprovalSigHash := crypto.Keccak256Hash(LogApprovalSig)

	for _, vLog := range logs {
		fmt.Printf("Log Block Number: %d\n", vLog.BlockNumber)
		fmt.Printf("Log Index: %d\n", vLog.Index)

		switch vLog.Topics[0].Hex() {
		case logTransferSigHash.Hex():
			logTransfer(contractAbi, vLog)
		case logApprovalSigHash.Hex():
			logApproval(contractAbi, vLog)
		}
	}
}

func logTransfer(contractAbi abi.ABI, vLog types.Log) {
	fmt.Printf("Log Name: Transfer\n")

	var transferEvent LogTransfer

	// a := string(vLog.Data)
	// fmt.Printf(a)

	err := contractAbi.UnpackIntoInterface(&transferEvent, "Transfer", vLog.Data)
	if err != nil {
		log.Fatal(err)
	}

	transferEvent.From = common.HexToAddress(vLog.Topics[1].Hex())
	transferEvent.To = common.HexToAddress(vLog.Topics[2].Hex())
	transferEvent.tokenId = vLog.Topics[3].Big()

	fmt.Printf("From: %s\n", transferEvent.From.Hex())
	fmt.Printf("To: %s\n", transferEvent.To.Hex())
	fmt.Printf("TokenId: %s\n", transferEvent.tokenId.String())
}

func logApproval(contractAbi abi.ABI, vLog types.Log) {
	fmt.Printf("Log Name: Approval\n")

	var approvalEvent LogApproval

	err := contractAbi.UnpackIntoInterface(&approvalEvent, "Approval", vLog.Data)
	if err != nil {
		log.Fatal(err)
	}

	approvalEvent.Owner = common.HexToAddress(vLog.Topics[1].Hex())
	approvalEvent.Approved = common.HexToAddress(vLog.Topics[2].Hex())
	approvalEvent.tokenId = vLog.Topics[3].Big()

	fmt.Printf("Token Owner: %s\n", approvalEvent.Owner.Hex())
	fmt.Printf("Approved: %s\n", approvalEvent.Approved.Hex())
	fmt.Printf("TokenId: %s\n", approvalEvent.tokenId.String())
}
