{
  pkgs,
  lib,
  inputs,
  config,
  myOverlays,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    vencord
    fluffychat
    firefox
    pavucontrol

    # picture editing
    gimp
    qimgv
    darktable

    # document viewing
    foliate # ebook viewer (supports pdf as well)

    alacritty
    alacritty-theme
    swappy # clipboard screenshot editor

    nautilus

	v4l-utils
	ffmpeg
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi # optional AMD hardware acceleration
        obs-gstreamer
        obs-vkcapture
      ];
    })
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
	options v4l2loopback devices=2 video_nr=1,2 card_label="OBS Cam, Virt Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;
}
