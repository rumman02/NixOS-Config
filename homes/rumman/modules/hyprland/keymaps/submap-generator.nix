{ pkgs, ... }: let
  submap_mod_reset_script_path = pkgs.writeShellScript "submap_mod_reset_script_path" (builtins.readFile ../../../../../scripts/hyprland/reset_submap.sh);
	ks = "   ";
in {
  submap_name,
  mod_key,
  sub_key,
  parent_submap,
  body,
}:/*conf*/
''
# ${submap_name} prefix key
${"$"}${submap_name}_mode = ${mod_key}, ${sub_key} # if main submap or nested submap has mod key

# =========================================================================== #
#                             starting submap block                           #
#                            (submap ${submap_name})                          #
# --------------------------------------------------------------------------- #
$submap_${submap_name} = ${submap_name}${ks}${ks}${builtins.concatStringsSep ks (map (item: builtins.head (builtins.attrNames item)) body)}${ks}│${ if parent_submap == "" then "${ks}[󱊷]Exit" else "${ks}[󱞳]Back${ks}[󱊷]Exit" }

bind = ${"$"}${submap_name}_mode, exec, ${submap_mod_reset_script_path} active # actives here
bind = ${"$"}${submap_name}_mode, submap, $submap_${submap_name} # set submap by keybind

submap = $submap_${submap_name} # call that submap

${ if parent_submap != "" then ''
bind = , backspace, exec, ${submap_mod_reset_script_path} active
bind = , backspace, submap, $submap_${parent_submap}
'' else "" }

bind = , escape, exec, ${submap_mod_reset_script_path} exited # exited here
bind = , escape, submap, reset # for safety, reset submap by escape key

# =========================================================================== #

# tasks here
# ===========
${builtins.concatStringsSep "\n	" (builtins.concatMap (item:
	if builtins.isString item then
		[item]
	else if builtins.isAttrs item then
		let
			keys = builtins.attrNames item;
			keyName = builtins.head keys;
			bindData = builtins.getAttr keyName item;
		in
			if builtins.isString bindData then
				let
					# Try to match any bind command pattern: bind* =
					bindMatch = builtins.match "(bind[^=]*) *= *(.*)" bindData;
				in
					if bindMatch != null then
						# It's a bind command, extract the bind type and the rest
						let
							bindType = builtins.elemAt bindMatch 0;  # e.g., "bind", "binde", "bindr", etc.
							restOfBind = builtins.elemAt bindMatch 1; # everything after "bind* = "
							parts = builtins.match "([^,]*), *([^,]+), *(.*)" restOfBind;
							modKey = if parts != null then builtins.elemAt parts 0 else "";
							subKey = if parts != null then builtins.elemAt parts 1 else "";
						in
							if parts != null then [
								"${bindType} = ${modKey}, ${subKey}, exec, ${submap_mod_reset_script_path} active"
								bindData
							] else [
								bindData
							]
					else
						# It's a nested submap (full configuration string), include as-is without script
						[bindData]
			else
				[]
	else
		[]
) body)}

# =========================================================================== #
#                              ending submap block                            #
#                            (submap ${submap_name})                          #
# --------------------------------------------------------------------------- #

${ if parent_submap != "" then ''
bind = , backspace, exec, ${submap_mod_reset_script_path} active
bind = , backspace, submap, $submap_${parent_submap}
'' else "" }

bind = , escape, exec, ${submap_mod_reset_script_path} exited # exited here
bind = , escape, submap, reset # after tasks, reset submap by escape key

submap = ${ if parent_submap == "" then "reset" else "$submap_${parent_submap}" }

