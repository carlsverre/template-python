let
    nixpkgs = import <nixpkgs> {};
    pkgs-src = nixpkgs.fetchFromGitHub {
        owner = "nixos";
        repo = "nixpkgs";
        rev = "b69f568f4c3ebaf48a7f66b0f051d28157a61afb";
        sha256 = "0dbbm4a8s5g6cnihqcm28x6riyqcxj461wq556ffvabsp3gxy78n";
    };
    pkgs = import pkgs-src {};

    python27Env = pkgs.python27Full.buildEnv.override {
      extraLibs = with pkgs.python27Packages; [
        # get a nice python environment setup
        setuptools
        ipython
        flake8
        virtualenv
      ];
    };
in
  {
    customEnv = pkgs.stdenv.mkDerivation {
      name = "custom-env";
      buildInputs = with pkgs; [
        stdenv
        python27Env
        libffi
        mysql57
        file
        which
        curl
      ];
      shellHook = ''
        if [[ ! -d venv ]]; then
          virtualenv venv
          source venv/bin/activate
          pip install --no-binary :all: --isolated -Ur requirements.txt
        else
          source venv/bin/activate
        fi
      '';
    };
  }
