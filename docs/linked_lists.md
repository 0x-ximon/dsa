# Linked Lists

*Simon Samuel · 20th April, 2024*

Linked lists are linear data structures in which each item of the list holds data and a reference to another list node, this linking is how it keeps a relationship to other items in the list.

There are two types of linked lists:

1. Singly Linked List
2. Doubly Linked List

## Singly Linked List

Each node in the singly linked list contains not only the value but also a reference field to the next node. In this way, the list can store the values in a sequence. Here is the structure for creating a node in the linked list.

```cpp
#include <cstddef>
using namespace std;

struct ListNode {
    int data;
    // We store the memory address of the next node here. 
    ListNode* next;

    ListNode(int value) {
        this->data = value;
        this->next = NULL;
    }
}
```

### Operations

Unlike the array, we're not able to access elements in constant time and have to iterate through the entire list to get the data we want. This makes accessing data in a linked list a *O(n)* operation.

#### Inserting a new Node

Despite its poor data access capabilities, inserting an item into any part of the linked list is relatively straightforward. You simply have to:

1. Set the `next` attribute of the new node to the `next` of the node before it.
2. Set the `next` of the node before the new node to the new node.

The time complexity for inserting into a linked list is *O(1)*.

```cpp
#include <cstddef>
#include <iostream>

using namespace std;

struct ListNode {
    int data;
    ListNode* next;

    ListNode(int value) {
        this->data = value;
        this->next = NULL;
    }

    void displayList() {
        ListNode* node = this;

        cout << "The List is [";
        while (node) {
            cout << " " << node->data;
            node = node->next;
        }

        cout << " ].\n";
    }
};

int main() {
    // Create 3 nodes.
    ListNode head = ListNode(15);
    ListNode second = ListNode(14);
    ListNode third = ListNode(9);

    // Link up the nodes to form a linked list.
    head.next = &second;
    second.next = &third;

    // Call helper method to display the old list elements.
    head.displayList();

    // Create a new node that will be inserted into the list.
    ListNode newNode = ListNode(18);

    // Set the next of the new node to point to the next of the node it's
    // replacing.
    newNode.next = head.next;

    // Set the next of the previous node to this new node.
    head.next = &newNode;

    // Print out the modified array.
    head.displayList();
};
```

#### Deleting a node

Similar to how it was easy to insert a node into the linked list, deleting a node is equally as straightforward.

```cpp
#include <cstddef>
#include <iostream>

using namespace std;

struct ListNode {
    int data;
    ListNode* next;

    ListNode(int value) {
        this->data = value;
        this->next = NULL;
    }

    void displayList() {
        ListNode* node = this;

        cout << "The List is [";
        while (node) {
            cout << " " << node->data;
            node = node->next;
        }

        cout << " ].\n";
    }
};

int main() {
    // Create 5 nodes.
    ListNode head = ListNode(15);
    ListNode second = ListNode(14);
    ListNode third = ListNode(9);
    ListNode fourth = ListNode(29);
    ListNode fifth = ListNode(88);

    // Link up the nodes to form a linked list.
    head.next = &second;
    second.next = &third;
    third.next = &fourth;
    fourth.next = &fifth;

    // Call helper method to display the old list elements.
    head.displayList();

    // To delete the third node, we simply have to set the next of the
    // node before the third node to the next of the third node.
    second.next = third.next;

    // Print out the modified array.
    head.displayList();
};
```

### Fully Functional Linked List

