#include <vector>
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
    vector<Node> generateTrees(int n) {
        vector<Node> result = {};
        return {};
    }

    void generate(Node root, vector<Node>* result) {}
};
