#include <iostream>

// Code: 4A
// Name: Watermelon
// Link: https://codeforces.com/problemset/problem/4/A

int main() {
    int w;
    std::cin >> w;

    if (w > 2 && w % 2 == 0)
        std::cout << "YES";

    else
        std::cout << "NO";
}
