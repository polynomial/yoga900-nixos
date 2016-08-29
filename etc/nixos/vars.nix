{ pkgs ? import <nixpkgs> {} }:
{
  hostName = "yourhostnamehere";
  timeZone = "UTC"; # or "America/Chicago" or something.
  systemPackages = with pkgs; [ vim cryptsetup acpi ];
  layout = "us"; # set for services.xserver.layout
  username = "yourusername";
}
