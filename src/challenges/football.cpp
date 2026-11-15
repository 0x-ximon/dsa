#include <iostream>
#include <print>
#include <string>

// Code: 96A
// Name: Football
// Link: https://codeforces.com/problemset/problem/96/A

int main() {
    std::string s;
    std::cin >> s;

    size_t k = 1;
    for (size_t i = 1; i < s.length(); i++) {
        if (s[i] != s[i - 1])
            k = 1;
        else
            k++;

        if (k == 7) {
            std::println("YES");
            return 0;
        }
    }

    std::println("NO");
}
