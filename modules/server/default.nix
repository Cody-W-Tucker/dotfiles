{ config, pkgs, ... }:

{
  imports = [
    ./media.nix
    ./photos.nix
    ./samba.nix
    # ./nextcloud.nix
  ];

  # Acme for SSL
  security.acme.defaults.email = "cody@tmvsocial.com";
  security.acme.acceptTerms = true;

  networking = {
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 80 443 ];
    };
  };
}
