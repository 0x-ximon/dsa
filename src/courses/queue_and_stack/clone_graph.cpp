#include <map>
#include <vector>

class Node {
   public:
    int val;
    std::vector<Node*> neighbors;

    Node() {
        val = 0;
        neighbors = std::vector<Node*>();
    }

    Node(int _val) {
        val = _val;
        neighbors = std::vector<Node*>();
    }

    Node(int _val, std::vector<Node*> _neighbours) {
        val = _val;
        neighbors = _neighbours;
    }
};

class Solution {
   public:
    Node* cloneGraph(Node* node) {
        if (node == nullptr) return nullptr;

        Node* root = new Node(node->val);
        std::map<Node*, Node*> c = {};

        c.insert({node, root});
        clone(node, root, c);

        return root;
    }

   private:
    void clone(Node* node, Node* nodeClone, std::map<Node*, Node*>& clones) {
        for (auto neighbour : node->neighbors) {
            if (clones.find(neighbour) != clones.end()) {
                nodeClone->neighbors.push_back(clones.at(neighbour));
                continue;
            }

            Node* neighbourClone = new Node(neighbour->val);
            nodeClone->neighbors.push_back(neighbourClone);

            clones.insert({neighbour, neighbourClone});
            clone(neighbour, neighbourClone, clones);
        }
    }
};
