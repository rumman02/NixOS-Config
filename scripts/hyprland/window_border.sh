#!/usr/bin/env bash

# can't support float number
gap_value=1

# Function to increase border size
increase_border_size() {
    current_size=$(hyprctl getoption general:border_size | awk 'NR==1 {print $2}')
    new_size=$((current_size + $gap_value))
    hyprctl keyword general:border_size "$new_size"
    echo "Border size increased to $new_size."
}

# Function to decrease border size
decrease_border_size() {
    current_size=$(hyprctl getoption general:border_size | awk 'NR==1 {print $2}')

    # Prevent border size from going below 0
    if [ "$current_size" -gt 0 ]; then
        new_size=$((current_size - $gap_value))
        hyprctl keyword general:border_size "$new_size"
        echo "Border size decreased to $new_size."
    else
        echo "Border size cannot go below 0."
    fi
}

increase_border_rounding() {
    current_rounding=$(hyprctl getoption decoration:rounding | awk 'NR==1 {print $2}')
    new_rounding=$((current_rounding + $gap_value))
    hyprctl keyword decoration:rounding "$new_rounding"
    echo "Border rounding increased to $new_rounding."
}

# Function to decrease border size
decrease_border_rounding() {
    current_rounding=$(hyprctl getoption decoration:rounding | awk 'NR==1 {print $2}')

    # Prevent border size from going below 0
    if [ "$current_rounding" -gt 0 ]; then
        new_rounding=$((current_rounding - $gap_value))
        hyprctl keyword decoration:rounding "$new_rounding"
        echo "Border rounding decreased to $new_rounding."
    else
        echo "Border rounding cannot go below 0."
    fi
}

# Main logic
case "$1" in
border_size_plus)
    increase_border_size
    ;;
border_size_minus)
    decrease_border_size
    ;;
border_rounding_plus)
    increase_border_rounding
    ;;
border_rounding_minus)
    decrease_border_rounding
    ;;
*)
    # echo "Usage: $0 {border_size_plus|border_size_minus|active_opacity_plus|active_opacity_minus}"
    ;;
esac
