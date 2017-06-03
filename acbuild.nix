/* this time I do it good. 
http://nixos.org/nix/manual/#ssec-derivation
*/
{ pkgs ? import <nixpkgs> {}}:
with pkgs;
{
  buildImage = {name, app}:
    let
      baseName = baseNameOf name;
      manifest = {
        acKind = "ImageManifest";
        acVersion = "0.8.6";
        labels = [
          # TODO do not hardcode these
          { name = "arch"; value = "amd64"; }
          { name = "os"; value = "linux"; }
        ];
        inherit name;
        inherit app;
      };
      manifestFile = writeText "manifest" (builtins.toJSON manifest);
    in
      runCommand "acbuild" {
        buildInputs = [ acbuild ];
        closure = pkgs.writeReferencesToFile manifestFile;
        name = baseName;
        storeDir = builtins.storeDir;
        inherit manifestFile;
      }
      ''
      mkdir $out
      acbuild --debug begin
      acbuildEnd() {
        export EXIT=$?
        acbuild  --debug end && exit $EXIT
      }
      trap acbuildEnd EXIT

      mkdir -p ".$storeDir"
      for dep in $(cat $closure); do
        cp -r $dep ".$storeDir"
      done
      mkdir etc
      echo "root:x:0:0::/:" > etc/passwd
      echo "root:!x:::::::" > etc/shadow
      echo "root:x:0:" > etc/group
      echo "root:x::" > etc/gshadow

      # fix permissions for acbuild
      chmod -R u+rw .${builtins.storeDir}
      acbuild --debug copy ".$storeDir" "$storeDir"
      acbuild --debug copy etc  /etc
      acbuild --debug replace-manifest $manifestFile
      acbuild --debug write $out/image.aci
      ''
  ;
}
