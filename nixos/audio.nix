{ pkgs, ... }:

{
	services.pipewire = {
		enable = true;
		pulse.enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		wireplumber.enable = true;
		jack.enable = true;

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

	boot.extraModprobeConfig = ''
    options snd-hda-intel model=auto
	'';
	boot.blacklistedKernelModules = [
  "snd_soc_avs"
  "snd_soc_hda_codec"
  "snd_soc_core"
  "snd_intel_dspcfg" # optional, only if it keeps binding DSP
  "snd_sof_pci"
  "snd_sof_intel_hda_common"
  "snd_sof_intel_bdw"
  "snd_sof_intel_hda"
  "snd_sof"
];
}
