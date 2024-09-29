

{ config, pkgs, ... }:

let
  zshConfig = {
    promptInit = "prompt pure";
    plugins = [ "git" "zsh-syntax-highlighting" "zsh-autosuggestions" ];
    historySize = 10000;
  };
in
{
  home.packages = with pkgs; [
    zsh
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -al";
      grep = "grep --color=auto";
    };
    initExtra = ''
      ${config.zshConfig.promptInit}
      for plugin in ${config.zshConfig.plugins}; do
        source "$plugin"
      done
      HISTSIZE=${config.zshConfig.historySize}
    '';
  };
}