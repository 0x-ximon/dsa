#include <vector>

class Solution {
   public:
    int search(std::vector<int>& nums, int t) {
        int p = 0, q = nums.size() - 1;

        while (p <= q) {
            int m = (p + q) / 2;
            if (nums[m] == t) return m;

            if (nums[p] <= nums[m]) {
                if (nums[p] <= t && t < nums[m])
                    q = m - 1;

                else
                    p = m + 1;

            }

            else {
                if (nums[m] < t && t <= nums[q])
                    p = m + 1;

                else
                    q = m - 1;
            }
        }

        return -1;
    }
};