```cpp
#include <cstddef>
#include <cstdlib>
#include <cstring>
#include <iostream>

using namespace std;

class ListNode {
   public:
    int val;
    ListNode* next;

    ListNode(int value) {
        this->val = value;
        this->next = nullptr;
    }
};

class MyLinkedList {
    ListNode* head;
    int size;

   public:
    MyLinkedList() {
        this->head = nullptr;
        this->size = 0;
    }

    int get(int index) {
        if (index < 0 || index >= this->size) {
            cout << "Invalid Index"
                 << "\n";
            return -1;
        }

        ListNode* curr = this->head;

        for (int i = 0; i < index; i++) {
            curr = curr->next;
        }

        cout << "The value at index " << index << " is " << curr->val << "\n";
        return curr->val;
    }

    void addAtHead(int val) {
        // C++ compiler reuses the same memory address on the stack when the
        // function returns, by using the "new" keyword, the object is created
        // on the heap.
        ListNode* newNode = new ListNode{val};

        newNode->next = this->head;
        this->head = newNode;

        this->size++;
    }

    void addAtTail(int val) {
        if (this->size == 0) {
            this->addAtHead(val);
            return;
        }

        ListNode* newNode = new ListNode{val};

        ListNode* curr = this->head;

        while (curr->next != nullptr) {
            curr = curr->next;
        }

        curr->next = newNode;
        this->size++;
    }

    void addAtIndex(int index, int val) {
        if (index < 0 || index > this->size)
            return;

        if (index == 0) {
            this->addAtHead(val);
            return;
        }

        if (index == this->size) {
            this->addAtTail(val);
            return;
        }

        ListNode* newNode = new ListNode{val};
        ListNode* curr = this->head;

        for (size_t i = 0; i < index - 1; i++) {
            curr = curr->next;
        }

        newNode->next = curr->next;
        curr->next = newNode;

        this->size++;
    }

    void deleteAtIndex(int index) {
        if (index < 0 || index >= this->size)
            return;

        if (index == 0) {
            ListNode* temp = this->head;
            this->head = this->head->next;
            delete temp;
            this->size--;
            return;
        }

        ListNode* curr = this->head;

        for (size_t i = 0; i < index - 1; i++) {
            curr = curr->next;
        }

        ListNode* temp = curr->next;
        curr->next = curr->next->next;
        delete temp;

        this->size--;
    }

    void displayList() {
        ListNode* node = this->head;

        cout << "The List is [ ";
        while (node) {
            cout << node->val << " -> ";
            node = node->next;
        }

        cout << "nullptr ].\n";
    }

    void displayNodeAddresses() {
        ListNode* node = this->head;

        cout << "The Addresses of the nodes are [ ";
        while (node) {
            cout << &(*node) << " -> ";
            node = node->next;
        }

        cout << "nullptr ].\n";
    }

    ~MyLinkedList() {
        ListNode* node = this->head;

        while (node) {
            ListNode* temp = node;
            node = node->next;

            delete temp;
        }

        cout << "Cleaned up memory" << endl;
    }
};
```

### Two Pointer Technique

There are two scenarios where you'd want to use the two-pointer approach:

1. Two pointers **start at different positions**.
2. Two pointers **move with different speeds**.

   We will look at the second scenario in detail as the solution is implementing **Floyd's cycle-finding algorithm**.

### Floyd's cycle-detection Algorithm

Floyd's cycle-detection Algorithm is an algorithm where two pointers represented by a Tortoise and a Hare both traverse a linked list at different speeds. The algorithm works by considering an important factor: *if there is no cycle in the list, the end node would point to a `nullptr` and the fast pointer, the hare, would be null at a certain point.*

If there is a cycle at some point during the traversal both pointers will inevitably meet at a single node which does not particularly need to be the node when the cycle occurs.

