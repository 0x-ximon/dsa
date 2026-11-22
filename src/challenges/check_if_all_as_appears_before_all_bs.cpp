#include <string>
#include <variant>

// Code: 2124
// Name: Check if all A's Appears Before All B's
// Link: https://leetcode.com/problems/check-if-all-as-appears-before-all-bs

class Solution {
   public:
    bool checkString(std::string s) {
        for (int i = 1; i < s.length(); i++) {
            auto ss = std::string{s[i - 1], s[i]};
            if (ss == "ba") return false;
        }

        return true;
    }
};

int main() {
    Solution solution;
    std::string s;
    bool result;

    s = "aaabbb";
    result = solution.checkString(s);
    std::printf("%s: %d\n", s.c_str(), result);

    s = "abab";
    result = solution.checkString(s);
    std::printf("%s: %d\n", s.c_str(), result);

    s = "bbb";
    result = solution.checkString(s);
    std::printf("%s: %d\n", s.c_str(), result);
}
