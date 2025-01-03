package main

// https://leetcode.cn/problems/group-anagrams/?envType=study-plan-v2&envId=top-100-liked
import (
	"log"
	"sort"
)

func result49() {

}

func groupAnagrams(strs []string) [][]string {
	searchMap := map[string][]string{}
	for _, str := range strs {
		key := getKey(str)
		if stringArray, ok := searchMap[key]; ok {
			stringArray = append(stringArray, str)
			searchMap[key] = stringArray
			log.Println(str)
		} else {
			searchMap[key] = []string{str}
		}
	}

	returns := [][]string{}
	for _, array := range searchMap {
		returns = append(returns, array)
	}

	return returns
}

func getKey(input string) string {
	tmp := []byte(input)
	sort.Slice(tmp, func(i, j int) bool {
		if tmp[i] > tmp[j] {
			return true
		}
		return false
	})
	return string(tmp)
}
