#include <stdlib.h>

#include <unordered_map>
#include <vector>

class Solution {
   public:
    bool containsNearbyDuplicate(std::vector<int>& nums, int k) {
        std::unordered_map<int, std::vector<int>> m = {};

        for (int j = 0; j < nums.size(); j++) {
            int n = nums[j];

            if (m.find(n) == m.end()) {
                m[n] = {j};
                continue;
            }

            for (auto i : m[n])
                if (abs(i - j) <= k) return true;

            m[n].push_back(j);
        }

        return false;
    }
};
