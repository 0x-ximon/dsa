#include <iostream>
#include <queue>
#include <set>
#include <utility>
#include <vector>

class Solution {
   public:
    int numIslands(std::vector<std::vector<char>>& grid) {
        if (grid.empty() || grid[0].empty()) return 0;

        int islands = 0;
        int rows = grid.size();
        int cols = grid[0].size();

        // We store visited cells to avoid revisiting.// We store visited cells
        // to avoid revisiting.
        std::set<std::pair<int, int>> v;

        // We use a queue to keep track of what cells need to be explored.
        std::queue<std::pair<int, int>> q;

        // We store the directions: right, up, left, down
        std::vector<std::pair<int, int>> d = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                // We encounter a cell not previously explored which means it
                // must be an island.
                if (grid[i][j] == '1' && v.find({i, j}) == v.end()) {
                    islands++;

                    // Mark the cell as visited so we don't visit it again.
                    v.insert({i, j});

                    // We begin our search from the root node.
                    q.push({i, j});

                    while (!q.empty()) {
                        auto [r, c] = q.front();
                        q.pop();

                        // Explore the horizontal and vertical directions of the
                        // cell.
                        for (const auto [dx, dy] : d) {
                            int x = r + dx;
                            int y = c + dy;

                            // Check to see if the adjacent cell is a valid
                            // cell, part of an island and has not been
                            // explored.
                            if (x >= 0 && y >= 0 && x < rows && y < cols && grid[x][y] == '1' &&
                                v.find({x, y}) == v.end()) {
                                // We mark the cell as visited so we don't visit
                                // it again.
                                v.insert({x, y});

                                // We push the adjacent cell into the queue so
                                // we can search around it.
                                q.push({x, y});
                            }
                        }
                    }
                }
            }
        }

        return islands;
    }
};
