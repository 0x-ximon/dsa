#include <algorithm>
#include <vector>

class Solution {
   public:
    int singleNumber(std::vector<int>& nums) {
        if (nums.size() == 1) return nums[0];
        std::sort(nums.begin(), nums.end());

        int p = 0;
        int q = 1;

        while (q < nums.size()) {
            if (nums[p] != nums[q]) return nums[p];
            p += 2;
            q += 2;
        }

        return nums[p];
    }
};
