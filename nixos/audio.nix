{ pkgs, ... }:

{
	services.pipewire = {
		enable = true;
		pulse.enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		wireplumber.enable = true;
		jack.enable = true;

		# extraConfig.pipewire."pipewire.conf".context.properties = {
		# 	"default.clock.rate" = 48000;
		# 	"default.clock.quantum" = 1024;
		# 	"default.clock.min-quantum" = 1024;
		# 	"default.clock.max-quantum" = 1024;
		# };

		# drop-in file “/etc/pipewire/pipewire.conf.d/30-rtkit.conf”
		extraConfig.pipewire."30-rtkit.conf" = {
			# this corresponds to the `context.modules` list in pipewire.conf
			"context.modules" = [
				{
					name = "libpipewire-module-rt";
					args = {
						nice.level = -11;
						rt.prio = 88;
						rlimits.enabled = false;
						rtportal.enabled = false;
						rtkit.enabled = true;
					};
				}
			];
		};
	};

	# Enable RTKit
	security.rtkit.enable = true;
}
