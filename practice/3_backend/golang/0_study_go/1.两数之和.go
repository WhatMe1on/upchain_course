package main
// https://leetcode.cn/problems/two-sum/?envType=study-plan-v2&envId=top-100-liked
import(
	
	"log"
	"sort"

	"golang.org/x/exp/constraints"
)

func twoSum(nums []int, target int) []int {
	for i, x := range nums {
		for j := i + 1; j < len(nums); j++ {
			if x+nums[j] == target {
				return []int{i, j}
			}
		}
	}
	return nil
}

func twoSum2(nums []int, target int) []int {
	hashTable := map[int]int{}
	for i, x := range nums {
		hashTable[x] = i
		if p, ok := hashTable[target-x]; ok {
			return []int{p, i}
		}
	}
	return nil
}

func result1() {
	checkPrint(input1())
	checkPrint(input2())
	checkPrint(input3())
}



func input1() (input []int, answer []int, target int) {
	input = []int{2, 7, 11, 15}
	target = int(9)
	answer = []int{0, 1}
	return
}

func input2() (input []int, answer []int, target int) {
	input = []int{3, 2, 4}
	target = int(6)
	answer = nil
	return
}

func input3() (input []int, answer []int, target int) {
	input = []int{3, 3}
	target = int(6)
	answer = []int{0, 1}
	return
}

func checkPrint(input []int, answer []int, target int) {

	result := twoSum(input, target)
	log.Println(result)

	flag := check(result, answer)
	log.Println("result:", flag)
}

func check[T constraints.Ordered](results []T, answer []T) bool {
	sortCompare(results)
	sortCompare(answer)
	if len(results) != len(answer) {
		return false
	}
	for i, x := range results {
		if answer[i] != x {
			return false
		}
	}
	return true
}
func sortCompare[T constraints.Ordered](results []T) {
	sort.Slice(results, func(i, j int) bool {
		if results[i] > results[j] {
			return true
		}
		return false
	})
}

