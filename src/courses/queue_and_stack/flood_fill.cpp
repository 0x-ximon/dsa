#include <queue>
#include <set>
#include <vector>

class Solution {
   public:
    std::vector<std::vector<int>> floodFill(std::vector<std::vector<int>>& image, int sr, int sc,
                                            int color) {
        std::vector<std::pair<int, int>> d = {
            {0, 1},
            {1, 0},
            {0, -1},
            {-1, 0},
        };

        std::queue<std::pair<int, int>> q = {};
        std::set<std::pair<int, int>> v = {};

        v.insert({sr, sc});
        q.push({sr, sc});

        while (!q.empty()) {
            auto [x, y] = q.front();
            q.pop();

            for (auto [dx, dy] : d) {
                int i = x + dx;
                int j = y + dy;

                if (i < 0 || j < 0 || i >= image.size() || j >= image[i].size()) continue;
                if (image[i][j] != image[sr][sc] || v.find({i, j}) != v.end()) continue;

                image[i][j] = color;
                v.insert({i, j});
                q.push({i, j});
            }
        }

        image[sr][sc] = color;
        return image;
    }
};
