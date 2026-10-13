#include <unordered_map>
#include <vector>

class Solution {
   public:
    std::vector<int> twoSum(std::vector<int>& nums, int target) {
        std::unordered_map<int, int> m = {};

        for (int i = 0; i < nums.size(); i++) {
            int value = target - nums[i];
            if (m.find(value) != m.end()) return {m[value], i};
            m.insert({nums[i], i});
        }

        return {};
    }
};
