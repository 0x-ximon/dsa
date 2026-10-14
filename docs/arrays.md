# Arrays

*Simon Samuel · 18th April, 2024*

## What is an Array?

Arrays are collections of items in which each item is stored contiguously in memory meaning checking through the entire collection is straightforward. The two most primitive Array operations are writing elements into them and reading elements from them. All other array operations are built on these two primitives. Array indexes start from `0` to `N-1` where N is the number of items in the Array.

### Reading and Writing to An Array

Below is the syntax for writing to and reading from an Array.

```cpp
#include <iostream>

int main() {
    // Create an array that holds 10 integers.
    int A[10];

    // Compute the size of the array.
    int n = sizeof(A) / sizeof(int);

    for (int i = 0; i < n; i++) {
        // Set the item at the current index to i + 1.
        A[i] = i + 1;
    }

    for (int i = 0; i < n; i++) {
        // Print out every item in the array.
        std::cout << "The item is " << A[i] << "\n";
    }
}
```

### Array Capacity vs Length

The capacity of an array is the number of elements it can hold and the length is the current number of elements in the array.

```cpp
int main() {
    // This array has a capacity of 100 integers.
    int A[100];

    // Writing into the first 20 elements means we currently have a length of 20.
    for (int i = 0; i < 20; i++) {
        A[i] = i + 1;
    }
}
```

## Basic Array Operations

### Array Insertions

Inserting into an array can take many forms:

1. Insert a new element at the end of the array.
2. Insert a new element at the beginning of the array.
3. Insert a new element at any given index of the array.

#### Inserting at the End of the array.

Using the length variable we created, we're able to easily keep track of the index to add the next element. This is a cheap operation as its time complexity is *O(1)*.

```cpp
int main() {
    // Create an array that holds 5 integers.
    int A[5];

    // Initialize the length of the array.
    int length = 0;

    // We added 3 elements to the end of the array.
    for (int i = 0; i < 3; i++) {
        A[length] = i;
        length++;
    }
}
```

#### Inserting at the Start of the array.

Inserting to the start of the array is a bit more complicated as we do not want to override the data that was at the beginning of the array. To preserve this value, we have to shift every element from the beginning to the length of the array to make room for the new data. This shifting operation is *O(n)* where *n* is the length of the array.

```cpp
int main() {
    // Create an array that holds 10 integers.
    int A[10];

    // Initialize the length of the array.
    int length = 0;

    // We added 3 elements to the end of the array.
    for (int i = 0; i < 3; i++) {
        A[length] = i;
        length++;
    }

    for (int i = length; i >= 0; i--) {
        // Set the next index to this current index.
        A[i + 1] = A[i];
    }

    // Items A[0] and A[1] now have the same value so we can override A[0] with
    // the new data.
    A[0] = 14;
}
```

#### Inserting at any index of the array.

Similar to inserting at the beginning, we simply have to move every element from the length of the array to the index we want to insert into, forward so we can override that particular index but still preserve the data.

```cpp
int main() {
    // Create an array that holds 10 integers.
    int A[10];

    // Initialize the length of the array.
    int length = 0;

    // We added 7 elements to the end of the array.
    for (int i = 0; i < 7; i++) {
        A[length] = i;
        length++;
    }

    // Moving all items in A[3, 7]
    for (int i = length; i >= 3; i--) {
        // Set the next index to this current index.
        A[i + 1] = A[i];
    }

    // We can now override the index.
    A[3] = 14;
}
```

### Array Deletions

Deleting from an array can also take these forms:

1. Delete an element at the end of the array.
2. Delete an element at the beginning of the array.
3. Delete an element at any given index of the array.

#### Deleting at the End of the array.

To delete from the end of the array simply reduce the length of the array, this means that when new data will be appended to the end of the array, it will simply override the deleted item. It is also an *O(1)* operation.

```cpp
int main() {
    // Create an array that holds 10 integers.
    int A[10];

    // Initialize the length of the array.
    int length = 0;

    // We added 7 elements to the end of the array.
    for (int i = 0; i < 7; i++) {
        A[length] = i;
        length++;
    }

    // Delete the last item
    length--;
}
```

#### Deleting at the Beginning of the array.

Since we are deleting from the beginning, we have to shift the items from the length of the array backward and override the previous item before each index. This is computationally expensive as it is an *O(n)* operation where *n* is the length of the array.

