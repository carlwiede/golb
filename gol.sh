#!/usr/bin/bash

# Def ------------------------
rows=$(stty size | cut -d ' ' -f 1)
cols=$(stty size | cut -d ' ' -f 2)
iterations=0
alive_next=1

declare -A current
declare -A next

# Fun ------------------------
hide_cursor() {
    printf "\033[?25l"
}

show_cursor() {
    printf "\033[?25h"
}

iterate() {
    ((iterations++))
}

print_iterations() {
    echo "Iterations: $iterations"
}

print_square() {
    local row=$1
    local col=$2
    printf "\033[%d;%dH" "$row" "$col"
    printf "#"
}

initialize_grid() {
    for ((r=1; r<=rows; r++)); do
        for ((c=1; c<=cols; c++)); do
            current[$r,$c]=0
            next[$r,$c]=0
        done
    done
}

set_starting_cells() {
	# Glider B)
	next[2,3]=1
    next[3,4]=1
    next[4,2]=1
    next[4,3]=1
    next[4,4]=1
}

startup() {
    hide_cursor
    clear
	initialize_grid
	set_starting_cells
}

finish() {
    clear
    show_cursor
    print_iterations
}

count_live_neighbors() {
    local r=$1
    local c=$2
    local count=0
    for dr in -1 0 1; do
        for dc in -1 0 1; do
            if [ $dr -ne 0 ] || [ $dc -ne 0 ]; then
                local nr=$((r + dr))
                local nc=$((c + dc))
                if (( nr >= 1 && nr <= rows && nc >= 1 && nc <= cols )); then
                    if [ "${current[$nr,$nc]}" -eq 1 ]; then
                        count=$((count + 1))
                    fi
                fi
            fi
        done
    done
    echo $count
}

update_next() {
	iterate
	((alive_next=0))
    for ((r=1; r<=rows; r++)); do
        for ((c=1; c<=cols; c++)); do
            live_neighbors=$(count_live_neighbors $r $c)
            if [ "${current[$r,$c]}" -eq 1 ]; then
                if [ $live_neighbors -lt 2 ] || [ $live_neighbors -gt 3 ]; then
                    next[$r,$c]=0
                else
                    next[$r,$c]=1
					((alive_next++))
                fi
            else
                if [ $live_neighbors -eq 3 ]; then
                    next[$r,$c]=1
					((alive_next++))
                else
                    next[$r,$c]=0
                fi
            fi
        done
    done
}

draw() {
	for ((r=1; r<=rows; r++)); do
        for ((c=1; c<=cols; c++)); do
            current[$r,$c]=${next[$r,$c]}
			if [ "${current[$r,$c]}" -eq 1 ]; then
                print_square $r $c
            fi
        done
    done
}

# Run ------------------------
startup
trap finish EXIT

while [ $alive_next -gt 0 ]
do
	draw
	update_next
	clear
done

sleep 2
