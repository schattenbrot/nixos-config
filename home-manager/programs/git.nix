{
	programs.git = {
		enable = true;

		userName = "Schattenbrot";
		userEmail = "aaron.machill@gmail.com";

		ignores = [
		  ".vscode"
			"*.sql"
			"*.sql.gz"
			"*.sql.zst"
			".envrc"
			".direnv/"
			".venv/"
			"node_modules"
		];

		extraConfig = {
			init = {
				defaultBranch = "mistress";
			};

			pull = {
				rebase = "true";
			};
		};
	};
}
