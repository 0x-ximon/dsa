#include <string>
#include <unordered_map>
#include <vector>

class Solution {
   public:
    std::vector<std::string> findRestaurant(std::vector<std::string>& list1,
                                            std::vector<std::string>& list2) {
        std::unordered_map<int, std::vector<std::string>> common = {};
        std::unordered_map<std::string, int> m1;
        int minimum = -1;

        for (int i = 0; i < list1.size(); i++) m1.insert({list1[i], i});

        for (int i = 0; i < list2.size(); i++) {
            if (m1.find(list2[i]) == m1.end()) continue;
            int j = m1[list2[i]];
            int sum = i + j;

            if (minimum == -1 || minimum > sum) minimum = sum;
            if (common.find(sum) == common.end())
                common.insert({sum, {list2[i]}});
            else
                common[sum].push_back({list2[i]});
        }

        return common[minimum];
    }
};
