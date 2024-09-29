{
  imports = [ ./path/to/your/default.nix ];

  zshConfig = {
    promptInit = "prompt spaceship";
    plugins = [ "zsh-completions" ];
    historySize = 5000;
  };
}
