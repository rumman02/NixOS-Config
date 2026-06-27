{ username, ... }: let
	fontEN = "TX-02";
	fontENSize = 16;
	fontENMonoSize = 14;
	fontENMinSize = 14;
	fontENFallback = "JetBrainsMono Nerd Font";

	fontBN = "Anek Bangla";
	fontBNSize = 16;
	fontBNMonoSize = 13;
	fontBNMinSize = 0;
	fontBNFallback = "Anek Bangla";

	font = "TX-02";
	fontSize = 16;
	fontMonoSize = 13;
	fontMinSize = 0;
	fontFallback = "JetBrainsMono Nerd Font";

in {

	# ===========================================================================
	# FIREFOX CONFIGURATION
	# ===========================================================================
	programs.firefox = {
		enable = true;

		# ===========================================================================
		# POLICIES
		# ===========================================================================
		policies = {
			# Updates
			AppAutoUpdate = false; # Disable automatic application updates
			BackgroundAppUpdate = false; # Disable background updates

			# Privacy and Telemetry
			DisableTelemetry = true; # Disable sending usage data to Mozilla
			DisableFirefoxStudies = true; # Disable participation in experimental studies
			EnableTrackingProtection = {
				Value = true; # Enable tracking protection
				Locked = true; # Prevent user from changing this setting
				Cryptomining = true; # Block cryptomining scripts
				Fingerprinting = true; # Block fingerprinting techniques
			};

			# Features
			DisablePocket = true; # Disable Firefox Pocket integration
			DisableFirefoxAccounts = true; # Disable Firefox Sync and accounts
			DisableFirefoxScreenshots = true; # Disable the built-in screenshot tool
			TranslateEnabled = false; # Disable the built-in translation feature

			# User Interface
			OverrideFirstRunPage = ""; # Don't show the first-run page
			OverridePostUpdatePage = ""; # Don't show the post-update page
			DontCheckDefaultBrowser = true; # Don't ask to be the default browser
			DisplayBookmarksToolbar = "never"; # "always", "newtab", or "never"
			DisplayMenuBar = "default-off"; # "always", "never", "default-on", or "default-off"
			SearchBar = "unified"; # "separate" or "unified"

			# Downloads and Logins
			StartDownloadsInTempDirectory = true; # Download to a temp directory first
			OfferToSaveLogins = false; # Don't offer to save passwords

			# ===========================================================================
			# EXTENSIONS
			# ===========================================================================
			# To find bigid, in firefox browser "about:support" in this page have add ons section
			# To find shortid, in firefox extension copy the url of install extension, and in that
			# url your can see the some numbers in the middle of the url, that is shortid
			ExtensionSettings = builtins.listToAttrs (map (addon: {
				name = addon.bigId;
				value = {
					install_url = "https://addons.mozilla.org/firefox/downloads/file/${addon.shortId}/latest.xpi";
					installation_mode = if builtins.hasAttr "mode" addon then addon.mode else "normal_installed";
				};
			}) [
					# Ad Blocker
					{ bigId = "uBlock0@raymondhill.net"; shortId = "4492375"; }
					# Dark Mode
					{ bigId = "addon@darkreader.org"; shortId = "4488139"; }
					# Vim-like keybindings
					{ bigId = "vimium-c@gdh1995.cn"; shortId = "4474326"; }
					# Stylus for custom themes
					{ bigId = "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}"; shortId = "4451438"; }
					# Multi-Account Containers
					{ bigId = "@testpilot-containers"; shortId = "4494279"; }
					# catppuccon file browser
					{ bigId = "{bbb880ce-43c9-47ae-b746-c3e0096c5b76}"; shortId = "4561146"; }
					# catppuccon them
					{ bigId = "{76aabc99-c1a8-4c1e-832b-d4f2941d5a7a}"; shortId = "3990325"; }
				]);
		};

		# ===========================================================================
		# USER PROFILE
		# ===========================================================================
		profiles = {
			${username} = {
				id = 0;
				isDefault = true;

				# ===========================================================================
				# PROFILE SETTINGS (ABOUT:CONFIG)
				# ===========================================================================
				settings = {
					# Enable userChrome.css and userContent.css
					"toolkit.legacyUserProfileCustomizations.stylesheets" = true;

					# Vertical Tabs
					"sidebar.verticalTabs" = true;
					"sidebar.visibility" = "expand-on-hover";
					"sidebar.revamp" = true;
					"sidebar.main.tools" = " ";

					# Toolbar Customization
					"identity.fxaccounts.toolbar.enabled" = false;
					"browser.uiCustomization.state" = builtins.toJSON {
						placements = {
							"widget-overflow-fixed-list" = [ "home-button" "bookmarks-menu-button" "history-panelmenu" "panic-button" "privatebrowsing-button" "developer-button" "preferences-button" ];
							"unified-extensions-area" = [ "_testpilot-containers-browser-action" "ublock0_raymondhill_net-browser-action" "addon_darkreader_org-browser-action" "vimium-c_gdh1995_cn-browser-action" "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action" ];
							"nav-bar" = [ "sidebar-button" "back-button" "forward-button" "stop-reload-button" "urlbar-container" "vertical-spacer" "unified-extensions-button" "downloads-button" ];
						};
						currentVersion = 22;
					};

					# Startup and New Tab
					"startup.homepage_welcome_url" = " ";
					"browser.startup.homepage" = "about:home";
					"browser.startup.page" = 1; # 0=blank, 1=home, 3=previous session
					"browser.newtabpage.enabled" = true;
					"browser.newtabpage.activity-stream.feeds.newtabinit" = false;
					"browser.newtabpage.activity-stream.showSearch" = false;
					"browser.newtabpage.activity-stream.feeds.topsites" = false;
					"browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
					"browser.newtabpage.activity-stream.topSitesRows" = 4;

					# Miscellaneous
					"browser.aboutConfig.showWarning" = false;
					"layout.css.prefers-color-scheme.content-override" = 0; # 0=dark, 1=light, 2=system
					"media.eme.enabled" = true; # For DRM content
					"general.autoScroll" = true;

					# Font Settings
					"browser.display.use_document_fonts" = 0; # 0=force custom fonts, 1=allow website fonts
					"font.language.group" = "x-western";

					### latin
					# proportional font type
					"font.default.x-western" = "serif"; # serif or sans-serif

					# # single and default font
					# "font.name.serif.x-western" = fontEN;
					# "font.name.sans-serif.x-western" = fontEN;
					# "font.name.monospace.x-western" = fontEN;
					# "font.name.cursive.x-western" = fontEN;
					#
					# # fallback fonts
					# "font.name-list.serif.x-western" = fontENFallback;
					# "font.name-list.sans-serif.x-western" = fontENFallback;
					# "font.name-list.monospace.x-western" = fontENFallback;
					# "font.name-list.cursive.x-western" = fontENFallback;
					#
					# # font sizes
					# "font.size.variable.x-western" = fontENSize; # default size
					# "font.size.monospace.x-western" = fontENMonoSize; # monospace size
					# "font.minimum-size.x-western" = fontENMinSize; # minimum size
					#
					# ### bengali
					# # proportional font type
					# "font.default.x-beng" = "serif"; # serif or sans-serif
					#
					# # single and default font
					# "font.name.serif.x-beng" = fontBN;
					# "font.name.sans-serif.x-beng" = fontBN;
					# "font.name.monospace.x-beng" = fontBN;
					# "font.name.cursive.x-beng" = fontBN;
					#
					# # fallback fonts
					# "font.name-list.serif.x-beng" = fontBNFallback;
					# "font.name-list.sans-serif.x-beng" = fontBNFallback;
					# "font.name-list.monospace.x-beng" = fontBNFallback;
					# "font.name-list.cursive.x-beng" = fontBNFallback;
					#
					# # font sizes
					# "font.size.variable.x-beng" = fontBNSize; # default size
					# "font.size.monospace.x-beng" = fontBNMonoSize; # monospace size
					# "font.minimum-size.x-beng" = fontBNMinSize; # minimum size
					#
					# ### other writing system (default/fallback)
					# # proportional font type
					# "font.default.x-unicode" = "serif"; # serif or sans-serif
					#
					# # single and default font
					# "font.name.serif.x-unicode" = font;
					# "font.name.sans-serif.x-unicode" = font;
					# "font.name.monospace.x-unicode" = font;
					# "font.name.cursive.x-unicode" = font;
					#
					# # fallback fonts
					# "font.name-list.serif.x-unicode" = fontFallback;
					# "font.name-list.sans-serif.x-unicode" = fontFallback;
					# "font.name-list.monospace.x-unicode" = fontFallback;
					# "font.name-list.cursive.x-unicode" = fontFallback;
					#
					# # font sizes
					# "font.size.variable.x-unicode" = fontSize; # default size
					# "font.size.monospace.x-unicode" = fontMonoSize; # monospace size
					# "font.minimum-size.x-unicode" = fontMinSize; # minimum size
				};

				# ===========================================================================
				# SEARCH ENGINES
				# ===========================================================================
				search = {
					default = "ddg";
					force = true;
					engines = let
						engine = site: url: params: alias: {
							"${site}" = {
								urls = [{ template = url; params = params; }];
								definedAliases = alias;
							};
						};
					in builtins.foldl' (acc: item: acc // item) {} [
							(engine "google" "https://www.google.com/search" [ { name = "q"; value = "{searchTerms}"; } ] ["gg"])
							(engine "Youtube" "https://www.youtube.com/results" [ { name = "search_query"; value = "{searchTerms}"; } ] ["yt"])
							(engine "reddit" "https://www.reddit.com/search" [ { name = "q"; value = "{searchTerms}"; } ] ["rd"])
							(engine "Nix packages" "https://search.nixos.org/packages" [ { name = "from"; value = "0"; } { name = "size"; value = "1000"; } { name = "sort"; value = "relevance"; } { name = "type"; value = "packages"; } { name = "query"; value = "{searchTerms}"; } ] ["np"])
							(engine "Nix options" "https://search.nixos.org/options" [ { name = "from"; value = "0"; } { name = "size"; value = "1000"; } { name = "sort"; value = "relevance"; } { name = "type"; value = "packages"; } { name = "query"; value = "{searchTerms}"; } ] ["no"])
							(engine "Nix home options" "https://home-manager-options.extranix.com/" [ { name = "query"; value = "{searchTerms}"; } ] ["nho"])
						];
				};

				# ===========================================================================
				# BOOKMARKS
				# ===========================================================================
				bookmarks = {
					force = true;
					settings = [
						{ name = "Zero to Nix"; url = "https://zero-to-nix.com/"; }
						{ name = "Nixos and flakes"; url = "https://nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes"; }
						{ name = "Nixos wiki"; url = "https://nixos.wiki/"; }
						{ name = "Nixos packages"; url = "https://search.nixos.org/packages"; }
						{ name = "Nixos options"; url = "https://search.nixos.org/options"; }
						{ name = "Nixos home-manager options"; url = "https://home-manager-options.extranix.com/"; }
						{ name = "Nix manual"; url = "https://nix.dev/manual/nix/2.28/"; }
						{ name = "Nix packages manual"; url = "https://nixos.org/manual/nixpkgs/stable/"; }
						{ name = "Nixos manual"; url = "https://nixos.org/manual/nixos/stable/"; }
						{ name = "MyNixos"; url = "https://mynixos.com/"; }
						{ name = "Home manager manual"; url = "https://home-manager.dev/manual/23.11/options.xhtml"; }
					];
				};
			};
		};
	};

	# ===========================================================================
	# FIREFOX CONTAINER CONFIGURATION
	# ===========================================================================
	home.file.".mozilla/firefox/${username}/containers.json" = let
		# Helper function to generate a container identity
		mkIdentity = id: name: color: icon: {
			public = true;
			userContextId = id;
			inherit color icon name;
		};

		# List of containers to create
		containers = [
			(mkIdentity 6 "Ai" "blue" "fingerprint")
			(mkIdentity 7 "Apple" "blue" "fingerprint")
			(mkIdentity 8 "Bitwarden" "blue" "fingerprint")
			(mkIdentity 9 "Browsers" "blue" "fingerprint")
			(mkIdentity 10 "Clouds" "blue" "fingerprint")
			(mkIdentity 11 "Contact" "blue" "fingerprint")
			(mkIdentity 12 "Cpa" "blue" "fingerprint")
			(mkIdentity 13 "Crypto" "blue" "fingerprint")
			(mkIdentity 14 "Dev" "blue" "fingerprint")
			(mkIdentity 15 "Email" "blue" "fingerprint")
			(mkIdentity 16 "Forums" "blue" "fingerprint")
			(mkIdentity 17 "Freelance" "blue" "fingerprint")
			(mkIdentity 18 "Gaming" "blue" "fingerprint")
			(mkIdentity 19 "Graphics" "blue" "fingerprint")
			(mkIdentity 20 "Hacks" "blue" "fingerprint")
			(mkIdentity 21 "Info" "blue" "fingerprint")
			(mkIdentity 22 "LinkedIn" "blue" "fingerprint")
			(mkIdentity 23 "Main" "blue" "fingerprint")
			(mkIdentity 24 "Microsoft" "blue" "fingerprint")
			(mkIdentity 25 "Minecraft" "blue" "fingerprint")
			(mkIdentity 26 "Online courses" "blue" "fingerprint")
			(mkIdentity 27 "Online stores" "blue" "fingerprint")
			(mkIdentity 28 "Others" "blue" "fingerprint")
			(mkIdentity 29 "Paypal" "blue" "fingerprint")
			(mkIdentity 30 "Personal" "blue" "fingerprint")
			(mkIdentity 31 "Productives" "blue" "fingerprint")
			(mkIdentity 32 "Professional" "blue" "fingerprint")
			(mkIdentity 33 "Programmer" "blue" "fingerprint")
			(mkIdentity 34 "Programs" "blue" "fingerprint")
			(mkIdentity 35 "Social Points" "blue" "fingerprint")
			(mkIdentity 36 "Socials" "blue" "fingerprint")
			(mkIdentity 37 "Test" "blue" "fingerprint")
			(mkIdentity 38 "Torrents" "blue" "fingerprint")
			(mkIdentity 39 "Virtual Services" "blue" "fingerprint")
			(mkIdentity 40 "Works" "blue" "fingerprint")
		];

		# Base identities required by Firefox
		baseIdentities = [
			{ accessKey = ""; color = ""; icon = ""; name = "userContextIdInternal.thumbnail"; public = false; userContextId = 5; }
			{ accessKey = ""; color = ""; icon = ""; name = "userContextIdInternal.webextStorageLocal"; public = false; userContextId = 4294967295; }
		];
	in {
		text = builtins.toJSON {
			version = 5;
			lastUserContextId = 40; # Update this to the last ID used in the containers list
			identities = baseIdentities ++ containers;
		};
	};
}