# =========================================================================== #
''
# { pkgs, ... }: let
#   submap_mod_reset_script_path = pkgs.writeShellScript "submap_mod_reset_script_path" (builtins.readFile ../../../scripts/hyprland/reset_submap.sh);
# 	ks = "   "; # key space
# in {
#   submap_name,
#   mod_key,
#   sub_key,
#   parent_submap,
#   body,
# }:/*conf*/
# ''
# # ${submap_name} prefix key
# ${"$"}${submap_name}_mode = ${mod_key}, ${sub_key} # if main submap or nested submap has mod key
#
# # =========================================================================== #
# #                             starting submap block                           #
# #                            (submap ${submap_name})                          #
# # --------------------------------------------------------------------------- #
# $submap_${submap_name} = ${submap_name}${ks}${ks}${builtins.concatStringsSep ks (builtins.filter (x: x != "") (builtins.concatMap (item:
# 	if builtins.isString item then
# 		[]  # Skip string items for display
# 	else if builtins.isAttrs item then
# 		let
# 			keys = builtins.attrNames item;
# 			keyName = builtins.head keys;
# 		in
# 			[keyName]  # Always show the key name in display
# 	else
# 		[]
# ) body))}${ks}│${ if parent_submap == "" then "${ks}[󱊷]Exit" else "${ks}[󱞳]Back${ks}[󱊷]Exit" }
#
# bind = ${"$"}${submap_name}_mode, exec, ${submap_mod_reset_script_path} active # actives here
# bind = ${"$"}${submap_name}_mode, submap, $submap_${submap_name} # set submap by keybind
#
# submap = $submap_${submap_name} # call that submap
#
# ${ if parent_submap != "" then ''
# bind = , backspace, exec, ${submap_mod_reset_script_path} active
# bind = , backspace, submap, $submap_${parent_submap}
# '' else "" }
#
# bind = , escape, exec, ${submap_mod_reset_script_path} exited # exited here
# bind = , escape, submap, reset # for safety, reset submap by escape key
#
# # =========================================================================== #
#
# # tasks here
# # ===========
# ${builtins.concatStringsSep "\n	" (builtins.concatMap (item:
# 	if builtins.isString item then
# 		[item]
# 	else if builtins.isAttrs item then
# 		let
# 			keys = builtins.attrNames item;
# 			keyName = builtins.head keys;
# 			bindData = builtins.getAttr keyName item;
# 		in
# 			if builtins.isString bindData then
# 				let
# 					# Try to match any bind command pattern: bind* =
# 					bindMatch = builtins.match "(bind[^=]*) *= *(.*)" bindData;
# 				in
# 					if bindMatch != null then
# 						# It's a bind command, extract the bind type and the rest
# 						let
# 							bindType = builtins.elemAt bindMatch 0;  # e.g., "bind", "binde", "bindr", etc.
# 							restOfBind = builtins.elemAt bindMatch 1; # everything after "bind* = "
# 							parts = builtins.match "([^,]*), *([^,]+), *(.*)" restOfBind;
# 							modKey = if parts != null then builtins.elemAt parts 0 else "";
# 							subKey = if parts != null then builtins.elemAt parts 1 else "";
# 						in
# 							if parts != null then [
# 								"${bindType} = ${modKey}, ${subKey}, exec, ${submap_mod_reset_script_path} active"
# 								bindData
# 							] else [
# 								bindData
# 							]
# 					else
# 						# It's a nested submap (full configuration string), include as-is without script
# 						[bindData]
# 			else
# 				[]
# 	else
# 		[]
# ) body)}
#
# # =========================================================================== #
# #                              ending submap block                            #
# #                            (submap ${submap_name})                          #
# # --------------------------------------------------------------------------- #
#
# ${ if parent_submap != "" then ''
# bind = , backspace, exec, ${submap_mod_reset_script_path} active
# bind = , backspace, submap, $submap_${parent_submap}
# '' else "" }
#
# bind = , escape, exec, ${submap_mod_reset_script_path} exited # exited here
# bind = , escape, submap, reset # after tasks, reset submap by escape key
#
# submap = ${ if parent_submap == "" then "reset" else "$submap_${parent_submap}" }
#
# # =========================================================================== #
# ''


