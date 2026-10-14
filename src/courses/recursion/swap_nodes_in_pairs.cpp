struct Node {
    int val;
    Node* next;
    Node() : val(0), next(nullptr) {}
    Node(int x) : val(x), next(nullptr) {}
    Node(int x, Node* next) : val(x), next(next) {}
};

class Solution {
   public:
    Node* swapPairs(Node* node) {
        if (!node || !node->next) return node;

        Node* next = swapPairs(node->next->next);
        Node* head = node->next;

        node->next = next;
        head->next = node;

        return head;
    }
};
