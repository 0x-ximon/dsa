#include <iostream>
#include <ostream>
#include <stack>
#include <string>

class Solution {
   public:
    bool isValid(std::string s) {
        std::stack<char> stack = {};

        for (int i = 0; i < s.size(); i++) {
            if (s[i] == '(' || s[i] == '{' || s[i] == '[') {
                stack.push(s[i]);
                continue;
            }

            if (stack.empty()) return false;
            char top = stack.top();

            if (s[i] == ')' && top != '(') return false;
            if (s[i] == '}' && top != '{') return false;
            if (s[i] == ']' && top != '[') return false;

            stack.pop();
        }

        if (!stack.empty()) return false;
        return true;
    }
};
