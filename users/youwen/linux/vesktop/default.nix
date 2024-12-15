{ pkgs, ... }:
{
  home.packages = [
    pkgs.vesktop
  ];

  systemd.user.services.discord-arrpc = {
    Unit = {
      Description = "Discord RPC server for Vesktop.";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${pkgs.arrpc}/bin/arrpc";
    };
  };
}
