package main

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"fmt"
	"math"
	"time"
)

func mine(targetZeros int, nickname string) (int64, string, string, time.Duration) {
	startTime := time.Now()

	// 计算需要完整为 0 的字节数和最后一个字节的有效位
	fullZeroBytes := targetZeros / 8
	partialZeroBits := targetZeros % 8

	// 最大字节值计算
	maxLastByte := getMaxRange(partialZeroBits)

	nonce := int64(0)
	var hash [32]byte

	for ; nonce <= math.MaxInt64; nonce++ {
		// 拼接数据并计算 SHA256
		data := fmt.Sprintf("%s%d", nickname, nonce)
		hash = sha256.Sum256([]byte(data))

		// 检查完整的 0 字节
		isValid := true
		for i := 0; i < fullZeroBytes; i++ {
			if hash[i] != 0 {
				isValid = false
				break
			}
		}

		// 检查最后一个部分字节
		if isValid && fullZeroBytes < len(hash) && hash[fullZeroBytes] > maxLastByte {
			isValid = false
		}

		if isValid {
			break
		}
	}

	duration := time.Since(startTime)
	return nonce, fmt.Sprintf("%x", hash), fmt.Sprintf("%s%d", nickname, nonce), duration
}

func getMaxRange(bits int) uint8 {
	if bits <= 0 || bits > 8 {
		return 255
	}
	return byte((1 << (8 - bits)) - 1)
}

func generateRSAKeys() (*rsa.PrivateKey, *rsa.PublicKey) {
	privateKey, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		panic(err)
	}
	return privateKey, &privateKey.PublicKey
}

// 对数据进行签名
func signData(privateKey *rsa.PrivateKey, data string) []byte {
	hashed := sha256.Sum256([]byte(data))
	signature, err := rsa.SignPKCS1v15(rand.Reader, privateKey, 0, hashed[:])
	if err != nil {
		panic(err)
	}
	return signature
}

// 验证签名
func verifySignature(publicKey *rsa.PublicKey, data string, signature []byte) bool {
	hashed := sha256.Sum256([]byte(data))
	err := rsa.VerifyPKCS1v15(publicKey, 0, hashed[:], signature)
	return err == nil
}

func main() {

	nickname := "Tora"

	// 找到以 4 个零开头的哈希
	nonce, hash, data, duration := mine(4, nickname)
	fmt.Printf("Found hash with 4 leading zeros:\n")
	fmt.Printf("Time taken: %v\n", duration)
	fmt.Printf("Nonce: %d\n", nonce)
	fmt.Printf("Data: %s\n", data)
	fmt.Printf("Hash: %s\n", hash)

	// 找到以 5 个零开头的哈希
	nonce, hash, data, duration = mine(5, nickname)
	fmt.Printf("\nFound hash with 5 leading zeros:\n")
	fmt.Printf("Time taken: %v\n", duration)
	fmt.Printf("Nonce: %d\n", nonce)
	fmt.Printf("Data: %s\n", data)
	fmt.Printf("Hash: %s\n", hash)

	// 产生公私钥对
	privateKey, publicKey := generateRSAKeys()

	// 对puzzle结果签名
	signedData := signData(privateKey, hash)

	// 验签
	var rsa_flag bool = verifySignature(publicKey, hash, signedData)
	fmt.Printf("rsa_flag: %t\n", rsa_flag)
}
