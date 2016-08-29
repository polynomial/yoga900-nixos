# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  vars = import ./vars.nix;

in {
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot efi boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = vars.hostName;
  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = vars.timeZone;

  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = vars.systemPackages;

  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  powerManagement.enable = true;

  services.tlp.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = vars.layout;
  services.xserver.videoDrivers = [ "intel" ];

  services.xserver.multitouch.enable = true;
  services.xserver.multitouch.invertScroll = true;
  services.xserver.multitouch.ignorePalm = true;

  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.tapButtons = true;
  services.xserver.synaptics.twoFingerScroll = true;
  services.xserver.synaptics.palmDetect = true;

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers."${vars.username}" = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "audio" "video" "systemd-journal" "systemd-network" ];
  };

  #system.stateVersion = "16.03";
}