```cpp
#include "./Linked_List_Node.cpp"

class Solution {
   public:
    bool hasCycle(ListNode* head) {
        if (head == nullptr)
            return false;

        ListNode* slow = head;
        ListNode* fast = head;

        while (fast != nullptr && fast->next != nullptr) {
            slow = slow->next;
            fast = fast->next->next;

            if (slow == fast)
                return true;
        }

        return false;
    }

    ListNode* detectCycle(ListNode* head) {
        if (head == nullptr || head->next == nullptr)
            return nullptr;

        ListNode* slow = head;
        ListNode* fast = head;

        // Checking to see if there is a cycle in the linked list.
        while (fast != nullptr && fast->next != nullptr) {
            slow = slow->next;
            fast = fast->next->next;

            if (slow == fast)
                break;
        }

        // Checking to see if fast is a nullptr.
        if (slow != fast)
            return nullptr;

        slow = head;

        // Using the Floyd's cycle-detection algorithm to pinpoint the node.
        while (slow != fast) {
            slow = slow->next;
            fast = fast->next;
        }

        return slow;
    }
};
```

### Intersection Detection Algorithm

Finding the node where two linked lists intercept can also be done using the Two pointer Technique in O(m + n) time as both lists would sync up after they both meet the end of their respective list. Here is the implementation of this algorithm.

```cpp
#include "./Linked_List_Node.cpp"

class Solution {
   public:
    ListNode* getIntersectionNode(ListNode* headA, ListNode* headB) {
        if (headA == nullptr || headB == nullptr)
            return nullptr;

        ListNode* p = headA;
        ListNode* q = headB;

        while (p != q) {
            p = p == nullptr ? headB : p->next;
            q = q == nullptr ? headA : q->next;
        }

        return p;
    }
};
```

### Reversing a Linked List

A very common and classic computer science problem:

```cpp
#include "./Linked_List_Node.cpp"

class Solution {
   public:
    ListNode* reverseList(ListNode* head) {
        ListNode* prevNode = nullptr;
        ListNode* curr = head;
        ListNode* nextNode = nullptr;

        while (curr != nullptr) {
            nextNode = curr->next;
            curr->next = prevNode;
            prevNode = curr;
            curr = nextNode;
        }

        return prevNode;
    }
};
```

### Removing Elements from a Linked List

Here is a simple implementation for removing a value from a linked list.

```cpp
#include "./Linked_List_Node.cpp"

class Solution {
   public:
    ListNode* removeElements(ListNode* head, int val) {
        if (head == nullptr)
            return nullptr;

        while (head != nullptr && head->val == val) {
            head = head->next;
        }

        if (head == nullptr)
            return nullptr;

        ListNode* p = head;
        ListNode* q = head;
        ListNode* r = nullptr;

        while (p != nullptr) {
            r = p->next;

            if (p->val != val) {
                q->next = p;
                q = q->next;
            }

            if (r == nullptr) {
                q->next = nullptr;
            }

            p = r;
        }

        return head;
    }
};
```

## Doubly Linked List

A doubly linked list is just a regular linked list but with the `prev` field for reversing the prior node so we can also traverse backwards.

```cpp
#include <cstddef>
using namespace std;

struct ListNode {
    int data;
    // We store the memory address of the next node here. 
    ListNode* next;
    ListNode* prev;

    ListNode(int value) {
        this->data = value;
        this->next = nullptr;
        this->next = nullptr;
    }
}
```

### Fully Functional Doubly Linked List

