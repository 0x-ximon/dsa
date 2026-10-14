#include <algorithm>

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
    int maxDepth(Node* root) { return traverse(root, 1); }

    int traverse(Node* node, int depth) {
        if (!node) return depth - 1;

        auto l = traverse(node->left, depth + 1);
        auto r = traverse(node->right, depth + 1);

        int m = std::max(l, r);
        return std::max(m, depth);
    }
};
