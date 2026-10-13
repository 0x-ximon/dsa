#include <unordered_map>
#include <vector>

class Solution {
   public:
    std::vector<int> intersect(std::vector<int>& nums1, std::vector<int>& nums2) {
        std::unordered_map<int, int> m = {};
        std::vector<int> k = {};

        for (auto n : nums1) {
            if (m.find(n) == m.end())
                m[n] = 1;
            else
                m[n]++;
        }

        for (auto n : nums2) {
            if (m.find(n) == m.end() || m[n] == 0) continue;
            k.push_back(n);
            m[n]--;
        }

        return k;
    }
};
