#include <queue>
#include <set>
#include <string>
#include <vector>

class Solution {
   public:
    int openLock(std::vector<std::string>& deadends, std::string target) {
        int turns = 0;
        std::string root = "0000";

        std::set<std::string> v = {};
        std::queue<std::string> q = {};

        q.push(root);
        v.insert(root);

        for (auto d : deadends) {
            if (d == root) {
                return -1;
            }

            v.insert(d);
        }

        while (!q.empty()) {
            int size = q.size();

            for (int i = 0; i < size; i++) {
                auto l = q.front();
                if (l == target) return turns;

                auto children = getChildren(l);
                for (auto c : children) {
                    if (v.find(c) != v.end()) continue;

                    v.insert(c);
                    q.push(c);
                }

                q.pop();
            }

            turns++;
        }

        return -1;
    }

   private:
    std::vector<std::string> getChildren(std::string lock) {
        std::vector<std::string> children = {};

        for (int i = 0; i < lock.size(); i++) {
            std::string l = lock;
            int d = lock[i] - '0';

            // Increment
            l[i] = '0' + (d + 1) % 10;
            children.push_back(l);

            // Decrement
            l[i] = '0' + (d + 9) % 10;
            children.push_back(l);
        }

        return children;
    }
};
