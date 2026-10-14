# Queue and Stack

*Simon Samuel · 2025-03-27*

## Queue: First-in-First-out Data Structure

In an FIFO data structure, the **first element added to the queue will be processed first.** The insert operation is also called `enqueue` and the new element is always **added at the end of the queue**. The delete operation is also called `dequeue` and you're only allowed to **remove the first element**.

To implement a `Queue`, we may use a dynamic array and have a head pointing to the writing index as in this:

```cpp
#include <vector>
using namespace std;

class Queue {
   private:
    std::vector<int> data;
    int head;

   public:
    Queue() { head = 0; };

    bool enqueue(int val) {
        data.push_back(val);
        return true;
    }

    bool dequeue() {
        if (head >= data.size()) {
            return false;
        };

        head++;
        return true;
    }

    int read() {
        if (head >= data.size()) {
            return 0;
        }

        return data[head];
    }
};
```

This becomes very inefficient as we have spaces in front that actually never get filled after dequeing. We can instead try using a circular queue.

### Circular Queue

A more effective solution would be to use a static array and then have two pointers pointing to the head and tail of the queue. So you know where to insert to and delete from during enqueing and dequeing. This is the most optimal as all operations are constant time.

```cpp
#include <vector>
using namespace std;

class CircularQueue {
   private:
    vector<int> data;
    int length;

    int head;
    int tail;

   public:
    CircularQueue(int k) {
        head = 0;
        tail = -1;

        length = 0;
        data.resize(k);
    }

    // Algorithm Analysis
    //      Time Complexity:     Ο(1) Ω(1) Θ(1)
    //      Space Complexity:    Ο(1) Ω(1) Θ(1)
    bool enQueue(int value) {
        if (isFull())
            return false;

        if (tail == data.size() - 1)
            tail = 0;
        else
            tail++;

        data[tail] = value;

        length++;
        return true;
    }

    // Algorithm Analysis
    //      Time Complexity:     Ο(1) Ω(1) Θ(1)
    //      Space Complexity:    Ο(1) Ω(1) Θ(1)
    bool deQueue() {
        if (isEmpty())
            return false;

        if (head == data.size() - 1)
            head = 0;
        else
            head++;

        length--;
        return true;
    }

    // Algorithm Analysis
    //      Time Complexity:     Ο(1) Ω(1) Θ(1)
    //      Space Complexity:    Ο(1) Ω(1) Θ(1)
    int Front() {
        if (isEmpty())
            return -1;

        return data[head];
    }

    // Algorithm Analysis
    //      Time Complexity:     Ο(1) Ω(1) Θ(1)
    //      Space Complexity:    Ο(1) Ω(1) Θ(1)
    int Rear() {
        if (isEmpty())
            return -1;

        return data[tail];
    }

    // Algorithm Analysis
    //      Time Complexity:     Ο(1) Ω(1) Θ(1)
    //      Space Complexity:    Ο(1) Ω(1) Θ(1)
    bool isFull() { return length == data.size(); }

    // Algorithm Analysis
    //      Time Complexity:     Ο(1) Ω(1) Θ(1)
    //      Space Complexity:    Ο(1) Ω(1) Θ(1)
    bool isEmpty() { return length == 0; }
};
```

## Queue and BFS

One common application of Breadth-first Search (BFS) is to find the shortest part from the root node to the target node. The Breadth-First template is given as:

```java
/**
 * Return the length of the shortest path between root and target node.
 */
int BFS(Node root, Node target) {
    Queue<Node> queue;  // store all nodes which are waiting to be processed
    Set<Node> visited;  // store all the nodes that we've visited
    int step = 0;       // number of steps needed from root to current node

    // initialize
    add root to queue;
    add root to visited;

    // BFS
    while (queue is not empty) {
        // iterate the nodes which are already in the queue
        int size = queue.size();

        for (int i = 0; i < size; ++i) {
            Node cur = the first node in queue;
            return step if cur is target;

            for (Node next : the neighbors of cur) {
                if (next is not in visited) {
                    add next to queue;
                    add next to visited;
                }
            }

            remove the first node from queue;
        }

        step = step + 1;
    }

    return -1;          // there is no path from root to target
}
```

## Stack: Last-in-First-out Data Structure

In an LIFO data structure, **the newest element added to the queue will be processed first**. The insert operation is called `push` and the new element is always **added to the end of the stack**. The delete operation is also called `pop` and you can only **remove the last element**.

### Minimum Stack

To show the efficiency of a stack, we implement a minimum stack that is able to return the minimum element in the stack at all times and perform all operations in constant time.

```cpp
#include <algorithm>
using namespace std;

class StackNode {
   public:
    int min;
    int data;

    StackNode* next;

    StackNode(int data, int min) {
        this->next = nullptr;
        this->data = data;
        this->min = min;
    }
};

class MinStack {
    StackNode* head;

   public:
    MinStack() { head = nullptr; }

    void push(int val) {
        if (head == nullptr) {
            head = new StackNode(val, val);
        } else {
            int newMin = min(head->min, val);
            StackNode* newHead = new StackNode(val, newMin);

            newHead->next = head;
            head = newHead;
        }
    }

    void pop() { head = head->next; }

    int top() { return head->data; }

    int getMin() { return head->min; }
};
```

## Stacks and DFS

Similar to the Breadth-First Search, the Depth-First Search is another important algorithm in computer science especially used in various computations such as *tree traversal*. The DFS algorithm works similarly to BFS but has one major difference: BFS can not go deeper until it has visited all nodes at the current level while DFS will not trace back until we reach the deepest node.

The recursive Depth-First template is given as:

```java
/** 
* Returns true if there is a path from cur to target.
*/
boolean DFS(Node cur, Node target, Set<Node> visited) {
    return true if cur is target;
    for (next : each neighbor of cur) {
        if (next is not in visited) {
            add next to visited;
            return true if DFS(next, target, visited);
        }
    }
    return false;
}
```

Although this recursive approach does not explicitly use a stack, we're implicitly using one: *The Function Call Stack*. We can also run into issues if the depth of the recursion is too high; in that case, we could use BFS or explicitly define a stack.

```java
/*
 * Return true if there is a path from cur to target.
 */
boolean DFS(int root, int target) {
    Set<Node> visited;
    Stack<Node> stack;
    add root to visited;
    add root to stack;
    while (stack is not empty) {
        Node cur = the top element in stack;
        remove the cur from the stack;
        return true if cur is target;
        for (Node next : the neighbors of cur) {
            if (next is not in visited) {
                add next to visited;
                add next to stack;
            }
        }
    }
    return false;
}
```
