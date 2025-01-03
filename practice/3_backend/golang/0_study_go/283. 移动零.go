package main

//https://leetcode.cn/problems/move-zeroes/solutions/489622/yi-dong-ling-by-leetcode-solution/?envType=study-plan-v2&envId=top-100-liked

import "sort"

func moveZeroes(nums []int) {
	left, right, n := 0, 0, len(nums)
	for right < n {
		if nums[right] != 0 {
			nums[left], nums[right] = nums[right], nums[left]
			left++
		}
		right++
	}
}

func moveZeroes2(nums []int) {
	sort.SliceStable(nums, func(i, j int) bool {
		// if nums[i] == 0 {
		// 	return true
		// }
		// if nums[j] == 0 {
		// 	return false
		// }
		// return false
		// return nums[i] < nums[j]

		if nums[j] == 0 {
			return true
		}
		return false
	})
}
