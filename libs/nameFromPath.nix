{ lib, ... }:

let
  # Function to convert path to variable name
  pathToVarName = path: builtins.replaceStrings ["/"] ["-"] path;

  # Recursive function to find user.nix files and create variables
  findUserNixFiles = path: 
    let
      entries = builtins.attrValues (builtins.readDir path);
      userNixFiles = builtins.filter (entry: builtins.isAttrs entry && entry.name == "user.nix") entries;
      subDirs = builtins.filter (entry: builtins.isAttrs entry && entry.type == "directory") entries;
    in
      builtins.foldl' (acc: dir: acc // findUserNixFiles "${path}/${dir.name}") 
                      (builtins.foldl' (acc: file: acc // { "${pathToVarName "${path}/${file.name}"}" = "${path}/${file.name}"; }) {} userNixFiles) 
                      subDirs;
in
  path: findUserNixFiles path
