{ config, pkgs, ... }:
let
  home = config.home.homeDirectory;
  shared = "/mnt/share";
in
{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      documents = ${shared}/Documents;
      downloads = ${shared}/Downloads;
      music = ${shared}/Music;
      pictures = ${shared}/Pictures;
      videos = ${shared}/Videos;
    };
  };
}
