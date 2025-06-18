# curseditor

A terminal-native text editor with zero dependencies. No fluff. No runtime. Just an ELF.

---

## Dynamic build

### Requirements

- CMake ≥ 3.20
- A C++ compiler (GCC or Clang)
- ncurses development headers

### Steps

```bash
mkdir build
cd build
cmake ..
make
````

This produces a dynamically linked `curseditor` binary.

---

## Static build

Produces a fully static, musl-linked ELF that runs **anywhere**.

### Steps

```bash
# Clean slate
rm -rf build

# Build up to the builder stage
docker build -t curseditor-builder --target builder .

# Create a temporary container
cid=$(docker create curseditor-builder)

# Copy the binary from the container
docker cp "$cid":/src/build/curseditor ./curseditor

# Clean up
docker rm "$cid"
```

---

## Running

```bash
./curseditor
```

Works on any x86\_64 Linux system with kernel ≥ 3.2.
TERM must be set correctly. Default is `xterm-256color`. For tmux users:

```bash
TERM=tmux-256color ./curseditor
```

---

## Notes

* Fully static (musl-linked)
* Uses static ncurses (wide-character)
* Self-contained terminfo entry for `xterm-256color`
* No dynamic linker, no runtime dependencies, no install required

