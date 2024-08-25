{
  inputs,
  system,
  ...
}: {
  environment.systemPackages = [
    inputs.personal-neovim.packages.${system}.default
  ];

  security.sudo.enable = false;

  security.doas = {
    enable = true;
    extraRules = [
      {
        users = ["youwen"];
        keepEnv = true;
        persist = true;
      }
    ];
  };
}
