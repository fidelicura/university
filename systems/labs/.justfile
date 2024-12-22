set shell := ["bash", "-cu"]

src := "main.s"
obj := "main.o"
exe := "main.a"
lst := "main.l"

[private]
default:
    just --list --no-aliases

alias c := clean
[doc("delete all objects and executables")]
clean name:
    @rm -f {{ name }}/{{ obj }} {{ name }}/{{ exe }} {{ name }}/{{ lst }}

alias b := build
[doc("build and run debugger")]
build name:
    @just clean {{ name }}
    @as -adhln -g {{ name }}/{{ src }} -o {{ name }}/{{ obj }} > {{ name }}/{{ lst }}
    @mold {{ name }}/{{ obj }} -o {{ name }}/{{ exe }}
    @gdb {{ name }}/{{ exe }} -ex "b _start" -ex "b exit" -ex "lay regs" -ex "source aux.gdb" -ex "r" -q -d {{ name }}

alias bs := build-secret
[doc("build and run debugger")]
build-secret name:
    just clean {{ name }}
    gcc -nostartfiles -no-pie -O0 -g {{ name }}/main.S -o {{ name }}/{{ exe }}
    gdb {{ name }}/{{ exe }} -ex "b _start" -ex "b exit" -ex "lay regs" -ex "source aux.gdb" -ex "r" -q -d {{ name }}
