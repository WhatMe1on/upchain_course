package main

// https://leetcode.cn/problems/container-with-most-water/description/?envType=study-plan-v2&envId=top-100-liked

func maxArea(height []int) int {
	left, right := 0, len(height)-1
	maxC := (right - left) * min(height[left], height[right])

	for left < right {
		if height[left] > height[right] {
			right--
			if height[right] > height[right+1] {
				maxC = max(maxC, (right-left)*min(height[left], height[right]))
			}
		} else {
			left++
			if height[left] > height[left-1] {
				maxC = max(maxC, (right-left)*min(height[left], height[right]))
			}
		}
	}

	return maxC
}
