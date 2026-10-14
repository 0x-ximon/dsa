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
    Node* search(Node* node, int val) {
        if (!node) return nullptr;
        if (node->val == val) return node;
        if (node->val > val) return search(node->left, val);
        if (node->val < val) return search(node->right, val);
        return nullptr;
    }
};
