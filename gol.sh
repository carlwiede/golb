#!/usr/bin/bash

# Def ------------------------
rows=$(stty size | cut -d ' ' -f 1)
cols=$(stty size | cut -d ' ' -f 2)
time=0

# Fun ------------------------
hide_cursor() {
  printf "\033[?25l"
}

show_cursor() {
  printf "\033[?25h"
}

increment_time() {
    ((time++))
}

print_time() {
    echo "Time: $time"
}

print_square() {
  local row=$1
  local col=$2
  printf "\033[%d;%dH" "$row" "$col"
  printf "#"
}

startup() {
    hide_cursor
    clear
}

finish() {
    clear
    show_cursor
    print_time
}

# Run ------------------------
startup
trap finish EXIT

print_square 5 5

increment_time

sleep 2
