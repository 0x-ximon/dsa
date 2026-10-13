#include <iostream>
#include <stack>
#include <string>
#include <vector>

class Solution {
   public:
    int evalRPN(std::vector<std::string>& tokens) {
        std::stack<int> s = {};

        auto getOperands = [&]() -> std::pair<int, int> {
            int operand1 = s.top();
            s.pop();

            int operand2 = s.top();
            s.pop();

            return {operand1, operand2};
        };

        for (auto token : tokens) {
            switch (token[0]) {
                case '+': {
                    auto [op1, op2] = getOperands();
                    s.push(op1 + op2);
                    break;
                }

                case '-': {
                    auto [op1, op2] = getOperands();
                    s.push(op2 - op1);
                    break;
                }

                case '*': {
                    auto [op1, op2] = getOperands();
                    s.push(op1 * op2);
                    break;
                }

                case '/': {
                    auto [op1, op2] = getOperands();
                    s.push(op2 / op1);
                    break;
                }

                default: {
                    int num = stoi(token);
                    s.push(num);
                    break;
                }
            }
        }

        int answer = s.top();
        return answer;
    }
};
