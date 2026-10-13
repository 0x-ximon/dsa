#include <algorithm>
#include <unordered_map>
#include <utility>
#include <vector>

class Solution {
   public:
    std::vector<int> topKFrequent(std::vector<int>& nums, int k) {
        std::unordered_map<int, int> counts = {};
        std::vector<int> result = {};
        for (auto num : nums) {
            counts[num]++;
        }

        std::vector<std::pair<int, int>> buffer(counts.size());
        for (auto [k, v] : counts) buffer.push_back({k, v});

        sort(buffer.begin(), buffer.end(),
             [](const std::pair<int, int> a, const std::pair<int, int> b) {
                 return a.second > b.second;
             });

        auto it = buffer.begin();
        for (int i = 0; i < k; i++) {
            result.push_back(it->first);
            it++;
        }

        return result;
    }
};
