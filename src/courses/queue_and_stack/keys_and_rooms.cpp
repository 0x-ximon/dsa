#include <queue>
#include <set>
#include <vector>

class Solution {
   public:
    bool canVisitAllRooms(std::vector<std::vector<int>>& nums) {
        std::set<int> visited = {};
        std::queue<int> keys = {};

        visited.insert(0);
        keys.push(0);

        while (!keys.empty()) {
            int key = keys.front();
            keys.pop();

            for (auto k : nums[key]) {
                if (visited.find(k) != visited.end()) continue;
                visited.insert(k);
                keys.push(k);
            }
        }

        return nums.size() == visited.size();
    }
};
