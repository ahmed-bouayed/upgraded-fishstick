#!/usr/bin/env bash
# you'll need webp installed
for file in *; do cwebp -resize 1200 600 "$file" -o "${file%.*}.webp"; done


# conver single
# cwebp images/flower.jpg -o images/flower.webp