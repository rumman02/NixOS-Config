#!/usr/bin/env bash

# Read current gaps in
read gap1 gap2 gap3 gap4 <<<$(hyprctl getoption general:gaps_in | awk '/custom type:/ {print $3, $4, $5, $6}')
# Read current gaps out
read gap1_out gap2_out gap3_out gap4_out <<<$(hyprctl getoption general:gaps_out | awk '/custom type:/ {print $3, $4, $5, $6}')
echo $gap1 $gap1_out $gap2 $gap2_out $gap3 $gap3_out $gap4 $gap4_out

# can't support float number
gap_value=2

# Function to ensure gap value does not go below 0
ensure_non_negative() {
    if [ "$1" -lt 0 ]; then
        echo 0
    else
        echo "$1"
    fi
}

# Function to set gaps_in
set_gaps_in() {
    hyprctl keyword general:gaps_in "$gap1,$gap2,$gap3,$gap4"
    echo "Gaps in set to: $gap1 (top), $gap2 (right), $gap3 (bottom), $gap4 (left)"
}

# Function to set gaps_out
set_gaps_out() {
    hyprctl keyword general:gaps_out "$gap1_out,$gap2_out,$gap3_out,$gap4_out"
    echo "Gaps out set to: $gap1_out (top), $gap2_out (right), $gap3_out (bottom), $gap4_out (left)"
}

# Increase and decrease functions for top gap
gaps_in_increase_top() {
    gap1=$(echo "$gap1 + $gap_value" | bc)
    gap1=$(ensure_non_negative "$gap1")
    set_gaps_in
}

gaps_out_increase_top() {
    gap1_out=$(echo "$gap1_out + $gap_value" | bc)
    gap1_out=$(ensure_non_negative "$gap1_out")
    set_gaps_out
}

gaps_all_increase_top() {
    gaps_in_increase_top
    gaps_out_increase_top
}

gaps_in_decrease_top() {
    gap1=$(echo "$gap1 - $gap_value" | bc)
    gap1=$(ensure_non_negative "$gap1")
    set_gaps_in
}

gaps_out_decrease_top() {
    gap1_out=$(echo "$gap1_out - $gap_value" | bc)
    gap1_out=$(ensure_non_negative "$gap1_out")
    set_gaps_out
}

gaps_all_decrease_top() {
    gaps_in_decrease_top
    gaps_out_decrease_top
}

# Increase and decrease functions for right gap
gaps_in_increase_right() {
    gap2=$(echo "$gap2 + $gap_value" | bc)
    gap2=$(ensure_non_negative "$gap2")
    set_gaps_in
}

gaps_out_increase_right() {
    gap2_out=$(echo "$gap2_out + $gap_value" | bc)
    gap2_out=$(ensure_non_negative "$gap2_out")
    set_gaps_out
}

gaps_all_increase_right() {
    gaps_in_increase_right
    gaps_out_increase_right
}

gaps_in_decrease_right() {
    gap2=$(echo "$gap2 - $gap_value" | bc)
    gap2=$(ensure_non_negative "$gap2")
    set_gaps_in
}

gaps_out_decrease_right() {
    gap2_out=$(echo "$gap2_out - $gap_value" | bc)
    gap2_out=$(ensure_non_negative "$gap2_out")
    set_gaps_out
}

gaps_all_decrease_right() {
    gaps_in_decrease_right
    gaps_out_decrease_right
}

# Increase and decrease functions for bottom gap
gaps_in_increase_bottom() {
    gap3=$(echo "$gap3 + $gap_value" | bc)
    gap3=$(ensure_non_negative "$gap3")
    set_gaps_in
}

gaps_out_increase_bottom() {
    gap3_out=$(echo "$gap3_out + $gap_value" | bc)
    gap3_out=$(ensure_non_negative "$gap3_out")
    set_gaps_out
}

gaps_all_increase_bottom() {
    gaps_in_increase_bottom
    gaps_out_increase_bottom
}

gaps_in_decrease_bottom() {
    gap3=$(echo "$gap3 - $gap_value" | bc)
    gap3=$(ensure_non_negative "$gap3")
    set_gaps_in
}

gaps_out_decrease_bottom() {
    gap3_out=$(echo "$gap3_out - $gap_value" | bc)
    gap3_out=$(ensure_non_negative "$gap3_out")
    set_gaps_out
}

