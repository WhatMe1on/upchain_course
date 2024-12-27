package main

import (
	"context"
	"crypto/ecdsa"
	"fmt"
	"log"
	"math"
	"math/big"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/shopspring/decimal"
)

var client *ethclient.Client

type Configurations struct {
	Nonce    uint64
	GasPrice *big.Int
	ChainID  *big.Int
	GasLimit uint64
}

// Create wallet
func CreateWallet() (common.Address, *ecdsa.PrivateKey) {
	generatedPrivateKey, err := crypto.GenerateKey()
	if err != nil {
		log.Fatal(err)
	}

	//privateKeyBytes := crypto.FromECDSA(generatedPrivateKey)
	//privateKey := hexutil.Encode(privateKeyBytes)[2:]
	//fmt.Println(privateKey)
	publicKey := generatedPrivateKey.Public()
	publicKeyECDSA, ok := publicKey.(*ecdsa.PublicKey)
	if !ok {
		log.Fatal("cannot assert type: publicKey is not of type *ecdsa.PublicKey")
	}

	address := crypto.PubkeyToAddress(*publicKeyECDSA)
	return address, generatedPrivateKey
}

// Import wallet
func ImportWallet(privateKey string) (common.Address, *ecdsa.PrivateKey) {
	importedPrivateKey, err := crypto.HexToECDSA(privateKey)
	if err != nil {
		log.Fatal(err)
	}

	publicKey := importedPrivateKey.Public()
	publicKeyECDSA, ok := publicKey.(*ecdsa.PublicKey)
	if !ok {
		log.Fatal("error casting public key to ECDSA")
	}

	address := crypto.PubkeyToAddress(*publicKeyECDSA)
	return address, importedPrivateKey
}

func InitNetwork(networkRPC string) {
	var err error
	client, err = ethclient.Dial(networkRPC)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Connected")
}

func WalletBalance(address string) (*big.Int, *big.Float) {
	account := common.HexToAddress(address)
	balance, err := client.BalanceAt(context.Background(), account, nil)
	if err != nil {
		log.Fatal(err)
	}

	floatBalance := new(big.Float)
	floatBalance.SetString(balance.String())
	ethValue := new(big.Float).Quo(floatBalance, big.NewFloat(math.Pow10(18)))

	return balance, ethValue
}

func WalletBalanceByBlock(address string, block int64) (*big.Int, *big.Float) {
	account := common.HexToAddress(address)
	blockNumber := big.NewInt(block)
	balance, err := client.BalanceAt(context.Background(), account, blockNumber)
	if err != nil {
		log.Fatal(err)
	}

	floatBalance := new(big.Float)
	floatBalance.SetString(balance.String())
	ethValue := new(big.Float).Quo(floatBalance, big.NewFloat(math.Pow10(18)))

	return balance, ethValue
}

func TransferOptions(publicKey common.Address) Configurations {
	var configure Configurations

	nonce, err := client.PendingNonceAt(context.Background(), publicKey)
	if err != nil {
		log.Fatal(err)
	}

	gasPrice, err := client.SuggestGasPrice(context.Background())
	if err != nil {
		log.Fatal(err)
	}

	chainID, err := client.NetworkID(context.Background())
	if err != nil {
		log.Fatal(err)
	}

	configure.Nonce = nonce
	configure.GasPrice = gasPrice
	configure.ChainID = chainID
	configure.GasLimit = uint64(21000)

	return configure
	// NewKeyedTransactorWithChainID is a utility method to easily create a transaction signer from a single private key.
	// This function takes privateKey and chainID as parameters. Also privateKey should be *ecdsa.PrivateKey type
	//auth, err := bind.NewKeyedTransactorWithChainID(privateKey, chainID)
	//if err != nil {
	//	log.Fatal(err)
	//}

	// I set gasPrice, GasLimit and Nonce value intı auth.
	//auth.GasPrice = gasPrice
	//auth.GasLimit = uint64(3000000)
	//auth.Nonce = big.NewInt(int64(nonce))

}

func ToWei(iAmount interface{}, decimals int) *big.Int {
	amount := decimal.NewFromFloat(0)
	switch v := iAmount.(type) {
	case string:
		amount, _ = decimal.NewFromString(v)
	case float64:
		amount = decimal.NewFromFloat(v)
	case int64:
		amount = decimal.NewFromFloat(float64(v))
	case decimal.Decimal:
		amount = v
	case *decimal.Decimal:
		amount = *v
	}

	mul := decimal.NewFromFloat(float64(10)).Pow(decimal.NewFromFloat(float64(decimals)))
	result := amount.Mul(mul)

	wei := new(big.Int)
	wei.SetString(result.String(), 10)

	return wei
}

func Transfer(fromPublicAddress common.Address, fromPrivateAddress *ecdsa.PrivateKey, toPublicAddress common.Address, amount string) {
	weiAmount := ToWei(amount, 18)

	transactionConfigs := TransferOptions(fromPublicAddress)

	var data []byte
	tx := types.NewTransaction(transactionConfigs.Nonce, toPublicAddress, weiAmount, transactionConfigs.GasLimit, transactionConfigs.GasPrice, data)

	signedTx, err := types.SignTx(tx, types.NewEIP155Signer(transactionConfigs.ChainID), fromPrivateAddress)
	if err != nil {
		log.Fatal(err)
	}

	err = client.SendTransaction(context.Background(), signedTx)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("tx sent: %s", signedTx.Hash().Hex())
}
