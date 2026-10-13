#include <set>
#include <stack>
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
    std::vector<int> inorderTraversal(Node* root) {
        if (!root) return {};

        std::vector<int> r = {};
        std::set<Node*> v = {};
        std::stack<Node*> s = {};

        s.push(root);
        v.insert(root);

        while (!s.empty()) {
            auto node = s.top();

            if (node->left && v.find(node->left) == v.end()) {
                v.insert(node->left);
                s.push(node->left);
                continue;
            }

            r.push_back(node->val);
            s.pop();

            if (node->right && v.find(node->right) == v.end()) {
                v.insert(node->right);
                s.push(node->right);
                continue;
            }
        }

        return r;
    }
};
