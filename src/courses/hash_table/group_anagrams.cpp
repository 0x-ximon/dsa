#include <algorithm>
#include <string>
#include <unordered_map>
#include <vector>

class Solution {
   public:
    std::vector<std::vector<std::string>> groupAnagrams(std::vector<std::string>& strs) {
        std::unordered_map<std::string, std::vector<std::string>> anagrams = {};
        std::vector<std::vector<std::string>> result;

        for (auto s : strs) {
            std::string key = s;
            std::sort(key.begin(), key.end());

            if (anagrams.find(key) == anagrams.end())
                anagrams[key] = {s};
            else
                anagrams[key].push_back(s);
        }

        for (auto [k, v] : anagrams) result.push_back(v);
        return result;
    }
};
