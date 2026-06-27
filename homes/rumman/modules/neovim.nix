# ============================================================================
# NIXCATS NEOVIM CONFIGURATION
# This config is designed for use with lazy.nvim plugin manager
# ============================================================================
{ inputs, lib, pkgs, config, ... }:

let
	# ============================================================================
	# IMPORTS & UTILITIES
	# ============================================================================
	inixCats = inputs.nixCats;
	utils = inixCats.utils;
	color = config.lib.stylix.colors; # Stylix color scheme integration
in
	{
	# ============================================================================
	# MODULE IMPORTS
	# ============================================================================
	imports = [
		inixCats.homeModule
	];

	config = {
		# Disable default neovim to use NixCats instead
		programs.neovim.enable = lib.mkDefault false;

		# ============================================================================
		# ADDITIONAL PACKAGES
		# ============================================================================
		home.packages = with pkgs; [
			imagemagick # Required for image preview capabilities in Neovim
		];

		# ============================================================================
		# NIXCATS CONFIGURATION
		# nixCats is the defaultPackageName passed to mkNixosModules
		# ============================================================================
		nixCats = {
			enable = true;
			# nixpkgs_version = inputs.nixpkgs; # Optional: Pin nixpkgs version

			# ========================================================================
			# OVERLAYS
			# Add overlays for custom plugins and packages
			# ========================================================================
			addOverlays =
				# (import ./overlays inputs) ++ # Custom overlays (commented)
				[
					(utils.standardPluginOverlay inputs) # Standard plugin overlay
				];

			# ========================================================================
			# PACKAGE SELECTION
			# Specify which package definitions to install
			# ========================================================================
			packageNames = [ "nvim" ];

			# ========================================================================
			# LUA CONFIGURATION PATH
			# Path to your Neovim Lua configuration files
			# ========================================================================
			luaPath = ../configs/nvim;

			# ========================================================================
			# CATEGORY DEFINITIONS
			# Define categories of plugins, LSPs, and runtime dependencies
			# ========================================================================
			categoryDefinitions.replace = (
				{ pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef:
				{
					# ====================================================================
					# LSPs AND RUNTIME DEPENDENCIES
					# Dependencies available at runtime in Neovim's PATH
					# ====================================================================
					lspsAndRuntimeDeps = {
						js = with pkgs; [
							typescript-language-server # TypeScript/JavaScript LSP
							prettierd                  # Fast Prettier daemon
						];
						lua = with pkgs; [
							lua-language-server # Lua LSP
							stylua             # Lua formatter
						];
						nix = with pkgs; [
							nil              # Nix LSP
							nixfmt-rfc-style # Nix formatter
						];
						rust = with pkgs; [
							rust-analyzer # Rust LSP
							rustfmt      # Rust formatter
						];
					};

					# ====================================================================
					# STARTUP PLUGINS
					# Plugins that are loaded immediately when Neovim starts
					# ====================================================================
					startupPlugins = {

						# ==================================================================
						# CORE DEPENDENCIES
						# ==================================================================
						lazy-nvim = [ pkgs.vimPlugins.lazy-nvim ];     # Plugin manager
						plenary-nvim = [ pkgs.vimPlugins.plenary-nvim ]; # Utility functions
						nui-nvim = [ pkgs.vimPlugins.nui-nvim ];       # UI components

						# ==================================================================
						# COLORSCHEME
						# ==================================================================
						catppuccin-nvim = [ pkgs.vimPlugins.catppuccin-nvim ]; # Catppuccin theme

						# ==================================================================
						# ICONS & VISUAL ENHANCEMENTS
						# ==================================================================
						lspkind-nvim = [ pkgs.vimPlugins.lspkind-nvim ];       # LSP kind icons
						nvim-web-devicons = [ pkgs.vimPlugins.nvim-web-devicons ]; # File icons

						# ==================================================================
						# USER INTERFACE
						# ==================================================================
						lualine-nvim = [ pkgs.vimPlugins.lualine-nvim ];         # Status line
						bufferline-nvim = [ pkgs.vimPlugins.bufferline-nvim ];   # Buffer tabs
						scope-nvim = [ pkgs.vimPlugins.scope-nvim ];            # Bufferline dependency
						noice-nvim = [ pkgs.vimPlugins.noice-nvim ];            # Enhanced UI messages
						nvim-highlight-colors = [ pkgs.vimPlugins.nvim-highlight-colors ]; # Color highlighting

						# ==================================================================
						# QUALITY OF LIFE
						# ==================================================================
						snacks-nvim = [ pkgs.vimPlugins.snacks-nvim ];           # Collection of useful plugins
						persistence-nvim = [ pkgs.vimPlugins.persistence-nvim ]; # Session persistence (snacks dependency)
						mini-nvim = [ pkgs.vimPlugins.mini-nvim ];               # Mini plugin collection

						# Alternative mini-files plugin (commented)
						# mini-files = [ pkgs.neovimPlugins.mini-files ]; # Assuming it's in vimPlugins, not neovimPlugins

						# ==================================================================
						# TEXT EDITING ENHANCEMENTS
						# ==================================================================
						comment-nvim = [ pkgs.vimPlugins.comment-nvim ];                     # Smart commenting
						todo-comments-nvim = [ pkgs.vimPlugins.todo-comments-nvim ];         # TODO highlighting
						nvim-ufo = [ pkgs.vimPlugins.nvim-ufo ];                            # Advanced folding
						promise-async = [ pkgs.vimPlugins.promise-async ];                   # UFO dependency
						nvim-ts-context-commentstring = [ pkgs.vimPlugins.nvim-ts-context-commentstring ]; # Context-aware commenting

						# ==================================================================
						# NAVIGATION & MOVEMENT
						# ==================================================================
						hop-nvim = [ pkgs.vimPlugins.hop-nvim ];       # Quick jump navigation
						nvim-spider = [ pkgs.vimPlugins.nvim-spider ]; # Enhanced word motions
						flash-nvim = [ pkgs.vimPlugins.flash-nvim ];   # Alternative navigation (enabled)

						# ==================================================================
						# LANGUAGE SUPPORT
						# ==================================================================
						nvim-treesitter = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ]; # Syntax highlighting
						conform-nvim = [ pkgs.vimPlugins.conform-nvim ];                       # Code formatting

						# ==================================================================
						# COMPLETION SYSTEM
						# ==================================================================
						blink-cmp = [ pkgs.vimPlugins.blink-cmp ];           # Completion engine
						friendly-snippets = [ pkgs.vimPlugins.friendly-snippets ]; # Snippet collection

						# ==================================================================
						# GIT INTEGRATION
						# ==================================================================
						gitsigns-nvim = [ pkgs.vimPlugins.gitsigns-nvim ]; # Git status in gutter

						# ==================================================================
						# DEBUGGING
						# ==================================================================
						nvim-dap = [ pkgs.vimPlugins.nvim-dap ];                     # Debug Adapter Protocol
						nvim-dap-ui = [ pkgs.vimPlugins.nvim-dap-ui ];               # DAP user interface
						nvim-dap-virtual-text = [ pkgs.vimPlugins.nvim-dap-virtual-text ]; # Virtual text for debugging

						# ==================================================================
						# KEYBINDING & HELP
						# ==================================================================
						which-key-nvim = [ pkgs.vimPlugins.which-key-nvim ]; # Keybinding hints
						hydra-nvim = [ pkgs.vimPlugins.hydra-nvim ];         # Modal keymaps

						# ==================================================================
						# NOTE TAKING & MARKDOWN
						# ==================================================================
						obsidian-nvim = [ pkgs.vimPlugins.obsidian-nvim ];           # Obsidian integration
						render-markdown-nvim = [ pkgs.vimPlugins.render-markdown-nvim ]; # Markdown rendering
						markdown-preview-nvim = [ pkgs.vimPlugins.markdown-preview-nvim ]; # Live markdown preview

						# ==================================================================
						# SPECIALIZED TOOLS
						# ==================================================================
						leetcode-nvim = [ pkgs.vimPlugins.leetcode-nvim ]; # LeetCode integration

						# ==================================================================
						# GENERAL UTILITIES
						# ==================================================================
						undotree = [ pkgs.vimPlugins.undotree ];                         # Undo tree visualization
						neotree = [ pkgs.vimPlugins.neo-tree-nvim ];                     # File explorer
						nvim-autopairs = [ pkgs.vimPlugins.nvim-autopairs ];             # Auto-close pairs
						ultimate-autopair-nvim = [ pkgs.vimPlugins.ultimate-autopair-nvim ]; # Advanced auto-pairing
						nvim-window-picker = [ pkgs.vimPlugins.nvim-window-picker ];     # Window selection
						vim-visual-multi = [ pkgs.vimPlugins.vim-visual-multi ];         # Multiple cursors
						lazygit-nvim = [ pkgs.vimPlugins.lazygit-nvim ];                 # Lazygit integration
						nvim-surround = [ pkgs.vimPlugins.nvim-surround ];               # Surround text objects
						smart-splits-nvim = [ pkgs.vimPlugins.smart-splits-nvim ];       # Smart window splits
						fzf-lua = [ pkgs.vimPlugins.fzf-lua ];                          # Fuzzy finder
					};

					# ====================================================================
					# SHARED LIBRARIES (commented out)
					# Libraries to be added to LD_LIBRARY_PATH for runtime access
					# ====================================================================
					# sharedLibraries = {
					#   general = with pkgs; [ ];
					# };

					# ====================================================================
					# ENVIRONMENT VARIABLES (commented out)
					# Variables available at runtime in Neovim terminal
					# ====================================================================
					# environmentVariables = {
					#   test = {
					#     CATTESTVAR = "It worked!";
					#   };
					# };

					# ====================================================================
					# PYTHON LIBRARIES (commented out)
					# Python libraries for plugins that need them
					# ====================================================================
					# python3.libraries = {
					#   test = [ (_:[]) ];
					# };

					# ====================================================================
					# EXTRA WRAPPER ARGS (commented out)
					# Custom wrapper arguments for the Neovim executable
					# Refer to: https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
					# ====================================================================
					# extraWrapperArgs = {
					#   test = [
					#     '' --set CATTESTVAR2 "It worked again!"''
					#   ];
					# };
				}
			);

			# ========================================================================
			# PACKAGE DEFINITIONS
			# Define the actual packages to build
			# ========================================================================
			packageDefinitions.replace = {
				# ======================================================================
				# NVIM PACKAGE DEFINITION
				# Main Neovim configuration package
				# ======================================================================
				nvim = { pkgs, name, ... }: {

					# ====================================================================
					# PACKAGE SETTINGS
					# Configuration for how the package is built and wrapped
					# ====================================================================
					settings = {
						suffix-path = true;    # Add tools to PATH
						suffix-LD = true;      # Add libraries to LD_LIBRARY_PATH
						wrapRc = true;         # Wrap with runtime configuration
						configCfgPath = "nvim"; # Config directory name
						# unwrappedCfgPath = home/rumman/..; # Alternative config path (commented)

						# Aliases for the Neovim executable
						# IMPORTANT: aliases must not conflict with other packages
						aliases = [ "vim" "vi" ];

						# Use nightly Neovim build
						# neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;

						# Language host support (commented)
						# hosts.python3.enable = true;
						# hosts.node.enable = true;
					};

					# ====================================================================
					# ENABLED CATEGORIES
					# Specify which plugin categories to include in this package
					# ====================================================================
					categories = {
						# ==================================================================
						# LANGUAGE SUPPORT
						# ==================================================================
						js = true;    # JavaScript/TypeScript
						lua = true;   # Lua
						nix = true;   # Nix
						rust = true;  # Rust

						# ==================================================================
						# CORE PLUGINS
						# ==================================================================
						lazy-nvim = true;    # Plugin manager
						plenary-nvim = true; # Utility library
						nui-nvim = true;     # UI components

						# ==================================================================
						# VISUAL & ICONS
						# ==================================================================
						nvim-web-devicons = true; # File icons
						lspkind-nvim = true;      # LSP kind icons

						# ==================================================================
						# THEME
						# ==================================================================
						catppuccin-nvim = true; # Catppuccin colorscheme

						# ==================================================================
						# USER INTERFACE
						# ==================================================================
						lualine-nvim = true;           # Status line
						bufferline-nvim = true;        # Buffer tabs
						scope-nvim = true;             # Buffer scoping
						noice-nvim = true;             # Enhanced messages
						nvim-highlight-colors = true;  # Color highlighting

						# ==================================================================
						# QUALITY OF LIFE
						# ==================================================================
						snacks-nvim = true;      # Utility collection
						persistence-nvim = true; # Session persistence
						mini-nvim = true;        # Mini plugin collection

						# Alternative mini-files (commented)
						# mini-files = true;

						# ==================================================================
						# TEXT EDITING
						# ==================================================================
						comment-nvim = true;                     # Smart commenting
						todo-comments-nvim = true;               # TODO highlighting
						nvim-ufo = true;                        # Advanced folding
						promise-async = true;                    # UFO dependency
						nvim-ts-context-commentstring = true;   # Context-aware commenting

						# ==================================================================
						# NAVIGATION
						# ==================================================================
						hop-nvim = true;      # Quick jumps
						flash-nvim = true;    # Alternative navigation
						nvim-spider = true;   # Enhanced word motions

						# ==================================================================
						# LANGUAGE FEATURES
						# ==================================================================
						nvim-treesitter = true; # Syntax highlighting
						conform-nvim = true;    # Code formatting

						# ==================================================================
						# COMPLETION
						# ==================================================================
						blink-cmp = true;           # Completion engine
						friendly-snippets = true;   # Snippet collection

						# ==================================================================
						# GIT INTEGRATION
						# ==================================================================
						gitsigns-nvim = true; # Git status indicators

						# ==================================================================
						# DEBUGGING
						# ==================================================================
						nvim-dap = true;              # Debug Adapter Protocol
						nvim-dap-ui = true;           # DAP UI
						nvim-dap-virtual-text = true; # DAP virtual text

						# ==================================================================
						# KEYBINDINGS & HELP
						# ==================================================================
						which-key-nvim = true; # Keybinding hints
						hydra-nvim = true;     # Modal keymaps

						# ==================================================================
						# NOTES & MARKDOWN
						# ==================================================================
						obsidian-nvim = true;           # Obsidian integration
						render-markdown-nvim = true;    # Markdown rendering
						markdown-preview-nvim = true;   # Live preview

						# ==================================================================
						# SPECIALIZED TOOLS
						# ==================================================================
						leetcode-nvim = true; # LeetCode integration

						# ==================================================================
						# GENERAL UTILITIES
						# ==================================================================
						undotree = true;               # Undo tree
						neotree = true;                # File explorer
						nvim-autopairs = true;         # Auto-close pairs
						ultimate-autopair-nvim = true; # Advanced auto-pairing
						nvim-window-picker = true;     # Window picker
						vim-visual-multi = true;       # Multiple cursors
						lazygit-nvim = true;           # Lazygit integration
						nvim-surround = true;          # Surround operations
						smart-splits-nvim = true;      # Smart window splits
						fzf-lua = true;                # Fuzzy finder
					};

					# ====================================================================
					# EXTRA DATA
					# Additional data to pass to Lua configuration via `nixCats.extra`
					# ====================================================================
					extra = {
						# Nix expressions available in Lua
						nixdExtras.nixpkgs = ''import ${pkgs.path} {}'';

						# Default colorscheme
						colorscheme = "catppuccin-mocha";

						# Stylix color integration - makes system colors available in Neovim
						stylix_color = {
							base00 = "#${color.base00}"; # Background
							base01 = "#${color.base01}"; # Lighter background
							base02 = "#${color.base02}"; # Selection background
							base03 = "#${color.base03}"; # Comments, invisibles
							base04 = "#${color.base04}"; # Dark foreground
							base05 = "#${color.base05}"; # Default foreground
							base06 = "#${color.base06}"; # Light foreground
							base07 = "#${color.base07}"; # Lightest foreground
							base08 = "#${color.base08}"; # Red
							base09 = "#${color.base09}"; # Orange
							base0A = "#${color.base0A}"; # Yellow
							base0B = "#${color.base0B}"; # Green
							base0C = "#${color.base0C}"; # Cyan
							base0D = "#${color.base0D}"; # Blue
							base0E = "#${color.base0E}"; # Purple
							base0F = "#${color.base0F}"; # Brown
						};
					};
				};

				# ======================================================================
				# DEFAULT PACKAGE NAME
				# The package to build when no specific package is requested
				# ======================================================================
				defaultPackageName = "nvim";
			};
		};
	};
}

