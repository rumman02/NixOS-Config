{ config, lib, ... }:let
	color = config.lib.stylix.colors;
in {

	# ===========================================================================
	# LAZYGIT (A SIMPLE TERMINAL UI FOR GIT COMMANDS)
	# ===========================================================================
	programs.lazygit = {
		enable = true;
		settings = {
			# ===========================================================================
			# GUI
			# ===========================================================================
			gui = {
				nerdFontsVersion = "3";
				showFileIcons = true;
				showRandomTip = false;
				border = "rounded";
				theme = {
					activeBorderColor = lib.mkForce [ "#${color.base0E}" "bold" ];
					inactiveBorderColor = lib.mkForce [ "#${color.base0D}" ];
				};
			};

			# ===========================================================================
			# KEYBINDINGS
			# ===========================================================================
			keybinding = {
				# ---------------------------------------------------------------------------
				# UNIVERSAL
				# ---------------------------------------------------------------------------
				universal = {
					quit = "q";
					quit-alt1 = "<c-c>";
					return = "<esc>";
					quitWithoutChangingDirectory = "Q";
					togglePanel = "<tab>";
					prevItem = "<up>";
					nextItem = "<down>";
					prevItem-alt = "k";
					nextItem-alt = "j";
					prevPage = ",";
					nextPage = ".";
					scrollLeft = "H";
					scrollRight = "L";
					gotoTop = "<";
					gotoBottom = ">";
					gotoTop-alt = "<home>";
					gotoBottom-alt = "<end>";
					toggleRangeSelect = "v";
					rangeSelectDown = "<s-down>";
					rangeSelectUp = "<s-up>";
					prevBlock = "<left>";
					nextBlock = "<right>";
					prevBlock-alt = "h";
					nextBlock-alt = "l";
					nextBlock-alt2 = "<tab>";
					prevBlock-alt2 = "<backtab>";
					jumpToBlock = [
						"1"
						"2"
						"3"
						"4"
						"5"
					];
					focusMainView = "0";
					nextMatch = "n";
					prevMatch = "N";
					startSearch = "/";
					optionMenu = "<disabled>";
					optionMenu-alt1 = "?";
					select = "<space>";
					goInto = "<enter>";
					confirm = "<enter>";
					confirmInEditor = "<a-enter>";
					confirmInEditor-alt = "<c-s>";
					remove = "d";
					new = "n";
					edit = "e";
					openFile = "o";
					scrollUpMain = "<pgup>";
					scrollDownMain = "<pgdown>";
					scrollUpMain-alt1 = "K";
					scrollDownMain-alt1 = "J";
					scrollUpMain-alt2 = "<c-u>";
					scrollDownMain-alt2 = "<c-d>";
					executeShellCommand = ":";
					createRebaseOptionsMenu = "m";
					pushFiles = "P";
					pullFiles = "p";
					refresh = "R";
					createPatchOptionsMenu = "<c-p>";
					nextTab = "]";
					prevTab = "[";
					nextScreenMode = "+";
					prevScreenMode = "_";
					undo = "z";
					redo = "<c-z>";
					filteringMenu = "<c-s>";
					diffingMenu = "W";
					diffingMenu-alt = "<c-e>";
					copyToClipboard = "<c-o>";
					openRecentRepos = "<c-r>";
					submitEditorText = "<enter>";
					extrasMenu = "@";
					toggleWhitespaceInDiffView = "<c-w>";
					increaseContextInDiffView = "}";
					decreaseContextInDiffView = "{";
					increaseRenameSimilarityThreshold = ")";
					decreaseRenameSimilarityThreshold = "(";
					openDiffTool = "<c-t>";
				};

				# ---------------------------------------------------------------------------
				# STATUS
				# ---------------------------------------------------------------------------
				status = {
					checkForUpdate = "u";
					recentRepos = "<enter>";
					allBranchesLogGraph = "a";
				};

				# ---------------------------------------------------------------------------
				# FILES
				# ---------------------------------------------------------------------------
				files = {
					commitChanges = "c";
					commitChangesWithoutHook = "w";
					amendLastCommit = "A";
					commitChangesWithEditor = "C";
					findBaseCommitForFixup = "<c-f>";
					confirmDiscard = "x";
					ignoreFile = "i";
					refreshFiles = "r";
					stashAllChanges = "s";
					viewStashOptions = "S";
					toggleStagedAll = "a";
					viewResetOptions = "D";
					fetch = "f";
					toggleTreeView = "`";
					openMergeTool = "M";
					openStatusFilter = "<c-b>";
					copyFileInfoToClipboard = "y";
					collapseAll = "-";
					expandAll = "=";
				};

				# ---------------------------------------------------------------------------
				# BRANCHES
				# ---------------------------------------------------------------------------
				branches = {
					createPullRequest = "o";
					viewPullRequestOptions = "O";
					copyPullRequestURL = "<c-y>";
					checkoutBranchByName = "c";
					forceCheckoutBranch = "F";
					checkoutPreviousBranch = "-";
					rebaseBranch = "r";
					renameBranch = "R";
					mergeIntoCurrentBranch = "M";
					moveCommitsToNewBranch = "N";
					viewGitFlowOptions = "i";
					fastForward = "f";
					createTag = "T";
					pushTag = "P";
					setUpstream = "u";
					fetchRemote = "f";
					sortOrder = "s";
				};

				# ---------------------------------------------------------------------------
				# WORKTREES
				# ---------------------------------------------------------------------------
				worktrees = {
					viewWorktreeOptions = "w";
				};

				# ---------------------------------------------------------------------------
				# COMMITS
				# ---------------------------------------------------------------------------
				commits = {
					squashDown = "s";
					renameCommit = "r";
					renameCommitWithEditor = "R";
					viewResetOptions = "g";
					markCommitAsFixup = "f";
					createFixupCommit = "F";
					squashAboveCommits = "S";
					moveDownCommit = "<c-j>";
					moveUpCommit = "<c-k>";
					amendToCommit = "A";
					resetCommitAuthor = "a";
					pickCommit = "p";
					revertCommit = "t";
					cherryPickCopy = "C";
					pasteCommits = "V";
					markCommitAsBaseForRebase = "B";
					tagCommit = "T";
					checkoutCommit = "<space>";
					resetCherryPick = "<c-R>";
					copyCommitAttributeToClipboard = "y";
					openLogMenu = "<c-l>";
					openInBrowser = "o";
					viewBisectOptions = "b";
					startInteractiveRebase = "i";
					selectCommitsOfCurrentBranch = "*";
				};

				# ---------------------------------------------------------------------------
				# AMEND ATTRIBUTE
				# ---------------------------------------------------------------------------
				amendAttribute = {
					resetAuthor = "a";
					setAuthor = "A";
					addCoAuthor = "c";
				};

				# ---------------------------------------------------------------------------
				# STASH
				# ---------------------------------------------------------------------------
				stash = {
					popStash = "g";
					renameStash = "r";
				};

				# ---------------------------------------------------------------------------
				# COMMIT FILES
				# ---------------------------------------------------------------------------
				commitFiles = {
					checkoutCommitFile = "c";
				};

				# ---------------------------------------------------------------------------
				# MAIN
				# ---------------------------------------------------------------------------
				main = {
					toggleSelectHunk = "a";
					pickBothHunks = "b";
					editSelectHunk = "E";
				};

				# ---------------------------------------------------------------------------
				# SUBMODULES
				# ---------------------------------------------------------------------------
				submodules = {
					init = "i";
					update = "u";
					bulkMenu = "b";
				};

				# ---------------------------------------------------------------------------
				# COMMIT MESSAGE
				# ---------------------------------------------------------------------------
				commitMessage = {
					commitMenu = "<c-o>";
				};
			};
		};
	};
}