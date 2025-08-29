{
  nixpkgs,
  self,
  inputs,
  functorOS,
}:
rec {
  # a thin wrapper around nixosSystem
  system.instantiate =
    {
      hostname,
      users,
      configuration,
    }:
    nixpkgs.lib.nixosSystem {
      specialArgs = { inherit self inputs; };
      modules = [
        functorOS.nixosModules.functorOS
        configuration
        {
          networking.hostName = hostname;
        }
      ]
      ++ users;
    };
  # a single place to configure all user options for a given user
  user.instantiate =
    {
      username,
      homeDirectory,
      configuration,
      fullName,
      email,
      superuser ? true,
      configureGitUser ? true,
      initialHashedPassword ? null,
      extraGroups ? [ ],
      _extraConfig ? { },
    }:
    { pkgs, config, ... }:
    {
      config = {
        users.users.${username} = {
          shell = nixpkgs.lib.mkOverride 999 pkgs.nushell;
          isNormalUser = true;
          description = fullName;
          extraGroups =
            nixpkgs.lib.optionals superuser [
              "wheel"
            ]
            ++ nixpkgs.lib.optionals config.networking.networkmanager.enable [ "networkmanager" ]
            ++ extraGroups;
          initialHashedPassword = nixpkgs.lib.mkIf (initialHashedPassword != null) initialHashedPassword;
        };

        functorOS._users = [ { inherit username superuser; } ];

        home-manager.extraSpecialArgs = { inherit self inputs; };
        home-manager.users.${username} = {
          imports = [
            functorOS.homeManagerModules.functorOS
            configuration
            _extraConfig
          ];
          home = {
            inherit username homeDirectory;
          };
          programs.git = nixpkgs.lib.mkIf configureGitUser {
            userName = fullName;
            userEmail = email;
          };
        };
      };
    };
  # same as user.instantiate, but return a function that accepts additional user configuration instead
  user.instantiate' =
    { ... }@args: extraConfig: user.instantiate (args // { _extraConfig = extraConfig; });
}
