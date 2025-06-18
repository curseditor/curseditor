#!/usr/bin/env bash

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