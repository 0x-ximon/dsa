#include <string>
#include <unordered_map>
#include <vector>

struct Node {
    int val;
    Node* left;
    Node* right;
    Node() : val(0), left(nullptr), right(nullptr) {}
    Node(int x) : val(x), left(nullptr), right(nullptr) {}
    Node(int x, Node* left, Node* right) : val(x), left(left), right(right) {}
};

class Solution {
   public:
    std::vector<Node*> findDuplicateSubtrees(Node* root) {
        std::unordered_map<std::string, int> subtrees;
        std::vector<Node*> result;

        dfs(root, subtrees, result);
        return result;
    }

   private:
    std::string dfs(Node* node, std::unordered_map<std::string, int>& subtrees,
                    std::vector<Node*>& result) {
        if (!node) return "N";

        std::string l = dfs(node->left, subtrees, result);
        std::string r = dfs(node->right, subtrees, result);
        std::string s = std::to_string(node->val) + " " + l + " " + r;

        subtrees[s]++;

        if (subtrees[s] == 2) result.push_back(node);
        return s;
    }
};
