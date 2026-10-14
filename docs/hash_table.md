# Hash Table

*Simon Samuel · 2025-07-25*

The *Hash Table* is a data-structure that uses *hash functions* in order to support quick insertion and search. There are two different types of hash tables: the *hash set* and the *hash map*.

1. The **hash set** is one of the implementations of the `set` meant to store *no duplicate items*.
2. The **hash map** is one of the implementations of the `map` meant to store *(key, value) pairs*.

## Design a Hash Table

The key idea of a hash table is to use a hash function to *map keys to buckets* that is:

- When we insert a new key, the hash function will decide which bucket the key should be assigned and the key will be stored in the corresponding bucket.
- When we want to search for a key, the hash table will use the same function to find the corresponding bucket and search only in the specific bucket.

### Keys to Design a Hash Table

There are two essential factors that you should attention to when you are going to design a hash table:

1. *Hash Function*: This is the most important concept of a hash table which is used to map the key to a specific bucket. The hash function will depend on the **range of the key values** and the **number of buckets**. An optimal hash function is still an open problem as in most cases, it's not perfect and it is a tradeoff between the **amount of buckets** and the **capacity of a bucket**.

2. *Collision Resolution*: Ideally if a hash function is a perfect one-one mapping between the key and the bucket then we would not need to concern with collisions. Unfortunately, these collisions are almost inevitable. A collision resolution algorithm should be concerned with these questions:

   - How to organize values in a bucket?
   - What if too many values are assigned to the same bucket?
   - How to search for a target value in a specific bucket?
