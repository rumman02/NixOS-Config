-- =============================================================================
-- Global Key Variables
-- =============================================================================
-- Defines all key prefix variables (_G.*_key1, _G.*_key2) used across keymap
-- files and the leader key legend for reference.
-- =============================================================================

-- -- Leader key legend
-- <leader>a - align
-- <leader>b - buffer
-- <leader>c - comment
-- <leader>d - diagnostic
-- <leader>e - explorer
-- <leader>f - find
-- <leader>g - git
-- <leader>h - history
-- <leader>i -
-- <leader>j -
-- <leader>k -
-- <leader>l - lsp
-- <leader>m - multicursor
-- <leader>n - navigation
-- <leader>o -
-- <leader>p -
-- <leader>q -
-- <leader>r -
-- <leader>s - surround
-- <leader>t - terminal
-- <leader>u - undotree
-- <leader>v -
-- <leader>w - window
-- <leader>x -
-- <leader>y -
-- <leader>z - fold
-- <leader>A -
-- <leader>B -
-- <leader>C -
-- <leader>D - dap
-- <leader>E -
-- <leader>F - format
-- <leader>G -
-- <leader>H -
-- <leader>I -
-- <leader>J -
-- <leader>K -
-- <leader>L -
-- <leader>M - marks
-- <leader>N -
-- <leader>O -
-- <leader>P -
-- <leader>Q -
-- <leader>R -
-- <leader>S - scratch
-- <leader>T - tab
-- <leader>U -
-- <leader>V -
-- <leader>W -
-- <leader>X -
-- <leader>Y -
-- <leader>Z - zen
-- <leader><leader> - toggle keys

-- =============================================================================
-- Key prefix definitions (used by other keymap files)
-- =============================================================================

-- Feature-specific key prefixes
_G.align_key1 = "<leader>a"
_G.comment_key1 = "gc"
_G.comment_key2 = "gb"
_G.diagnostic_key1 = "<leader>d"
_G.explorer_key1 = "<leader>e"
_G.find_key1 = "<leader>f"
_G.find_key2 = "<leader>f<leader>"
_G.git_key1 = "<leader>g"
_G.git_key2 = "<leader>g<leader>"
_G.history_key1 = "<leader>h"
_G.lsp_key1 = "<leader>l"
_G.marks_key1 = "<leader>M"
_G.multi_cursor1 = "<leader>m"
_G.multi_cursor2 = "<leader>m<leader>"
_G.navigation_key1 = "s"
_G.navigation_key2 = "ss"
_G.scratch_key1 = "<leader>S"
_G.surround_key1 = "s"
_G.surround_key2 = "ss"
_G.terminal_key1 = "<leader>t"
_G.undotree_key1 = "<leader>u"
_G.fold_key1 = "<leader>z"
_G.dap_key1 = "<leader>D"
_G.format_key1 = "<leader>F"
_G.zen_key1 = "<leader>Z"
_G.toggle_key1 = "<leader><leader>"

-- Window and buffer keys
_G.window_key1 = "<c-w>"
_G.buffer_key1 = "<c-t>"
_G.buffer_key2 = "<c-t><c-t>"
_G.tab_key1 = "<c-s>"
