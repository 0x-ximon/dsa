#include <iostream>
#include <print>

// Code: 4A
// Name: Watermelon
// Link: https://codeforces.com/problemset/problem/4/A

int main() {
    int w;
    std::cin >> w;

    if (w > 2 && w % 2 == 0)
        std::println("YES");

    else
        std::println("NO");
}
