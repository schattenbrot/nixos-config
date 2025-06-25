{ config, pkgs, ... }:

{
	services.mako = {
		enable = true;

		settings = {
			group-by = "app-name";
			default-timeout = "5000";
			font = "Fira Code 15";
			backgroundColor = "#cccccc";
			borderColor = "#aaaaaa";
			borderRadius = 10;
			textColor = "#ffffff";
		};
	};
}
