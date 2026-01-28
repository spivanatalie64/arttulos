#!/bin/bash
# Dummy build script for hello package
set -e
mkdir -p /tmp/hello_art_pkg
echo "Hello from the hello package!" > /tmp/hello_art_pkg/hello.txt
tar -czf /output/hello.art -C /tmp/hello_art_pkg .
rm -rf /tmp/hello_art_pkg
