{ config, pkgs, lib, ... }:

{
  ############################################
  ## Memory management tuned for gaming
  ############################################
  zramSwap = {
    enable = true;
    memoryPercent = 50;       # ~8 GB compressed swap in RAM
    algorithm = "zstd";
    priority = 100;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size   = 16384;         # 16 GB swapfile on SSD/NVMe
      priority = 10;
    }
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;     # avoid swap unless absolutely needed
    "vm.vfs_cache_pressure" = 50; # keep game assets cached longer
    "vm.oom_kill_allocating_task" = 1; # faster recovery from OOM
  };

  ############################################
  ## EarlyOOM setup (prevents total freeze)
  ############################################
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 3;       # only trigger when <3% free RAM
    freeSwapThreshold = 1;      # tolerate full swap before killing
    enableNotifications = true; # desktop notification before kill

    # -g: desktop notifications
    # --avoid: try not to kill these (protect games)
    # --prefer: more willing to kill these first (Electron/browsers/etc)
    extraArgs = [
      "-g"
      "--avoid=^(gamescope|steam|proton|wine|lutris|heroic|discord)$"
      "--prefer=^(electron|chrome|chromium|firefox|brave|obs)$"
    ];
  };
}
