{ pkgs, config, ... }: let
	submaps = import ./submaps.nix { inherit pkgs config; };
	layout = config.wayland.windowManager.hyprland.settings.general.layout;
	is_hy3 = if layout == "hy3" then "hy3:" else "";
	brightness_value_set = pkgs.writeShellScript "brightness_value_set" (builtins.readFile ../../../../../scripts/hyprland/brightness_value_set.sh);
in
''
# menu
# bind = $mainMod, comma, exec, $menu

# brightness
binde = $mainMod, XF86AudioRaiseVolume, exec, ${brightness_value_set} increase
binde = $mainMod, XF86AudioLowerVolume, exec, ${brightness_value_set} decrease

# volume
binde = , xf86audioraisevolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
binde = , xf86audiolowervolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = , xf86audiomute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

# mouse left buttton
bindm = $mainMod, mouse:272, movewindow

# mouse middle button
bind = $mainMod, mouse:274, togglefloating

# mouse right button
bindm = $mainMod, mouse:273, resizewindow

# mouse scroll
bind = $mainMod, mouse_up, workspace, +1
bind = $mainMod, mouse_down, workspace, -1

	${ if layout == "hy3" then ''
bind = $mainMod, 1, hy3:focustab, index, 1
bind = $mainMod, 2, hy3:focustab, index, 2
bind = $mainMod, 3, hy3:focustab, index, 3
bind = $mainMod, 4, hy3:focustab, index, 4
bind = $mainMod, 5, hy3:focustab, index, 5
bind = $mainMod, 6, hy3:focustab, index, 6
bind = $mainMod, 7, hy3:focustab, index, 7
bind = $mainMod, 8, hy3:focustab, index, 8
bind = $mainMod, 9, hy3:focustab, index, 9
bind = $mainMod, 0, hy3:focustab, index, 10
	'' else ''
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10
	''}

	${ if layout == "hy3" then ''
bind = $mainMod&shift, h, hy3:focustab, l
bind = $mainMod&shift, l, hy3:focustab, r
	'' else '''' }
bind = $mainMod&shift, j, workspace, +1
bind = $mainMod&shift, k, workspace, -1

bind = $mainMod&shift, 1, ${is_hy3}movetoworkspace, 1
bind = $mainMod&shift, 2, ${is_hy3}movetoworkspace, 2
bind = $mainMod&shift, 3, ${is_hy3}movetoworkspace, 3
bind = $mainMod&shift, 4, ${is_hy3}movetoworkspace, 4
bind = $mainMod&shift, 5, ${is_hy3}movetoworkspace, 5
bind = $mainMod&shift, 6, ${is_hy3}movetoworkspace, 6
bind = $mainMod&shift, 7, ${is_hy3}movetoworkspace, 7
bind = $mainMod&shift, 8, ${is_hy3}movetoworkspace, 8
bind = $mainMod&shift, 9, ${is_hy3}movetoworkspace, 9
bind = $mainMod&shift, 0, ${is_hy3}movetoworkspace, 10

bind = $mainMod, h, ${is_hy3}movefocus, l
bind = $mainMod, j, ${is_hy3}movefocus, d
bind = $mainMod, k, ${is_hy3}movefocus, u
bind = $mainMod, l, ${is_hy3}movefocus, r

# test
bind = $mainMod, r, exec, hyprctl dispatch renameworkspace $(hyprctl activeworkspace -j | jq -r '.id') $(rofi -dmenu -p "Rename workspace:")

${submaps.window}
${submaps.tab}
${submaps.prefix}
''

# ${submaps.test}
# ${submaps.apps}

