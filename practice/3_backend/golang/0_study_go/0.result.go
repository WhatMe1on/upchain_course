package main

import (
	"log"
)

func main() {
	// searchMap := map[string][]string{"a": {"aa"}, "b": {"bb", "bb22"}}
	// result := [][]string{}
	// for _, array := range searchMap {
	// 	log.Println(array)
	// 	result = append(result, array)
	// }

	// log.Println(result)
	arrays := []int{0,1,0,322,12}
	log.Println(arrays)
	log.Println()
	// arrays := []int {0,3,7,2,5,8,4,6,0,1}
	moveZeroes2(arrays)
	log.Println()
	log.Println(arrays)

}
