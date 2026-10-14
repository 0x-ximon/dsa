#include <cstdint>

bool isBadVersion(int version);

class Solution {
   public:
    int firstBadVersion(int n) {
        uint64_t m = -1;
        uint64_t p = 1;
        uint64_t q = n;

        while (p <= q) {
            if (isBadVersion(p)) return p;
            if (!isBadVersion(q)) return m;

            m = (p + q) / 2;

            if (isBadVersion(m))
                q = m - 1;

            else
                p = m + 1;
        }

        return m;
    }
};
