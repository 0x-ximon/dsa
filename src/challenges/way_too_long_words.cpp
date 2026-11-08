#include <iostream>
#include <print>
#include <string>

// Code: 71A
// Name: Way Too Long Words
// Link: https://codeforces.com/problemset/problem/71/A

int main() {
    int n;
    std::cin >> n;

    for (size_t i = 0; i < n; i++) {
        std::string s;
        std::cin >> s;

        if (s.size() <= 10) {
            std::println("{}", s);
            continue;
        }

        char first = s[0];
        char last = s[s.size() - 1];
        std::string mid = std::to_string(s.size() - 2);

        s = first + mid + last;
        std::println("{}", s);
    }
}
