#include <string>
#include <unordered_map>

class Solution {
   public:
    bool isIsomorphic(std::string s, std::string t) {
        std::unordered_map<char, char> sMap = {};
        std::unordered_map<char, char> tMap = {};
        int n = s.size();

        for (int i = 0; i < n; i++) {
            if (sMap.find(s[i]) != sMap.end() && sMap[s[i]] != t[i]) return false;
            if (tMap.find(t[i]) != sMap.end() && tMap[t[i]] != s[i]) return false;

            sMap.insert({s[i], t[i]});
            tMap.insert({t[i], s[i]});
        }

        return true;
    }
};