# { pkgs, ... }: let
# 	submap_mod_reset_script_path = pkgs.writeShellScript "submap_mod_reset_script_path" (builtins.readFile ../../../scripts/hyprland/reset_submap.sh);
#
# in {
# 	# generate_submap = let
# 	# 	ks = "   "; # key space
# 	# in {
# 	# 	submap_name,
# 	# 	mod_key,
# 	# 	sub_key,
# 	# 	parent_submap,
# 	# 	body,
# 	# }:/*conf*/
# 	# ''
# 	# # NOTE: to use this templates > replace the _n_ with name,
# 	# # replace the _p_ with one level upper submap name/variable
# 	#
# 	# # ${submap_name} prefix key
# 	# ${"$"}${submap_name}_mode = ${ if parent_submap == "" then "${mod_key}, ${sub_key}" else " , ${sub_key}" } # if main submap or nested submap has mod key
# 	#
# 	# # =========================================================================== #
# 	# #                             starting submap block                           #
# 	# #                            (submap ${submap_name})                          #
# 	# # --------------------------------------------------------------------------- #
# 	# # NOTE: this is also a submap and also this will show as display message in waybar
# 	# # if main submap then remove submap with back option
# 	# $submap_${submap_name} = ${submap_name}${ks}${ks}hello${ks}world${ks}│${ if parent_submap == "" then "${ks}(  󱊷   )Exit" else "${ks}(  󰁮    )Back${ks}(  󱊷   )Exit" }
# 	#
# 	# # this script is for auto close the running submap after a certain amount of time
# 	# bind = ${"$"}${submap_name}_mode, exec, ${submap_mod_reset_script_path} active # actives here
# 	# bind = ${"$"}${submap_name}_mode, submap, $submap_${submap_name} # set submap by keybind
# 	#
# 	# submap = $submap_${submap_name} # call that submap
# 	#
# 	# ${ if parent_submap != "" then ''
# 	# # NOTE: if you have no upper level submap then remove it,
# 	# # if you are in nested then place one level up submap
# 	# bind = , backspace, exec, ${submap_mod_reset_script_path} active
# 	# bind = , backspace, submap, $submap_${parent_submap}
# 	# '' else "" }
# 	#
# 	# # fix the auto close scripts timing by this scripts, it will cancel the time
# 	# # immediately, so that it will not effect the other submap
# 	# bind = , escape, exec, ${submap_mod_reset_script_path} exited # exited here
# 	# bind = , escape, submap, reset # for safety, reset submap by escape key
# 	#
# 	# # =========================================================================== #
# 	#
# 	# # tasks here
# 	# # ===========
# 	#
# 	# # NOTE: if repeated bind key then use "binde = "
# 	# # else single then use "bind = "
# 	# #
# 	# # if no mod_key then use it or remove it
# 	# # binde = <mod_key>, <key>, exec, ${submap_mod_reset_script_path} active # you need to place that before your every keybind
# 	# # binde = <mod_key>, <key>, options, opts
# 	# # bind = <mod_key>, <key>, exec, ${submap_mod_reset_script_path} active # you need to place that before your every keybind
# 	# # bind = <mod_key>, <key>, options, opts
# 	# #
# 	# # or execute commands
# 	# # binde = <mod_key>, <key>, exec, ${submap_mod_reset_script_path} active # you need to place that before your every keybind
# 	# # binde = , <key>, exec, commands
# 	# # bind = <mod_key>, <key>, exec, ${submap_mod_reset_script_path} active # you need to place that before your every keybind
# 	# # bind = , <key>, exec, commands
# 	#
# 	# # example for value of list of attr set value
# 	# bind = SUPER_L, o, movetoworkspace, l
# 	# bind = SUPER_L&CTRL_R, w, movewindow, d
# 	#
# 	# # if source it, then
# 	# # source = ~/.config/hypr/submaps/.conf
# 	#
# 	# # =========================================================================== #
# 	# #                              ending submap block                            #
# 	# #                            (submap ${submap_name})                          #
# 	# # --------------------------------------------------------------------------- #
# 	#
# 	# ${ if parent_submap != "" then ''
# 	# # NOTE: if you have no upper level submap then remove it,
# 	# # if you are in nested then place one level up submap
# 	# bind = , backspace, exec, ${submap_mod_reset_script_path} active
# 	# bind = , backspace, submap, $submap_${parent_submap}
# 	# '' else "" }
# 	#
# 	# # fix the auto close scripts timing by this scripts, it will cancel the time
# 	# # immediately, so that it will not effect the other submap
# 	# bind = , escape, exec, ${submap_mod_reset_script_path} exited # exited here
# 	# bind = , escape, submap, reset # after tasks, reset submap by escape key
# 	#
# 	# # NOTE: if you are at most upper level submap then use "reset" or if nested then
# 	# # place one level upper submap
# 	# submap = ${ if parent_submap == "" then "reset" else "$submap_${parent_submap}" }
# 	#
# 	# # =========================================================================== #
# 	#
# 	# '';
# 	#
# 	# blur = generate_submap {
# 	# 	# ...
# 	# };
# 	#
# 	# window = generate_submap {
# 	# 	submap_name = "window";
# 	# 	mod_key = "super";
# 	# 	sub_key = "w";
# 	# 	parent_submap = "";
# 	# 	body = [
# 	# 		{ "hello" = "bind = SUPER_L, o, movetoworkspace, l"; }
# 	# 		{ "world" = "bind = SUPER_L&CTRL_R, w, movewindow, d"; }
# 	# 		blur
# 	# 	];
# 	# };
# 	#
#
# 	# generate_submap = let
# 	# 	ks = "   ";
# 	# in {
# 	# 	submap_name,
# 	# 	mod_key,
# 	# 	sub_key,
# 	# 	parent_submap,
# 	# 	body,
# 	# }:/*conf*/
# 	# ''
# 	# # ${submap_name} prefix key
# 	# ${"$"}${submap_name}_mode = ${ if parent_submap == "" then "${mod_key}, ${sub_key}" else " , ${sub_key}" } # if main submap or nested submap has mod key
# 	#
# 	# # =========================================================================== #
# 	# #                             starting submap block                           #
# 	# #                            (submap ${submap_name})                          #
# 	# # --------------------------------------------------------------------------- #
# 	# $submap_${submap_name} = ${submap_name}${ks}${ks}${builtins.concatStringsSep ks (builtins.filter (x: x != "") (builtins.concatMap (item:
# 	# 	if builtins.isString item then
# 	# 		[]  # Skip string items for display
# 	# 	else if builtins.isAttrs item then
# 	# 		let
# 	# 			keys = builtins.attrNames item;
# 	# 			keyName = builtins.head keys;
# 	# 		in
# 	# 			[keyName]
# 	# 	else
# 	# 		[]
# 	# ) body))}${ks}│${ if parent_submap == "" then "${ks}(󱊷)Exit" else "${ks}(󱞳)Back${ks}(󱊷)Exit" }
# 	#
# 	# bind = ${"$"}${submap_name}_mode, exec, ${submap_mod_reset_script_path} active # actives here
# 	# bind = ${"$"}${submap_name}_mode, submap, $submap_${submap_name} # set submap by keybind
# 	#
# 	# submap = $submap_${submap_name} # call that submap
# 	#
# 	# ${ if parent_submap != "" then ''
# 	# bind = , backspace, exec, ${submap_mod_reset_script_path} active
# 	# bind = , backspace, submap, $submap_${parent_submap}
# 	# '' else "" }
# 	#
# 	# bind = , escape, exec, ${submap_mod_reset_script_path} exited # exited here
# 	# bind = , escape, submap, reset # for safety, reset submap by escape key
# 	#
# 	# # =========================================================================== #
# 	#
# 	# # tasks here
# 	# # ===========
# 	#
# 	# # NOTE: if repeated bind key then use "binde = "
# 	# # else single then use "bind = "
# 	# #
# 	# # if no mod_key then use it or remove it
# 	# # binde = <mod_key>, <key>, exec, ${submap_mod_reset_script_path} active # you need to place that before your every keybind
# 	# # binde = <mod_key>, <key>, options, opts
# 	# # bind = <mod_key>, <key>, exec, ${submap_mod_reset_script_path} active # you need to place that before your every keybind
# 	# # bind = <mod_key>, <key>, options, opts
# 	# #
# 	# # or execute commands
# 	# # binde = <mod_key>, <key>, exec, ${submap_mod_reset_script_path} active # you need to place that before your every keybind
# 	# # binde = , <key>, exec, commands
# 	# # bind = <mod_key>, <key>, exec, ${submap_mod_reset_script_path} active # you need to place that before your every keybind
# 	# # bind = , <key>, exec, commands
# 	#
# 	# ${builtins.concatStringsSep "\n	" (builtins.concatMap (item:
# 	# 	if builtins.isString item then
# 	# 		[item]
# 	# 	else if builtins.isAttrs item then
# 	# 		let
# 	# 			keys = builtins.attrNames item;
# 	# 			keyName = builtins.head keys;
# 	# 			bindData = builtins.getAttr keyName item;
# 	# 			# Extract mod_key and sub_key from the bind string
# 	# 			# Remove "bind = " prefix and split by comma
# 	# 			cleanBind = builtins.replaceStrings ["bind = "] [""] bindData;
# 	# 			# Simple string splitting approach
# 	# 			firstComma = builtins.substring 0 (builtins.stringLength cleanBind) cleanBind;
# 	# 			parts = builtins.match "([^,]+), *([^,]+), *(.*)" cleanBind;
# 	# 			modKey = if parts != null then builtins.elemAt parts 0 else "";
# 	# 			subKey = if parts != null then builtins.elemAt parts 1 else "";
# 	# 		in
# 	# 			if parts != null then [
# 	# 				"bind = ${modKey}, ${subKey}, exec, ${submap_mod_reset_script_path} active"
# 	# 				bindData
# 	# 			] else [
# 	# 				bindData
# 	# 			]
# 	# 	else
# 	# 		[]
# 	# ) body)}
# 	#
# 	# # if source it, then
# 	# # source = ~/.config/hypr/submaps/.conf
# 	#
# 	# # =========================================================================== #
# 	# #                              ending submap block                            #
# 	# #                            (submap ${submap_name})                          #
# 	# # --------------------------------------------------------------------------- #
# 	#
# 	# ${ if parent_submap != "" then ''
# 	# # NOTE: if you have no upper level submap then remove it,
# 	# # if you are in nested then place one level up submap
# 	# bind = , backspace, exec, ${submap_mod_reset_script_path} active
# 	# bind = , backspace, submap, $submap_${parent_submap}
# 	# '' else "" }
# 	#
# 	# # fix the auto close scripts timing by this scripts, it will cancel the time
# 	# # immediately, so that it will not effect the other submap
# 	# bind = , escape, exec, ${submap_mod_reset_script_path} exited # exited here
# 	# bind = , escape, submap, reset # after tasks, reset submap by escape key
# 	#
# 	# # NOTE: if you are at most upper level submap then use "reset" or if nested then
# 	# # place one level upper submap
# 	# submap = ${ if parent_submap == "" then "reset" else "$submap_${parent_submap}" }
# 	#
# 	# # =========================================================================== #
# 	#
# 	# '';
# 	#
# 	# blur = generate_submap {
# 	# 	submap_name = "Blur";
# 	# 	mod_key = "";
# 	# 	sub_key = "b";
# 	# 	parent_submap = "window";
# 	# 	body = [
# 	# 		{ "blur1" = "bind = SUPER_L, c, movetoworkspace, l"; }
# 	# 		{ "blur2" = "bind = SUPER_L&CTRL_R, x, movewindow, d"; }
# 	# 	];
# 	# };
# 	#
# 	# window = generate_submap {
# 	# 	submap_name = "window";
# 	# 	mod_key = "super";
# 	# 	sub_key = "o";
# 	# 	parent_submap = "";
# 	# 	body = [
# 	# 		{ "hello" = "bind = SUPER_L, o, movetoworkspace, l"; }
# 	# 		{ "world" = "bind = SUPER_L&CTRL_R, w, movewindow, d"; }
# 	# 		{ "bluesr" = blur; }
# 	# 	];
# 	# };
#
# generate_submap = let
# 	ks = "   ";
# in {
# 	submap_name,
# 	mod_key,
# 	sub_key,
# 	parent_submap,
# 	body,
# }:/*conf*/
# ''
# # ${submap_name} prefix key
# ${"$"}${submap_name}_mode = ${mod_key}, ${sub_key} # if main submap or nested submap has mod key
#
# # =========================================================================== #
# #                             starting submap block                           #
# #                            (submap ${submap_name})                          #
# # --------------------------------------------------------------------------- #
# $submap_${submap_name} = ${submap_name}${ks}${ks}${builtins.concatStringsSep ks (builtins.filter (x: x != "") (builtins.concatMap (item:
# 	if builtins.isString item then
# 		[]  # Skip string items for display
# 	else if builtins.isAttrs item then
# 		let
# 			keys = builtins.attrNames item;
# 			keyName = builtins.head keys;
# 		in
# 			[keyName]  # Always show the key name in display
# 	else
# 		[]
# ) body))}${ks}│${ if parent_submap == "" then "${ks}[󱊷]Exit" else "${ks}[󱞳]Back${ks}[󱊷]Exit" }
#
# bind = ${"$"}${submap_name}_mode, exec, ${submap_mod_reset_script_path} active # actives here
# bind = ${"$"}${submap_name}_mode, submap, $submap_${submap_name} # set submap by keybind
#
# submap = $submap_${submap_name} # call that submap
#
# ${ if parent_submap != "" then ''
# bind = , backspace, exec, ${submap_mod_reset_script_path} active
# bind = , backspace, submap, $submap_${parent_submap}
# '' else "" }
#
# bind = , escape, exec, ${submap_mod_reset_script_path} exited # exited here
# bind = , escape, submap, reset # for safety, reset submap by escape key
#
# # =========================================================================== #
#
# # tasks here
# # ===========
# ${builtins.concatStringsSep "\n	" (builtins.concatMap (item:
# 	if builtins.isString item then
# 		[item]
# 	else if builtins.isAttrs item then
# 		let
# 			keys = builtins.attrNames item;
# 			keyName = builtins.head keys;
# 			bindData = builtins.getAttr keyName item;
# 		in
# 			if builtins.isString bindData then
# 				let
# 					# Try to match any bind command pattern: bind* =
# 					bindMatch = builtins.match "(bind[^=]*) *= *(.*)" bindData;
# 				in
# 					if bindMatch != null then
# 						# It's a bind command, extract the bind type and the rest
# 						let
# 							bindType = builtins.elemAt bindMatch 0;  # e.g., "bind", "binde", "bindr", etc.
# 							restOfBind = builtins.elemAt bindMatch 1; # everything after "bind* = "
# 							parts = builtins.match "([^,]*), *([^,]+), *(.*)" restOfBind;
# 							modKey = if parts != null then builtins.elemAt parts 0 else "";
# 							subKey = if parts != null then builtins.elemAt parts 1 else "";
# 						in
# 							if parts != null then [
# 								"${bindType} = ${modKey}, ${subKey}, exec, ${submap_mod_reset_script_path} active"
# 								bindData
# 							] else [
# 								bindData
# 							]
# 					else
# 						# It's a nested submap (full configuration string), include as-is without script
# 						[bindData]
# 			else
# 				[]
# 	else
# 		[]
# ) body)}
#
# # =========================================================================== #
# #                              ending submap block                            #
# #                            (submap ${submap_name})                          #
# # --------------------------------------------------------------------------- #
#
# ${ if parent_submap != "" then ''
# bind = , backspace, exec, ${submap_mod_reset_script_path} active
# bind = , backspace, submap, $submap_${parent_submap}
# '' else "" }
#
# bind = , escape, exec, ${submap_mod_reset_script_path} exited # exited here
# bind = , escape, submap, reset # after tasks, reset submap by escape key
#
# submap = ${ if parent_submap == "" then "reset" else "$submap_${parent_submap}" }
#
# # =========================================================================== #
#
# '';
# }

