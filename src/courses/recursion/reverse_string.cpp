#include <utility>
#include <vector>

class Solution {
   public:
    void reverseString(std::vector<char>& s) { reverse(0, s.size() - 1, s); }

    void reverse(int i, int j, std::vector<char>& s) {
        if (i >= j) return;
        std::swap(s[i], s[j]);
        reverse(++i, --j, s);
    };
};
