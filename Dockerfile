# ──────────── 1. builder ────────────
FROM alpine:3.20 AS builder
RUN apk add --no-cache \
    build-base            \
    cmake                 \
    ncurses               \
    ncurses-static        \
    ncurses-dev           \
    ncurses-terminfo      \
    pkgconf               \
    git

RUN rm -f /usr/lib/libcurses.so*
RUN rm -f /usr/lib/libform.so*
RUN ln -sf /usr/lib/libncursesw.a /usr/lib/libcurses.a

RUN mkdir -p /tmp/ti \
    && infocmp -x xterm-256color > /tmp/xterm-256color.src \
    && tic -x -o /tmp/ti /tmp/xterm-256color.src

# Copy and configure
WORKDIR /src
COPY . .

# Tell CMake to hunt only for static libs and emit –static binaries
RUN cmake -S . -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_FIND_LIBRARY_SUFFIXES=".a" \
    -DCMAKE_EXE_LINKER_FLAGS="-static -s -Wl,--gc-sections" \
    -DCURSES_LIBRARIES=/usr/lib/libncursesw.a \
    -DCURSES_INCLUDE_DIR=/usr/include
RUN cmake --build build -j$(nproc)

# ──────────── 2. runtime ────────────
FROM scratch
COPY --from=builder /tmp/ti /usr/share/terminfo
ENV TERM=xterm-256color
COPY --from=builder /src/build/curseditor /curseditor
ENTRYPOINT ["/curseditor"]