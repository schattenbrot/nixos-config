{
	programs.git = {
		enable = true;

		settings = {
			user = {
				name = "Schattenbrot";
				email = "aaron.machill@gmail.com";
			};

			init = {
				defaultBranch = "mistress";
			};

			pull = {
				rebase = "true";
			};
		};

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
	};
}
