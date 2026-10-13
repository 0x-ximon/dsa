#include <stack>
#include <utility>
#include <vector>

class Solution {
   public:
    std::vector<int> dailyTemperatures(std::vector<int>& temperatures) {
        std::vector<int> answer(temperatures.size(), 0);
        std::stack<std::pair<int, int>> s = {};

        for (int i = 0; i < temperatures.size(); i++) {
            while (true) {
                if (s.empty()) {
                    s.push({i, temperatures[i]});
                    break;
                }

                auto [index, value] = s.top();
                if (value >= temperatures[i]) {
                    s.push({i, temperatures[i]});
                    break;
                }

                answer[index] = i - index;
                s.pop();
            }
        }

        return answer;
    }
};
