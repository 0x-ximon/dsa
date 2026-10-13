#include <cctype>
#include <stack>
#include <string>

class Solution {
   public:
    std::string decodeString(std::string s) {
        std::stack<std::string> characters = {};

        for (int i = 0; i < s.size(); i++) {
            if (characters.empty()) {
                characters.push(std::string(1, s[i]));
                continue;
            }

            if (s[i] == '[') {
                characters.push("[");
                continue;
            }

            if (s[i] == ']') {
                std::string scratch = "";

                while (characters.top() != "[") {
                    scratch = characters.top() + scratch;
                    characters.pop();
                }

                // Take out the '['
                characters.pop();

                // Take out the times
                int n = std::stoi(characters.top());
                characters.pop();

                std::string result = "";

                // Repeat
                for (int i = 0; i < n; i++) result += scratch;

                // Push the final result
                characters.push(result);
                continue;
            }

            if (isdigit(s[i - 1])) {
                auto scratch = characters.top();
                characters.pop();

                scratch += s[i];
                characters.push(scratch);
                continue;
            }

            characters.push(std::string(1, s[i]));
        }

        std::string result = "";
        while (!characters.empty()) {
            result = characters.top() + result;
            characters.pop();
        }

        return result;
    }
};
