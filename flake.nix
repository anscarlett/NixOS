{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
  };

  outputs = { nixpkgs, home-manager, nur, ... }: let
    findUserdataNixFiles = dir: builtins.filter (file: builtins.pathExists file) (builtins.attrValues (builtins.readDir dir));
    users = map (path: { name = builtins.baseNameOf (builtins.dirOf path); path = path; }) (findUserdataNixFiles (./$builtins.toString ./homes));

    generateHomeManagerConfig = user: {
      imports = [ user.path ];
      home-manager = {
        user = user.name;
        home.stateVersion = "24.05";
        programs.zsh = {
          enable = true;
          enableCompletion = true;
          enableSyntaxHighlighting = true;
          ohMyZsh = {
            enable = true;
            customRc = ''
              export ZSH_THEME="robbyrussell"
              plugins=(git)
            '';
          };
        };
      };
    };

    homeConfigurations = builtins.listToAttrs (map (user: {
      name = user.name;
      value = generateHomeManagerConfig user;
    }) users);

  in
  {
    inherit homeConfigurations;
  };
}