```cpp
#include <iostream>
using namespace std;

class Node {
   public:
    int value;
    Node* next;
    Node* prev;

    Node(int value) {
        this->value = value;
        this->next = nullptr;
        this->prev = nullptr;
    }
};

class MyLinkedList {
    int size;

    Node* head;
    Node* tail;

   public:
    MyLinkedList() {
        this->size = 0;
        this->head = nullptr;
        this->tail = nullptr;
    }

    // Algorithm Analysis
    //      Time Complexity:     Ο(m+n) Θ(1)
    //      Space Complexity:    Ο(1) Ω(1) Θ(1)
    int get(int index) {
        if (this->size == 0 || this->size <= index)
            return -1;

        Node* curr = this->head;

        while (index != 0) {
            curr = curr->next;
            index--;
        }

        return curr->value;
    }

    // Algorithm Analysis
    //      Time Complexity:     Ο(1) Ω(1) Θ(1)
    //      Space Complexity:    Ο(1) Ω(1) Θ(1)
    void addAtHead(int value) {
        Node* newNode = new Node{value};

        if (this->size == 0) {
            this->head = newNode;
            this->tail = newNode;
            this->size++;
            return;
        }

        Node* prevHead = this->head;
        prevHead->prev = newNode;

        this->head = newNode;
        this->head->next = prevHead;

        this->size++;
    }

    // Algorithm Analysis
    //      Time Complexity:     Ο(1) Ω(1) Θ(1)
    //      Space Complexity:    Ο(1) Ω(1) Θ(1)
    void addAtTail(int value) {
        Node* newNode = new Node{value};

        if (this->size == 0) {
            this->head = newNode;
            this->tail = newNode;
            this->size++;
            return;
        }

        Node* prevTail = this->tail;
        prevTail->next = newNode;

        this->tail = newNode;
        this->tail->prev = prevTail;

        this->size++;
    }

    // Algorithm Analysis
    //      Time Complexity:     Ο(n) Θ(1)
    //      Space Complexity:    Ο(1) Ω(1) Θ(1)
    void addAtIndex(int index, int value) {
        if (index > this->size) {
            return;
        }

        if (index == 0) {
            this->addAtHead(value);
            return;
        }

        if (index == this->size) {
            this->addAtTail(value);
            return;
        }

        Node* newNode = new Node{value};
        Node* curr = this->head;

        // Accounting for Zero-indexing
        index--;

        while (index != 0) {
            curr = curr->next;
            index--;
        }

        Node* nextNode = curr->next;
        newNode->next = nextNode;
        curr->next = newNode;

        nextNode->prev = newNode;
        newNode->prev = curr;

        this->size++;
    }

    // Algorithm Analysis
    //      Time Complexity:     Ο(n) Θ(1)
    //      Space Complexity:    Ο(1) Ω(1) Θ(1)
    void deleteAtIndex(int index) {
        if (index >= size) {
            return;
        }

        // Accounting for Zero Indexing
        index--;

        Node* curr = this->head;

        while (index != 0) {
            curr = curr->next;
            index--;
        }

        if (curr == this->head) {
            // We move the head to the second node in the list.
            this->head = curr->next;

            // We then set the previous of the new head to a nullptr as long the
            // new head isn't a nullptr.
            if (this->head != nullptr) {
                this->head = nullptr;
            }
        }

        else if (curr == this->tail) {
            // We move the tail to second-to-last node in the list.
            this->tail = curr->prev;

            // We then set the next of the new tail to a nullptr as long as the
            // new tail isn't a nullptr.
            if (this->tail != nullptr) {
                this->tail->next = nullptr;
            }
        }

        else {
            // We set the next property of the previous node of current node
            // which is actually pointing to curr to the next of curr.
            curr->prev->next = curr->next;

            // We set the prev property of the next node of current node to the
            // prev of curr.
            curr->next->prev = curr->prev;
        }

        delete curr;
        this->size--;
    }

    void displayList() {
        Node* node = this->head;

        cout << "The List is [ ";
        while (node) {
            cout << node->value << " -> ";
            node = node->next;
        }

        cout << "nullptr ].\n";
    }

    void displayBackwards() {
        Node* node = this->tail;

        cout << "The Reversed List is [ ";
        while (node) {
            cout << node->value << " -> ";
            node = node->prev;
        }

        cout << "nullptr ].\n";
    }

    void displayNodeAddresses() {
        Node* node = this->head;

        cout << "The Addresses of the nodes are [ ";
        while (node) {
            cout << &(*node) << " -> ";
            node = node->next;
        }

        cout << "nullptr ].\n";
    }

    ~MyLinkedList() {
        Node* node = this->head;

        while (node) {
            Node* temp = node;
            node = node->next;

            delete temp;
        }

        cout << "Cleaned up memory" << endl;
    }
};
```
