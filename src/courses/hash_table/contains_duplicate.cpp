#include <unordered_set>
#include <vector>

class Solution {
   public:
    bool containsDuplicate(std::vector<int>& nums) {
        std::unordered_set<int> s = {};

        for (int i = 0; i < nums.size(); i++) {
            s.insert(nums[i]);
            if (s.size() != i + 1) return true;
        }

        return false;
    }
};
