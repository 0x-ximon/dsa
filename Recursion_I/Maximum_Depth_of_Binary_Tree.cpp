#include <algorithm>
using namespace std;

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

        int largestSubDepth = max(traverse(node->left, depth + 1), traverse(node->right, depth + 1));

        return max(largestSubDepth, depth);
    }
};
