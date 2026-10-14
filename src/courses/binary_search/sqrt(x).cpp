#include <sys/types.h>

class Solution {
   public:
    int mySqrt(int x) {
        double m;
        double p = 0;
        double q = x;

        while (true) {
            m = (p + q) / 2;
            u_int32_t s = m * m;

            if (s == x) break;
            if (s < x) p = m;
            if (s > x) q = m;
        }

        return m;
    }
};
