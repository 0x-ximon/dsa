#include <unordered_map>

class Solution {
   public:
    int climbStairs(int n) {
        std::unordered_map<int, int> m;
        return climb(n, m);
    }

    int climb(int n, std::unordered_map<int, int>& m) {
        if (n <= 2) return n;
        if (m.find(n) != m.end()) return m[n];

        m[n] = climb(n - 1, m) + climb(n - 2, m);
        return m[n];
    }
};
