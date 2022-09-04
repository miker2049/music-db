{
  inputs = { flake-utils = { url = "github:numtide/flake-utils"; }; };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        yaafe = (with pkgs;
          stdenv.mkDerivation {
            pname = "yaafe";
            version = "0.70";
            src = fetchgit {
              url = "https://github.com/miker2049/Yaafe";
              rev = "14a9434e506a4f59bbfadda8848fccb47b17b2eb";
              sha256 = "S7V7r/8engu5/on8mH7u5MQAZa5jpLVg1nojCnBjMzA=";
              fetchSubmodules = false;
            };
            buildInputs =
              [ cmake argtable libsndfile fftw eigen argtable python3 ];
            fixupPhase = ''
              substituteInPlace $out/lib/python3.10/site-packages/yaafelib/core.py \
                                 --replace "libyaafe-python.so" "$out/lib/libyaafe-python.so"
            '';
          });
        yaafe-py = (pkgs.python3Packages.buildPythonPackage {
          name = "yaafelib";
          src = "${yaafe}/lib/python3.10/site-packages/";
          preBuild = ''
            cat >setup.py <<'EOF'
            from distutils.core import setup
            setup(
              name='yaafe',
              packages=['yaafelib', 'yaafelib.yaafe_extensions'],
              py_modules=['yaafefeatures'],
            )
            EOF
          '';
        });
        python-supercollider = (pkgs.python3Packages.buildPythonPackage rec {
          pname = "python-supercollider";
          version = "0.0.5";
          propagatedBuildInputs = [pkgs.liblo
                                   pkgs.python310Packages.numpy
                                   pkgs.python310Packages.pytest-runner
                                   pkgs.python310Packages.pytest
                                   pkgs.python310Packages.pyliblo
                                   pkgs.python310Packages.cython
                                  ];
          doCheck = false;
          src = pkgs.fetchFromGitHub {
            owner = "ideoforms";
            repo = "python-supercollider";
            rev = "v${version}";
            sha256 = "mUwZ23sjfppckPUxEurAluDfjAsjapX0QzQ/5v0OCsg="; # TODO
          };
        });
      in rec {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.sqlite
            (pkgs.python310.withPackages (p:
              with p; [
                yaafe-py
                python-supercollider
                ffmpeg-python
                numpy
              ]))
          ];
        };
      });
}