gaps_all_decrease_bottom() {
    gaps_in_decrease_bottom
    gaps_out_decrease_bottom
}

# Increase and decrease functions for left gap
gaps_in_increase_left() {
    gap4=$(echo "$gap4 + $gap_value" | bc)
    gap4=$(ensure_non_negative "$gap4")
    set_gaps_in
}

gaps_out_increase_left() {
    gap4_out=$(echo "$gap4_out + $gap_value" | bc)
    gap4_out=$(ensure_non_negative "$gap4_out")
    set_gaps_out
}

gaps_all_increase_left() {
    gaps_in_increase_left
    gaps_out_increase_left
}

gaps_in_decrease_left() {
    gap4=$(echo "$gap4 - $gap_value" | bc)
    gap4=$(ensure_non_negative "$gap4")
    set_gaps_in
}

gaps_out_decrease_left() {
    gap4_out=$(echo "$gap4_out - $gap_value" | bc)
    gap4_out=$(ensure_non_negative "$gap4_out")
    set_gaps_out
}

gaps_all_decrease_left() {
    gaps_in_decrease_left
    gaps_out_decrease_left
}

# Add similar functions for combinations and all gaps as needed
# For example:
gaps_in_increase_all() {
    gaps_in_increase_top
    gaps_in_increase_right
    gaps_in_increase_bottom
    gaps_in_increase_left
}

gaps_out_increase_all() {
    gaps_out_increase_top
    gaps_out_increase_right
    gaps_out_increase_bottom
    gaps_out_increase_left
}

gaps_all_increase_all() {
    gaps_in_increase_all
    gaps_out_increase_all
}

gaps_in_decrease_all() {
    gaps_in_decrease_top
    gaps_in_decrease_right
    gaps_in_decrease_bottom
    gaps_in_decrease_left
}

gaps_out_decrease_all() {
    gaps_out_decrease_top
    gaps_out_decrease_right
    gaps_out_decrease_bottom
    gaps_out_decrease_left
}

gaps_all_decrease_all() {
    gaps_in_decrease_all
    gaps_out_decrease_all
}

# Example usage (uncomment to use):
# gaps_all_increase_all
# gaps_all_decrease_all

# Main logic
case "$1" in
gaps_in_increase_top)
    gaps_in_increase_top
    ;;
gaps_out_increase_top)
    gaps_out_increase_top
    ;;
gaps_all_increase_top)
    gaps_all_increase_top
    ;;
gaps_in_decrease_top)
    gaps_in_decrease_top
    ;;
gaps_out_decrease_top)
    gaps_out_decrease_top
    ;;
gaps_all_decrease_top)
    gaps_all_decrease_top
    ;;

gaps_in_increase_right)
    gaps_in_increase_right
    ;;
gaps_out_increase_right)
    gaps_out_increase_right
    ;;
gaps_all_increase_right)
    gaps_all_increase_right
    ;;
gaps_in_decrease_right)
    gaps_in_decrease_right
    ;;
gaps_out_decrease_right)
    gaps_out_decrease_right
    ;;
gaps_all_decrease_right)
    gaps_all_decrease_right
    ;;

gaps_in_increase_bottom)
    gaps_in_increase_bottom
    ;;
gaps_out_increase_bottom)
    gaps_out_increase_bottom
    ;;
gaps_all_increase_bottom)
    gaps_all_increase_bottom
    ;;
gaps_in_decrease_bottom)
    gaps_in_decrease_bottom
    ;;
gaps_out_decrease_bottom)
    gaps_out_decrease_bottom
    ;;
gaps_all_decrease_bottom)
    gaps_all_decrease_bottom
    ;;

gaps_in_increase_left)
    gaps_in_increase_left
    ;;
gaps_out_increase_left)
    gaps_out_increase_left
    ;;
gaps_all_increase_left)
    gaps_all_increase_left
    ;;
gaps_in_decrease_left)
    gaps_in_decrease_left
    ;;
gaps_out_decrease_left)
    gaps_out_decrease_left
    ;;
gaps_all_decrease_left)
    gaps_all_decrease_left
    ;;
*)
    # echo "Usage: $0 {border_size_plus|border_size_minus|active_opacity_plus|active_opacity_minus}"
    ;;
esac
