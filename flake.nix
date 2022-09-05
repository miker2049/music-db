{
  inputs = {
    mach-nix.url = "mach-nix/3.5.0";
    flake-utils = { url = "github:numtide/flake-utils"; };
  };
  outputs = { nixpkgs, mach-nix, flake-utils, ... }:
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
          propagatedBuildInputs = [
            pkgs.liblo
            pkgs.python310Packages.numpy
            pkgs.python310Packages.pytest-runner
            pkgs.python310Packages.pytest
            pkgs.python310Packages.pyliblo
            pkgs.python310Packages.cython
          ];
          doCheck = false;
          src = pkgs.fetchFromGitHub {
            owner = "miker2049";
            repo = "python-supercollider";
            rev = "047688f1fb17168ae0510bcb70f4995d13bc71e6";
            sha256 = "zZpBgVoPG0FF3j0S51xHQ/grvFVwZJrSyUl1dYrff1s="; # TODO
          };
        });
        pypika = (pkgs.python3Packages.buildPythonPackage rec {
          pname = "pypika";
          version = "0.48.9";
          propagatedBuildInputs = [ pkgs.python310Packages.parameterized ];
          src = pkgs.fetchFromGitHub {
            owner = "kayak";
            repo = "pypika";
            rev = "30574f997c80851f7e940ad09a63e14a98871dd3";
            sha256 = "9HKT1xRu23F5ptiKhIgIR8srLIcpDzpowBNuYOhqMU0="; # TODO
          };
        });
        py = pkgs.python310.withPackages (p:
          with p; [
            yaafe-py
            python-supercollider
            ffmpeg-python
            numpy
            scipy
            tqdm
            flask
            pypika
          ]);
        runtime = pkgs.stdenv.mkDerivation {
          pname = "music-db-runtime";
          version = "0.0.1";
          buildInputs = [ pkgs.sqlite.dev ];
          src = ./.;
          installPhase = ''
            mkdir -p $out/lib
            cp -r $src/* $out/lib
            gcc -fPIC -shared -o $out/lib/libsqlitefunctions.so $src/extension-functions.c -lm
          '';
        };
      in rec {
        packages.server = pkgs.writeShellScriptBin "server" ''
          ${py}/bin/python ${runtime}/lib/src_py/main.py
        '';
        packages.scrape = pkgs.writeShellScriptBin "scrape" ''
          ${py}/bin/python ${runtime}/lib/src_py/scrapeDirToDB.py $@
        '';
        devShell =
          pkgs.mkShell { buildInputs = [ pkgs.sqlite pkgs.pyright py ]; };
      });
}
