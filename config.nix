rec {
	scrollback = 100000;
	historySize = scrollback;
	historyFileSize = scrollback + (scrollback * 20 / 100); # 20% more
	withUWSM = true;
}

