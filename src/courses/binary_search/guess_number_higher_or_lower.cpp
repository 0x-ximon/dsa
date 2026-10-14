#include <cstdint>

int guess(int num);

class Solution {
   public:
    int guessNumber(int n) {
        uint64_t m = 1;
        uint64_t p = 1;
        uint64_t q = n;

        while (p <= q) {
            m = (p + q) / 2;
            int r = guess(m);

            if (r == 0) break;
            if (r == 1) p = m + 1;
            if (r == -1) q = m - 1;
        }

        return m;
    }
};
