#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

class Solution {
   public:
    bool isValidSudoku(std::vector<std::vector<char>>& board) {
        std::unordered_map<int, std::unordered_set<int>> rows = {};
        std::unordered_map<int, std::unordered_set<int>> columns = {};
        std::unordered_map<std::string, std::unordered_set<int>> squares = {};

        for (int r = 0; r < 9; r++) {
            for (int c = 0; c < 9; c++) {
                if (board[r][c] == '.') continue;

                std::string rc = std::to_string(int(r / 3)) + std::to_string(int(c / 3));
                if (rows[r].find(board[r][c]) != rows[r].end() ||
                    columns[c].find(board[r][c]) != columns[c].end() ||
                    squares[rc].find(board[r][c]) != squares[rc].end())
                    return false;

                rows[r].insert(board[r][c]);
                columns[c].insert(board[r][c]);
                squares[rc].insert(board[r][c]);
            }
        }

        return true;
    }
};
