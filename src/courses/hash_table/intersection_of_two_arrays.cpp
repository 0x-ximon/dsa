#include <unordered_set>
#include <vector>

class Solution {
   public:
    std::vector<int> intersection(std::vector<int>& nums1, std::vector<int>& nums2) {
        std::unordered_set<int> m = {};
        std::vector<int> k = {};

        for (auto num : nums1) m.insert(num);
        for (auto num : nums2) {
            if (m.find(num) != m.end()) {
                k.push_back(num);
                m.erase(num);
            }
        }

        return k;
    }
};
