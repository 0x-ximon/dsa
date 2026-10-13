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
    Node* searchBST(Node* root, int val) { return search(root, val); }
    Node* search(Node* node, int val) {
        if (!node) return nullptr;
        if (node->val == val) return node;

        Node* result = nullptr;

        result = search(node->left, val);
        if (result) return result;

        result = search(node->right, val);
        if (result) return result;

        return result;
    }
};