```cpp
int main() {
    // Create an array that holds 10 integers.
    int A[10];

    // Initialize the length of the array.
    int length = 0;

    // We added 7 elements to the end of the array.
    for (int i = 0; i < 7; i++) {
        A[length] = i;
        length++;
    }

    // Delete the first item by overriding it with the second and repeat until
    // We're at the end of the array.
    for (int i = 1; i < length; i++) {
        A[i - 1] = A[i];
    }

    // Delete the last element since A[length] and A[length - 1] now hold
    // the same value.
    length--;
}
```

#### Deleting at any index of the array.

Just as we did in the previous example, we're just going to begin our shift from the index we intend to delete.

```cpp
int main() {
    // Create an array that holds 10 integers.
    int A[10];

    // Initialize the length of the array.
    int length = 0;

    // We added 7 elements to the end of the array.
    for (int i = 0; i < 7; i++) {
        A[length] = i;
        length++;
    }

    // Delete the item at index 2 by overriding it with the next and repeating
    // until we're at the end of the array.
    for (int i = 3; i < length; i++) {
        A[i - 1] = A[i];
    }

    // Delete the last element since A[length] and A[length - 1] now hold
    // the same value.
    length--;
}
```

### Search in an Array

To find a particular element in an array, there are various methods we can employ, the two most common are:

1. Linear Search
2. Binary Search

#### Linear Search

Linear search is the most straightforward of searching algorithms, it is all about looping through the array one index at a time and comparing the current value with the expected value. Although Its runtime complexity is *O(n)*, its ease of implementation makes it the defacto for searching.

```cpp
#include <iostream>
#include <optional>
using namespace std;

optional<int> linearSearch(const int A[], int length, int target) {
    for (int i = 0; i < length; i++) {
        if (A[i] == target) {
            return i;
        }
    }

    return nullopt;
};

int main() {
    // Create an array that holds 10 integers.
    int A[10];

    // Initialize the length of the array.
    int length = 0;

    // We added 7 elements to the end of the array.
    for (int i = 0; i < 7; i++) {
        A[length] = i * i;
        length++;
    }

    optional<int> index = linearSearch(A, length, 9);

    if (index.has_value()) {
        cout << "9 is present at index: " << index.value() << "\n";
    } else {
        cout << "9 is not present! \n";
    }
}
```

#### Binary Search

This is a faster search algorithm as it divides the array in half in every iteration but its major drawback is that the array must be sorted for it to work.

## In-Place Operations

In-place operations are algorithms that modify the input array itself, they do not use additional space earning them a space complexity of *O(1)* as new storage will be allocated in memory.

### The Two Pointer Approach

This is a popular style for efficiently solving problems that require in-place solutions. Here is a popular example of such a problem.

> **Problem**: Remove the duplicates such that each element appears only once.\
> **Input**: A sorted integer array => `[0, 0, 1, 1, 1, 2, 2, 3, 3, 4]`\
> **Output**: A sorted integer array with no duplicates => `[0, 1, 2, 3, 4]`

This problem is relatively easy to solve when you create a new array and only clone single items but there is a better and more efficient way to solve the problem without creating a new array. To solve it in-place, we can employ the Two Pointer Approach:

1. We create two variables: `readPointer` and `writePointer`.
2. The `writePointer` is responsible for keeping track of our current index for us to insert data into.
3. The `readPointer` is responsible for reading the items in the array.

```cpp
#include "iostream"
using namespace std;

int removeDuplicates(int A[], int capacity) {
    // Edge Case
    if (capacity == 0)
        return 0;

    // The first element should not be written to.
    int writePointer = 1;
    int readPointer = 1;

    while (readPointer < capacity) {
        // If the current number being read is not same as the previous number,
        // then it is not a duplicate.
        if (A[readPointer] != A[readPointer - 1]) {
            // Save that value into the array and increase the write index.
            A[writePointer] = A[readPointer];
            writePointer++;
        }

        readPointer++;
    }

    // The writePointer is the length as it only has the number of elements that
    // are not duplicates.
    return writePointer;
};

int main() {
    // Create an array that holds our input integers.
    int A[10] = {0, 0, 1, 1, 1, 2, 2, 3, 3, 4};

    // We store the capacity of the array.
    int n = sizeof(A) / sizeof(int);

    // Get back the new length of the subarray with no duplicates and delete the
    // rest.
    int length = removeDuplicates(A, n);

    cout << "The new array is { ";
    for (int i = 0; i < length; i++) {
        cout << A[i] << ", ";
    }
    cout << "}."
         << "\n";
}
```

This solution is optimal as we only check each item once so it has a time complexity of *O(n)* and a space complexity of *O(1)*.
