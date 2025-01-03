package main

// https://leetcode.cn/problems/longest-consecutive-sequence/?envType=study-plan-v2&envId=top-100-liked

func longestConsecutive(nums []int) int {
	searchMap := map[int]bool{}
	for _, x := range nums {
		if _, ok := searchMap[x]; !ok {
			searchMap[x] = false
		}
	}

	maxLen := 0
	for x := range searchMap {
		if _, ok := searchMap[x-1]; !ok {
			tmp := x
			ok2 := true
			for ok2 {
				_, ok2 = searchMap[tmp+1]
				if ok2 {
					tmp++
				}
			}
			if maxLen < tmp-x+1 {
				maxLen = tmp - x + 1
			}
		}
	}
	return maxLen
}
