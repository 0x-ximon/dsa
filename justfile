set dotenv-load := true

run path name:
    g++ -std=c++23 src/{{ path }}/{{ name }}.cpp -o .cpp-build/{{ name }}
    @./.cpp-build/{{ name }}

test:
    zig build test --fuzz=1K
