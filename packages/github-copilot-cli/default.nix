{
  pkgs ? import <nixpkgs> { },
}:
let
  pname = "copilot";
  version = "0.0.327";
in

pkgs.buildNpmPackage {
  pname = pname;
  version = version;
  name = "${pname}-${version}";

  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/@github/copilot/-/${pname}-${version}.tgz";
    sha256 = "sha256-qe6i5f/eZuRko6VaI/xflNVxDZhO3tOVR4VxZUo+rMQ=";
  };

  dontNpmBuild = true;

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  npmDepsHash = "sha256-d9Vw4+W6GZPEqn2qD1g1DqqqDrKmPAN5wRdNjyhjers=";

  meta = {
    description = "GitHub Copilot CLI";
    homepage = "https://github.com/github-copilot/cli";
    license = pkgs.lib.licenses.mit;
  };
}
