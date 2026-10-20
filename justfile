set dotenv-load := true

run path program:
    g++ -std=c++23 src/{{ path }}/{{ program }}.cpp -o .cpp-build/{{ program }}
    @./.cpp-build/{{ program }}

test limit="1K":
    zig build test --fuzz={{ limit }}
