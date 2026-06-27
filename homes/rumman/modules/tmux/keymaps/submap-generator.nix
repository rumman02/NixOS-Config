# { ... }: let
# 	ks = "   ";
# in {
#   submap_name,
#   mod_key,
#   sub_key,
#   parent_submap,
#   options,
#   body,
# }:
# # ''
# # bind-key -${if parent_submap != "" then "${options}T" else "${options}"} ${parent_submap} ${if mod_key != "" then "${mod_key}-${sub_key}" else "${sub_key}"} switch-client -T ${submap_name} \; display-message "${submap_name}${ks}${ks}${builtins.concatStringsSep ks (map (item: builtins.head (builtins.attrNames item)) body)}"
# # ${builtins.concatStringsSep "\n" (map (item:
# # ''bind-key -${(builtins.head (builtins.attrValues item)).options}T ${submap_name} ${if (builtins.head (builtins.attrValues item)).mod_key != "" then "${(builtins.head (builtins.attrValues item)).mod_key}-${(builtins.head (builtins.attrValues item)).sub_key}" else "${(builtins.head (builtins.attrValues item)).sub_key}"} ${(builtins.head (builtins.attrValues item)).command}''
# # ) body)}
# # ''
#
#
# let
#   # Check if an item is a submap (string) or a command config (attrset)
#   processBodyItem = item: let
#     key_name = builtins.head (builtins.attrNames item);
#     value = builtins.head (builtins.attrValues item);
#   in
#     if builtins.isString value then
#       # It's a nested submap - just return the submap string
#       value
#     else
#       # It's a command config - generate the bind command
#       ''bind-key -${value.options}T ${submap_name} ${if value.mod_key != "" then "${value.mod_key}-${value.sub_key}" else "${value.sub_key}"} ${value.command}'';
#
#   # Generate the main bind command and all body commands
#   mainBind = ''bind-key -${if parent_submap != "" then "${options}T" else "${options}"} ${parent_submap} ${if mod_key != "" then "${mod_key}-${sub_key}" else "${sub_key}"} switch-client -T ${submap_name} \; display-message "${submap_name}${ks}${ks}${builtins.concatStringsSep ks (map (item: builtins.head (builtins.attrNames item)) body)}"'';
#
#   bodyBinds = builtins.concatStringsSep "\n" (map processBodyItem body);
# in
# ''${mainBind}
# ${bodyBinds}''


# { ... }: let
# 	ks = "   ";
# in {
#   submap_name,
#   mod_key,
#   sub_key,
#   parent_submap,
#   options,
#   body,
#   entry_command ? null,  # Optional command to run when entering submap
# }:
# let
#   # Check if an item is a submap (string) or a command config (attrset)
#   processBodyItem = item: let
#     key_name = builtins.head (builtins.attrNames item);
#     value = builtins.head (builtins.attrValues item);
#   in
#     if builtins.isString value then
#       # It's a nested submap - just return the submap string
#       value
#     else
#       # It's a command config - generate the bind command
#       ''bind-key -${value.options}T ${submap_name} ${if value.mod_key != "" then "${value.mod_key}-${value.sub_key}" else "${value.sub_key}"} ${value.command}'';
#
#   # Generate the main bind command with optional entry_command
#   switchCommand = if entry_command != null
#     then "${entry_command} \\; switch-client -T ${submap_name}"
#     else "switch-client -T ${submap_name}";
#
#   mainBind = ''bind-key -${if parent_submap != "" then "${options}T" else "${options}"} ${parent_submap} ${if mod_key != "" then "${mod_key}-${sub_key}" else "${sub_key}"} ${switchCommand} \; display-message "${submap_name}${ks}${ks}${builtins.concatStringsSep ks (map (item: builtins.head (builtins.attrNames item)) body)}"'';
#
#   bodyBinds = builtins.concatStringsSep "\n" (map processBodyItem body);
# in
# ''${mainBind}
# ${bodyBinds}''



# { ... }: let
# 	ks = "   ";
# in {
#   submap_name,
#   mod_key,
#   sub_key,
#   parent_submap,
#   options,
#   body,
#   entry_command ? null,  # Optional command to run when entering submap
#   target_table ? null,   # Optional table name for body bindings (overrides submap_name)
# }:
# let
#   # Check if an item is a submap (string) or a command config (attrset)
#   processBodyItem = item: let
#     key_name = builtins.head (builtins.attrNames item);
#     value = builtins.head (builtins.attrValues item);
#     # Priority: individual binding's target_table > global target_table > submap_name
#     table_name = if (builtins.isAttrs value) && (value ? target_table) && (value.target_table != "")
#       then value.target_table
#       else if target_table != null
#       then target_table
#       else submap_name;
#   in
#     if builtins.isString value then
#       # It's a nested submap - just return the submap string
#       value
#     else
#       # It's a command config - generate the bind command
#       ''bind-key -${value.options}T ${table_name} ${if value.mod_key != "" then "${value.mod_key}-${value.sub_key}" else "${value.sub_key}"} ${value.command}'';
#
#   # Generate the main bind command with optional entry_command
#   switchCommand = if entry_command != null
#     then "${entry_command} \\; switch-client -T ${submap_name}"
#     else "switch-client -T ${submap_name}";
#
#   mainBind = ''bind-key -${if parent_submap != "" then "${options}T" else "${options}"} ${parent_submap} ${if mod_key != "" then "${mod_key}-${sub_key}" else "${sub_key}"} ${switchCommand} \; display-message "${submap_name}${ks}${ks}${builtins.concatStringsSep ks (map (item: builtins.head (builtins.attrNames item)) body)}"'';
#
#   bodyBinds = builtins.concatStringsSep "\n" (map processBodyItem body);
# in
# ''${mainBind}
# ${bodyBinds}''


{ ... }: let
	ks = "   ";
in {
  submap_name ? null,    # Optional submap name
  mod_key,
  sub_key,
  parent_submap,
  options,
  body,
  entry_command ? null,  # Optional command to run when entering submap
  target_table ? null,   # Optional table name for body bindings (overrides submap_name)
}:
let
  # Check if an item is a submap (string) or a command config (attrset)
  processBodyItem = item: let
    key_name = builtins.head (builtins.attrNames item);
    value = builtins.head (builtins.attrValues item);
    # Priority: individual binding's target_table > global target_table > submap_name
    table_name = if (builtins.isAttrs value) && (value ? target_table) && (value.target_table != "")
      then value.target_table
      else if target_table != null
      then target_table
      else submap_name;
  in
    if builtins.isString value then
      # It's a nested submap - just return the submap string
      value
    else
      # It's a command config - generate the bind command
      ''bind-key -${value.options}T ${table_name} ${if value.mod_key != "" then "${value.mod_key}-${value.sub_key}" else "${value.sub_key}"} ${value.command}'';

  # Generate the main bind command with optional entry_command
  switchCommand = if entry_command != null
    then "${entry_command}"
    else "switch-client -T ${submap_name}";

  mainBind = ''bind-key -${if parent_submap != "" then "${options}T" else "${options}"} ${parent_submap} ${if mod_key != "" then "${mod_key}-${sub_key}" else "${sub_key}"} ${switchCommand} \; display-message "${submap_name}${ks}${ks}${builtins.concatStringsSep ks (map (item: builtins.head (builtins.attrNames item)) body)}"'';

  bodyBinds = builtins.concatStringsSep "\n" (map processBodyItem body);
in
''${mainBind}
${bodyBinds}''

