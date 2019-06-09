Perl {#sec-language-perl}
====

Nixpkgs provides a function `buildPerlPackage`, a generic package
builder function for any Perl package that has a standard `Makefile.PL`.
It's implemented in
[`pkgs/development/perl-modules/generic`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/perl-modules/generic).

Perl packages from CPAN are defined in
[`pkgs/top-level/perl-packages.nix`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/perl-packages.nix),
rather than `pkgs/all-packages.nix`. Most Perl packages are so
straight-forward to build that they are defined here directly, rather
than having a separate function for each package called from
`perl-packages.nix`. However, more complicated packages should be put in
a separate file, typically in `pkgs/development/perl-modules`. Here is
an example of the former:
```nix
    ClassC3 = buildPerlPackage rec {
      name = "Class-C3-0.21";
      src = fetchurl {
        url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
        sha256 = "1bl8z095y4js66pwxnm7s853pi9czala4sqc743fdlnk27kq94gz";
      };
    };
```
Note the use of `mirror://cpan/`, and the `${name}` in the URL
definition to ensure that the name attribute is consistent with the
source that we're actually downloading. Perl packages are made available
in `all-packages.nix` through the variable `perlPackages`. For instance,
if you have a package that needs `ClassC3`, you would typically write
```nix
    foo = import ../path/to/foo.nix {
      inherit stdenv fetchurl ...;
      inherit (perlPackages) ClassC3;
    };
```
in `all-packages.nix`. You can test building a Perl package as follows:
```sh
    $ nix-build -A perlPackages.ClassC3
```
`buildPerlPackage` adds `perl-` to the start of the name attribute, so
the package above is actually called `perl-Class-C3-0.21`. So to install
it, you can say:
```sh
    $ nix-env -i perl-Class-C3
```
(Of course you can also install using the attribute name: `nix-env -i
  -A perlPackages.ClassC3`.)

So what does `buildPerlPackage` do? It does the following:

1.  In the configure phase, it calls `perl Makefile.PL` to generate a
    Makefile. You can set the variable `makeMakerFlags` to pass flags to
    `Makefile.PL`

2.  It adds the contents of the PERL5LIB environment variable to
    `#! .../bin/perl` line of Perl scripts as `-Idir` flags. This
    ensures that a script can find its dependencies.

3.  In the fixup phase, it writes the propagated build inputs
    (`propagatedBuildInputs`) to the file
    `$out/nix-support/propagated-user-env-packages`. `nix-env`
    recursively installs all packages listed in this file when you
    install a package that has it. This ensures that a Perl package can
    find its dependencies.

`buildPerlPackage` is built on top of `stdenv`, so everything can be
customised in the usual way. For instance, the `BerkeleyDB` module has a
`preConfigure` hook to generate a configuration file used by
`Makefile.PL`:
```nix
    { buildPerlPackage, fetchurl, db }:

    buildPerlPackage rec {
      name = "BerkeleyDB-0.36";

      src = fetchurl {
        url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
        sha256 = "07xf50riarb60l1h6m2dqmql8q5dij619712fsgw7ach04d8g3z1";
      };

      preConfigure = ''
        echo "LIB = ${db.out}/lib" > config.in
        echo "INCLUDE = ${db.dev}/include" >> config.in
      '';
    }
```
Dependencies on other Perl packages can be specified in the
`buildInputs` and `propagatedBuildInputs` attributes. If something is
exclusively a build-time dependency, use `buildInputs`; if it's (also) a
runtime dependency, use `propagatedBuildInputs`. For instance, this
builds a Perl module that has runtime dependencies on a bunch of other
modules:
```nix
    ClassC3Componentised = buildPerlPackage rec {
      name = "Class-C3-Componentised-1.0004";
      src = fetchurl {
        url = "mirror://cpan/authors/id/A/AS/ASH/${name}.tar.gz";
        sha256 = "0xql73jkcdbq4q9m0b0rnca6nrlvf5hyzy8is0crdk65bynvs8q1";
      };
      propagatedBuildInputs = [
        ClassC3 ClassInspector TestException MROCompat
      ];
    };
```
Generation from CPAN {#ssec-generation-from-CPAN}
--------------------

Nix expressions for Perl packages can be generated (almost)
automatically from CPAN. This is done by the program
`nix-generate-from-cpan`, which can be installed as follows:
```sh
    $ nix-env -i nix-generate-from-cpan
```
This program takes a Perl module name, looks it up on CPAN, fetches and
unpacks the corresponding package, and prints a Nix expression on
standard output. For example:
```sh
    $ nix-generate-from-cpan XML::Simple
      XMLSimple = buildPerlPackage rec {
        name = "XML-Simple-2.22";
        src = fetchurl {
          url = "mirror://cpan/authors/id/G/GR/GRANTM/${name}.tar.gz";
          sha256 = "b9450ef22ea9644ae5d6ada086dc4300fa105be050a2030ebd4efd28c198eb49";
        };
        propagatedBuildInputs = [ XMLNamespaceSupport XMLSAX XMLSAXExpat ];
        meta = {
          description = "An API for simple XML files";
          license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
        };
      };
```
The output can be pasted into `pkgs/top-level/perl-packages.nix` or
wherever else you need it.

Cross-compiling modules {#ssec-perl-cross-compilation}
-----------------------

Nixpkgs has experimental support for cross-compiling Perl modules. In
many cases, it will just work out of the box, even for modules with
native extensions. Sometimes, however, the Makefile.PL for a module may
(indirectly) import a native module. In that case, you will need to make
a stub for that module that will satisfy the Makefile.PL and install it
into `lib/perl5/site_perl/cross_perl/${perl.version}`. See the
`postInstall` for `DBI` for an example.
