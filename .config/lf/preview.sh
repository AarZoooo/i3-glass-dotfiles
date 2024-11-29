#!/bin/bash

case "$1" in
  # Image preview
  *.png|*.jpg|*.jpeg|*.gif|*.bmp|*.webp|*.tiff|*.svg) 
    ueberzug layer --silent --parser bash <<EOF
    add [identifier] {
      path: "$1"
      x: $3
      y: $2
      width: $4
      height: $5
    }
EOF
    ;;
  # Video preview
  *.mp4|*.mkv|*.webm|*.avi|*.mov|*.flv)
    ffmpegthumbnailer -i "$1" -o /tmp/lfthumb.png -s 0
    ueberzug layer --silent --parser bash <<EOF
    add [identifier] {
      path: "/tmp/lfthumb.png"
      x: $3
      y: $2
      width: $4
      height: $5
    }
EOF
    ;;
  # Text files with syntax highlighting
  *.txt|*.md|*.py|*.java|*.sh|*.c|*.cpp)
    highlight --out-format=ansi "$1" || cat "$1"
    ;;
  # PDF preview (thumbnail)
  *.pdf)
    pdftoppm -f 1 -l 1 -singlefile -jpeg "$1" /tmp/lfpdf
    ueberzug layer --silent --parser bash <<EOF
    add [identifier] {
      path: "/tmp/lfpdf.jpg"
      x: $3
      y: $2
      width: $4
      height: $5
    }
EOF
    ;;
  # Fallback for other files
  *)
    file --mime-type "$1" | awk '{print $2}'
    ;;
esac

