# generated using pypi2nix tool (version: 1.8.1)
# See more at: https://github.com/garbas/pypi2nix
#
# COMMAND:
#   pypi2nix -V 3.6 -e django-rest-swagger
#

{ pkgs ? import <nixpkgs> {}
}:

let

  inherit (pkgs) makeWrapper;
  inherit (pkgs.stdenv.lib) fix' extends inNixShell;

  pythonPackages =
  import "${toString pkgs.path}/pkgs/top-level/python-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv;
    python = pkgs.python36;
    # patching pip so it does not try to remove files when running nix-shell
    overrides =
      self: super: {
        bootstrapped-pip = super.bootstrapped-pip.overrideDerivation (old: {
          patchPhase = old.patchPhase + ''
            sed -i               -e "s|paths_to_remove.remove(auto_confirm)|#paths_to_remove.remove(auto_confirm)|"                -e "s|self.uninstalled = paths_to_remove|#self.uninstalled = paths_to_remove|"                  $out/${pkgs.python35.sitePackages}/pip/req/req_install.py
          '';
        });
      };
  };

  commonBuildInputs = [];
  commonDoCheck = false;

  withPackages = pkgs':
    let
      pkgs = builtins.removeAttrs pkgs' ["__unfix__"];
      interpreter = pythonPackages.buildPythonPackage {
        name = "python36-interpreter";
        buildInputs = [ makeWrapper ] ++ (builtins.attrValues pkgs);
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${pythonPackages.python.interpreter}               $out/bin/${pythonPackages.python.executable}
          for dep in ${builtins.concatStringsSep " "               (builtins.attrValues pkgs)}; do
            if [ -d "$dep/bin" ]; then
              for prog in "$dep/bin/"*; do
                if [ -f $prog ]; then
                  ln -s $prog $out/bin/`basename $prog`
                fi
              done
            fi
          done
          for prog in "$out/bin/"*; do
            wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
          done
          pushd $out/bin
          ln -s ${pythonPackages.python.executable} python
          ln -s ${pythonPackages.python.executable}               python3
          popd
        '';
        passthru.interpreter = pythonPackages.python;
      };
    in {
      __old = pythonPackages;
      inherit interpreter;
      mkDerivation = pythonPackages.buildPythonPackage;
      packages = pkgs;
      overrideDerivation = drv: f:
        pythonPackages.buildPythonPackage (drv.drvAttrs // f drv.drvAttrs //                                            { meta = drv.meta; });
      withPackages = pkgs'':
        withPackages (pkgs // pkgs'');
    };

  python = withPackages {};

  generated = self: {

    "Jinja2" = python.mkDerivation {
      name = "Jinja2-2.10.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/93/ea/d884a06f8c7f9b7afbc8138b762e80479fb17aedbbe2b06515a12de9378d/Jinja2-2.10.1.tar.gz"; sha256 = "065c4f02ebe7f7cf559e49ee5a95fb800a9e4528727aec6f24402a5374c65013"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."MarkupSafe"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://jinja.pocoo.org/";
        license = licenses.bsdOriginal;
        description = "A small but fast and easy to use stand-alone template engine written in pure python.";
      };
    };



    "MarkupSafe" = python.mkDerivation {
      name = "MarkupSafe-1.1.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"; sha256 = "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://palletsprojects.com/p/markupsafe/";
        license = licenses.bsdOriginal;
        description = "Safely add untrusted strings to HTML/XML markup.";
      };
    };



    "certifi" = python.mkDerivation {
      name = "certifi-2019.6.16";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/c5/67/5d0548226bcc34468e23a0333978f0e23d28d0b3f0c71a151aef9c3f7680/certifi-2019.6.16.tar.gz"; sha256 = "945e3ba63a0b9f577b1395204e13c3a231f9bc0223888be653286534e5873695"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://certifi.io/";
        license = licenses.mpl20;
        description = "Python package for providing Mozilla's CA Bundle.";
      };
    };



    "chardet" = python.mkDerivation {
      name = "chardet-3.0.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"; sha256 = "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/chardet/chardet";
        license = licenses.lgpl2;
        description = "Universal encoding detector for Python 2 and 3";
      };
    };



    "coreapi" = python.mkDerivation {
      name = "coreapi-2.3.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ca/f2/5fc0d91a0c40b477b016c0f77d9d419ba25fc47cc11a96c825875ddce5a6/coreapi-2.3.3.tar.gz"; sha256 = "46145fcc1f7017c076a2ef684969b641d18a2991051fddec9458ad3f78ffc1cb"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."coreschema"
      self."itypes"
      self."requests"
      self."uritemplate"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/core-api/python-client";
        license = licenses.bsdOriginal;
        description = "Python client library for Core API.";
      };
    };



    "coreschema" = python.mkDerivation {
      name = "coreschema-0.0.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/93/08/1d105a70104e078718421e6c555b8b293259e7fc92f7e9a04869947f198f/coreschema-0.0.4.tar.gz"; sha256 = "9503506007d482ab0867ba14724b93c18a33b22b6d19fb419ef2d239dd4a1607"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Jinja2"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/core-api/python-coreschema";
        license = licenses.bsdOriginal;
        description = "Core Schema.";
      };
    };



    "django-rest-swagger" = python.mkDerivation {
      name = "django-rest-swagger-2.2.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/89/b3/56348f840201f3760f384d6687cbff440db1df7d4315a007b8d8a37a355a/django-rest-swagger-2.2.0.tar.gz"; sha256 = "48f6aded9937e90ae7cbe9e6c932b9744b8af80cc4e010088b3278c700e0685b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."coreapi"
      self."djangorestframework"
      self."openapi-codec"
      self."simplejson"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/marcgibbons/django-rest-swagger";
        license = licenses.bsdOriginal;
        description = "Swagger UI for Django REST Framework 3.5+";
      };
    };



    "djangorestframework" = python.mkDerivation {
      name = "djangorestframework-3.9.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ce/1d/877af49d161879bc26585696ca0cab6487c4cb7604263cf5f1c745f5141a/djangorestframework-3.9.4.tar.gz"; sha256 = "c12869cfd83c33d579b17b3cb28a2ae7322a53c3ce85580c2a2ebe4e3f56c4fb"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.django-rest-framework.org/";
        license = licenses.bsdOriginal;
        description = "Web APIs for Django, made easy.";
      };
    };



    "idna" = python.mkDerivation {
      name = "idna-2.8";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"; sha256 = "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/kjd/idna";
        license = licenses.bsdOriginal;
        description = "Internationalized Domain Names in Applications (IDNA)";
      };
    };



    "itypes" = python.mkDerivation {
      name = "itypes-1.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/d3/24/5e511590f95582efe64b8ad2f6dadd85c5563c9dcf40171ea5a70adbf5a9/itypes-1.1.0.tar.gz"; sha256 = "c6e77bb9fd68a4bfeb9d958fea421802282451a25bac4913ec94db82a899c073"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/tomchristie/itypes";
        license = licenses.bsdOriginal;
        description = "Simple immutable types for python.";
      };
    };



    "openapi-codec" = python.mkDerivation {
      name = "openapi-codec-1.3.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/78/e5/e0b5aba60c645dde952bc8a9df1f2b0bef27302908839b0a29284c9245d4/openapi-codec-1.3.2.tar.gz"; sha256 = "1bce63289edf53c601ea3683120641407ff6b708803b8954c8a876fe778d2145"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."coreapi"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/core-api/python-openapi-codec/";
        license = licenses.bsdOriginal;
        description = "An OpenAPI codec for Core API.";
      };
    };



    "requests" = python.mkDerivation {
      name = "requests-2.22.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"; sha256 = "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."certifi"
      self."chardet"
      self."idna"
      self."urllib3"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://python-requests.org";
        license = licenses.asl20;
        description = "Python HTTP for Humans.";
      };
    };



    "simplejson" = python.mkDerivation {
      name = "simplejson-3.16.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e3/24/c35fb1c1c315fc0fffe61ea00d3f88e85469004713dab488dee4f35b0aff/simplejson-3.16.0.tar.gz"; sha256 = "b1f329139ba647a9548aa05fb95d046b4a677643070dc2afc05fa2e975d09ca5"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/simplejson/simplejson";
        license = licenses.mit;
        description = "Simple, fast, extensible JSON encoder/decoder for Python";
      };
    };



    "uritemplate" = python.mkDerivation {
      name = "uritemplate-3.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/cd/db/f7b98cdc3f81513fb25d3cbe2501d621882ee81150b745cdd1363278c10a/uritemplate-3.0.0.tar.gz"; sha256 = "c02643cebe23fc8adb5e6becffe201185bf06c40bda5c0b4028a93f1527d011d"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://uritemplate.readthedocs.org";
        license = licenses.bsdOriginal;
        description = "URI templates";
      };
    };



    "urllib3" = python.mkDerivation {
      name = "urllib3-1.25.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/4c/13/2386233f7ee40aa8444b47f7463338f3cbdf00c316627558784e3f542f07/urllib3-1.25.3.tar.gz"; sha256 = "dbe59173209418ae49d485b87d1681aefa36252ee85884c31346debd19463232"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."certifi"
      self."idna"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://urllib3.readthedocs.io/";
        license = licenses.mit;
        description = "HTTP library with thread-safe connection pooling, file post, and more.";
      };
    };

  };
  localOverridesFile = ./requirements_override.nix;
  overrides = import localOverridesFile { inherit pkgs python; };
  commonOverrides = [

  ];
  allOverrides =
    (if (builtins.pathExists localOverridesFile)
     then [overrides] else [] ) ++ commonOverrides;

in python.withPackages
   (fix' (pkgs.lib.fold
            extends
            generated
            allOverrides
         )
   )