#include <string>
#include <unordered_set>

class Solution {
   public:
    int numJewelsInStones(std::string jewels, std::string stones) {
        std::unordered_set<char> j;
        for (auto c : jewels) j.insert(c);

        int k = 0;
        for (auto c : stones)
            if (j.find(c) != j.end()) k++;

        return k;
    }
};
