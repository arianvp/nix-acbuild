
{ pkgs ? import <nixpkgs> {}, acbuildTool ? import ./../acbuild.nix {}}:
acbuildTool.buildImage
{
  name = "arianvp.me/nix";
  app = {
    user = "root";
    group = "root";
    content = pkgs.nix;
    exec = ["${pkgs.nginx}/bin/nix"];
  };
}
