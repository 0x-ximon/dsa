#include <vector>

class Solution {
   public:
    std::vector<int> getRow(int rowIndex) { return generateRow(rowIndex); }

    std::vector<int> generateRow(int target) {
        if (target == 0) return {1};

        std::vector<int> prevRow = generateRow(target - 1);
        std::vector<int> result = {1};

        for (int i = 1; i < prevRow.size(); i++) {
            result.push_back(prevRow[i - 1] + prevRow[i]);
        }

        result.push_back(1);
        return result;
    }
};
