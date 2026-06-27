#!/usr/bin/env bash

gap_value=0.01

# opacity
increase_active_opacity() {
    current_opacity=$(hyprctl getoption decoration:active_opacity | awk 'NR==1 {print $2}')
    new_opacity=$(echo "$current_opacity + $gap_value" | bc)

    # Ensure new_opacity does not exceed 1.0
    if (($(echo "$new_opacity > 1.0" | bc -l))); then
        new_opacity=1.0
    fi

    hyprctl keyword decoration:active_opacity "$new_opacity"
}

decrease_active_opacity() {
    current_opacity=$(hyprctl getoption decoration:active_opacity | awk 'NR==1 {print $2}')
    new_opacity=$(echo "$current_opacity - $gap_value" | bc)

    # Ensure new_opacity does not go below 0.0
    if (($(echo "$new_opacity < 0.0" | bc -l))); then
        new_opacity=0.0
    fi

    hyprctl keyword decoration:active_opacity "$new_opacity"
}

increase_inactive_opacity() {
    current_opacity=$(hyprctl getoption decoration:inactive_opacity | awk 'NR==1 {print $2}')
    new_opacity=$(echo "$current_opacity + $gap_value" | bc)

    # Ensure new_opacity does not exceed 1.0
    if (($(echo "$new_opacity > 1.0" | bc -l))); then
        new_opacity=1.0
    fi

    hyprctl keyword decoration:inactive_opacity "$new_opacity"
}

decrease_inactive_opacity() {
    current_opacity=$(hyprctl getoption decoration:inactive_opacity | awk 'NR==1 {print $2}')
    new_opacity=$(echo "$current_opacity - $gap_value" | bc)

    # Ensure new_opacity does not go below 0.0
    if (($(echo "$new_opacity < 0.0" | bc -l))); then
        new_opacity=0.0
    fi

    hyprctl keyword decoration:inactive_opacity "$new_opacity"
}

increase_fullscreen_opacity() {
    current_opacity=$(hyprctl getoption decoration:fullscreen_opacity | awk 'NR==1 {print $2}')
    new_opacity=$(echo "$current_opacity + $gap_value" | bc)

    # Ensure new_opacity does not exceed 1.0
    if (($(echo "$new_opacity > 1.0" | bc -l))); then
        new_opacity=1.0
    fi

    hyprctl keyword decoration:fullscreen_opacity "$new_opacity"
}

decrease_fullscreen_opacity() {
    current_opacity=$(hyprctl getoption decoration:fullscreen_opacity | awk 'NR==1 {print $2}')
    new_opacity=$(echo "$current_opacity - $gap_value" | bc)

    # Ensure new_opacity does not go below 0.0
    if (($(echo "$new_opacity < 0.0" | bc -l))); then
        new_opacity=0.0
    fi

    hyprctl keyword decoration:fullscreen_opacity "$new_opacity"
}

increase_all_window_opacity() {
    current_opacity1=$(hyprctl getoption decoration:active_opacity | awk 'NR==1 {print $2}')
    current_opacity2=$(hyprctl getoption decoration:inactive_opacity | awk 'NR==1 {print $2}')
    current_opacity3=$(hyprctl getoption decoration:fullscreen_opacity | awk 'NR==1 {print $2}')
    new_opacity1=$(echo "$current_opacity1 + $gap_value" | bc)
    new_opacity2=$(echo "$current_opacity2 + $gap_value" | bc)
    new_opacity3=$(echo "$current_opacity3 + $gap_value" | bc)

    # Ensure new_opacity does not exceed 1.0
    if (($(echo "$new_opacity1 > 1.0" | bc -l))); then
        new_opacity1=1.0
    fi
    if (($(echo "$new_opacity2 > 1.0" | bc -l))); then
        new_opacity2=1.0
    fi
    if (($(echo "$new_opacity3 > 1.0" | bc -l))); then
        new_opacity3=1.0
    fi

    hyprctl keyword decoration:active_opacity "$new_opacity1"
    hyprctl keyword decoration:inactive_opacity "$new_opacity2"
    hyprctl keyword decoration:fullscreen_opacity "$new_opacity3"
}

decrease_all_window_opacity() {
    current_opacity1=$(hyprctl getoption decoration:active_opacity | awk 'NR==1 {print $2}')
    current_opacity2=$(hyprctl getoption decoration:inactive_opacity | awk 'NR==1 {print $2}')
    current_opacity3=$(hyprctl getoption decoration:fullscreen_opacity | awk 'NR==1 {print $2}')
    new_opacity1=$(echo "$current_opacity1 - $gap_value" | bc)
    new_opacity2=$(echo "$current_opacity2 - $gap_value" | bc)
    new_opacity3=$(echo "$current_opacity3 - $gap_value" | bc)

    # Ensure new_opacity does not go below 0.0
    if (($(echo "$new_opacity1 < 0.0" | bc -l))); then
        new_opacity1=0.0
    fi
    if (($(echo "$new_opacity2 < 0.0" | bc -l))); then
        new_opacity2=0.0
    fi
    if (($(echo "$new_opacity3 < 0.0" | bc -l))); then
        new_opacity3=0.0
    fi

    hyprctl keyword decoration:active_opacity "$new_opacity1"
    hyprctl keyword decoration:inactive_opacity "$new_opacity2"
    hyprctl keyword decoration:fullscreen_opacity "$new_opacity3"
}

# Main logic
case "$1" in
active_opacity_plus)
    increase_active_opacity
    ;;
active_opacity_minus)
    decrease_active_opacity
    ;;
inactive_opacity_plus)
    increase_inactive_opacity
    ;;
inactive_opacity_minus)
    decrease_inactive_opacity
    ;;
fullscreen_opacity_plus)
    increase_fullscreen_opacity
    ;;
fullscreen_opacity_minus)
    decrease_fullscreen_opacity
    ;;
all_window_opacity_plus)
    increase_all_window_opacity
    ;;
all_window_opacity_minus)
    decrease_all_window_opacity
    ;;
*)
    # echo "Usage: $0 {border_size_plus|border_size_minus|active_opacity_plus|active_opacity_minus}"
    ;;
esac

