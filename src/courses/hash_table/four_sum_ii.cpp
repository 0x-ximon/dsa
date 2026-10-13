#include <unordered_map>
#include <vector>

class Solution {
   public:
    int fourSumCount(std::vector<int>& num1, std::vector<int>& num2, std::vector<int>& num3,
                     std::vector<int>& num4) {
        std::unordered_map<int, int> occured = {};
        int result = 0;

        for (int i : num1) {
            for (int j : num2) {
                occured[i + j]++;
            }
        }

        for (int k : num3) {
            for (int l : num4) {
                int diff = 0 - (k + l);
                result += occured[diff];
            }
        }

        return result;
    }
};
