{ pkgs ? import <nixpkgs> {}, acbuildTool ? import ./../acbuild.nix {}}:
let
  nginxPort = 80;
  webRoot = pkgs.writeTextDir "index.html" ''
  <h1>Hello</h1>
  '';
  nginxConf = pkgs.writeText "nginx.conf" ''
  user root root;
  daemon off;
  events {}
  http {
    access_log /dev/stdout;
    server {
      listen ${toString nginxPort};
      index index.html;
      location / {
        root ${webRoot};
      }
    }
  }
  '';
in
  acbuildTool.buildImage
  {
    name = "example.com/nginx";
    app = {
      user = "root";
      group = "root";
      exec = ["${pkgs.nginx}/bin/nginx" "-c" "${nginxConf}" ];
      ports = [
        {
          name = "http";
          protocol = "tcp";
          port =  nginxPort;
        }
      ];
    };
  }
