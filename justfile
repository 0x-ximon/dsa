set dotenv-load := true

run path name:
    g++ -std=c++23 src/{{ path }}/{{ name }}.cpp -o .cpp-build/{{ name }}
    @./.cpp-build/{{ name }}

test limit="1K":
    zig build test --fuzz={{ limit }}
