{ config, pkgs, ... }:

let
  wallpaper = "/home/ellychan/Pictures/anime_landscape.jpg";

in
{
	services.hyprpaper = {
		enable = true;
		settings = {
			ipc = "off";
			splash = false;

			preload = [
				"${wallpaper}"
			];

			wallpaper = ",${wallpaper}";
		};
	};
}
