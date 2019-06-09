BEAM Languages (Erlang, Elixir & LFE) {#sec-beam}
=====================================

Introduction {#beam-introduction}
------------

In this document and related Nix expressions, we use the term, *BEAM*,
to describe the environment. BEAM is the name of the Erlang Virtual
Machine and, as far as we\'re concerned, from a packaging perspective,
all languages that run on the BEAM are interchangeable. That which
varies, like the build system, is transparent to users of any given BEAM
package, so we make no distinction.

Structure {#beam-structure}
---------

All BEAM-related expressions are available via the top-level `beam`
attribute, which includes:

-   `interpreters`: a set of compilers running on the BEAM, including
    multiple Erlang/OTP versions (`beam.interpreters.erlangR19`, etc),
    Elixir (`beam.interpreters.elixir`) and LFE
    (`beam.interpreters.lfe`).

-   `packages`: a set of package sets, each compiled with a specific
    Erlang/OTP version, e.g. `beam.packages.erlangR19`.

The default Erlang compiler, defined by `beam.interpreters.erlang`, is
aliased as `erlang`. The default BEAM package set is defined by
`beam.packages.erlang` and aliased at the top level as `beamPackages`.

To create a package set built with a custom Erlang version, use the
lambda, `beam.packagesWith`, which accepts an Erlang/OTP derivation and
produces a package set similar to `beam.packages.erlang`.

Many Erlang/OTP distributions available in `beam.interpreters` have
versions with ODBC and/or Java enabled. For example, there\'s
`beam.interpreters.erlangR19_odbc_javac`, which corresponds to
`beam.interpreters.erlangR19`.

We also provide the lambda, `beam.packages.erlang.callPackage`, which
simplifies writing BEAM package definitions by injecting all packages
from `beam.packages.erlang` into the top-level context.

Build Tools
-----------

### Rebar3 {#build-tools-rebar3}

By default, Rebar3 wants to manage its own dependencies. This is
perfectly acceptable in the normal, non-Nix setup, but in the Nix world,
it is not. To rectify this, we provide two versions of Rebar3:

-   `rebar3`: patched to remove the ability to download anything. When
    not running it via `nix-shell` or `nix-build`, it\'s probably not
    going to work as desired.

-   `rebar3-open`: the normal, unmodified Rebar3. It should work exactly
    as would any other version of Rebar3. Any Erlang package should rely
    on `rebar3` instead. See [Rebar3 Packages](#rebar3-packages).

### Mix & Erlang.mk {#build-tools-other}

Both Mix and Erlang.mk work exactly as expected. There is a bootstrap
process that needs to be run for both, however, which is supported by
the `buildMix` and `buildErlangMk` derivations, respectively.

How to Install BEAM Packages
----------------------------

BEAM packages are not registered at the top level, simply because they
are not relevant to the vast majority of Nix users. They are installable
using the `beam.packages.erlang` attribute set (aliased as
`beamPackages`), which points to packages built by the default
Erlang/OTP version in Nixpkgs, as defined by `beam.interpreters.erlang`.
To list the available packages in `beamPackages`, use the following
command:
```sh
    $ nix-env -f "<nixpkgs>" -qaP -A beamPackages
    beamPackages.esqlite    esqlite-0.2.1
    beamPackages.goldrush   goldrush-0.1.7
    beamPackages.ibrowse    ibrowse-4.2.2
    beamPackages.jiffy      jiffy-0.14.5
    beamPackages.lager      lager-3.0.2
    beamPackages.meck       meck-0.8.3
    beamPackages.rebar3-pc  pc-1.1.0
```

To install any of those packages into your profile, refer to them by
their attribute path (first column):
```sh
    $ nix-env -f "<nixpkgs>" -iA beamPackages.ibrowse
```

The attribute path of any BEAM package corresponds to the name of that
particular package in [Hex](https://hex.pm) or its OTP
Application/Release name.

Packaging BEAM Applications
---------------------------

### Erlang Applications {#packaging-erlang-applications}

#### Rebar3 Packages

The Nix function, `buildRebar3`, defined in
`beam.packages.erlang.buildRebar3` and aliased at the top level, can be
used to build a derivation that understands how to build a Rebar3
project. For example, we can build
[hex2nix](https://github.com/erlang-nix/hex2nix) as follows:
```nix
            { stdenv, fetchFromGitHub, buildRebar3, ibrowse, jsx, erlware_commons }:

            buildRebar3 rec {
              name = "hex2nix";
              version = "0.0.1";

              src = fetchFromGitHub {
                owner = "ericbmerritt";
                repo = "hex2nix";
                rev = "${version}";
                sha256 = "1w7xjidz1l5yjmhlplfx7kphmnpvqm67w99hd2m7kdixwdxq0zqg";
              };

              beamDeps = [ ibrowse jsx erlware_commons ];
            }
```

Such derivations are callable with `beam.packages.erlang.callPackage`
(see [para\_title](#erlang-call-package)). To call this package using
the normal `callPackage`, refer to dependency packages via
`beamPackages`, e.g. `beamPackages.ibrowse`.

Notably, `buildRebar3` includes `beamDeps`, while `stdenv.mkDerivation`
does not. BEAM dependencies added there will be correctly handled by the
system.

If a package needs to compile native code via Rebar3\'s port compilation
mechanism, add `compilePort = true;` to the derivation.

#### Erlang.mk Packages {#erlang-mk-packages}

Erlang.mk functions similarly to Rebar3, except we use `buildErlangMk`
instead of `buildRebar3`.
```nix
            { buildErlangMk, fetchHex, cowlib, ranch }:

            buildErlangMk {
              name = "cowboy";
              version = "1.0.4";

              src = fetchHex {
                pkg = "cowboy";
                version = "1.0.4";
                sha256 = "6a0edee96885fae3a8dd0ac1f333538a42e807db638a9453064ccfdaa6b9fdac";
              };

              beamDeps = [ cowlib ranch ];

              meta = {
                description = ''
                  Small, fast, modular HTTP server written in Erlang
                '';
                license = stdenv.lib.licenses.isc;
                homepage = https://github.com/ninenines/cowboy;
              };
            }
```

#### Mix Packages

Mix functions similarly to Rebar3, except we use `buildMix` instead of
`buildRebar3`.
```nix
            { buildMix, fetchHex, plug, absinthe }:

            buildMix {
              name = "absinthe_plug";
              version = "1.0.0";

              src = fetchHex {
                pkg = "absinthe_plug";
                version = "1.0.0";
                sha256 = "08459823fe1fd4f0325a8bf0c937a4520583a5a26d73b193040ab30a1dfc0b33";
              };

              beamDeps = [ plug absinthe ];

              meta = {
                description = ''
                  A plug for Absinthe, an experimental GraphQL toolkit
                '';
                license = stdenv.lib.licenses.bsd3;
                homepage = https://github.com/CargoSense/absinthe_plug;
              };
            }
```

Alternatively, we can use `buildHex` as a shortcut:
```nix
            { buildHex, buildMix, plug, absinthe }:

            buildHex {
              name = "absinthe_plug";
              version = "1.0.0";

              sha256 = "08459823fe1fd4f0325a8bf0c937a4520583a5a26d73b193040ab30a1dfc0b33";

              builder = buildMix;

              beamDeps = [ plug absinthe ];

              meta = {
                description = ''
                  A plug for Absinthe, an experimental GraphQL toolkit
                '';
                license = stdenv.lib.licenses.bsd3;
                homepage = https://github.com/CargoSense/absinthe_plug;
             };
           }
```

How to Develop
--------------

### Accessing an Environment

Often, we simply want to access a valid environment that contains a
specific package and its dependencies. We can accomplish that with the
`env` attribute of a derivation. For example, let\'s say we want to
access an Erlang REPL with `ibrowse` loaded up. We could do the
following:
```sh
          $ nix-shell -A beamPackages.ibrowse.env --run "erl"
          Erlang/OTP 18 [erts-7.0] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false]

          Eshell V7.0  (abort with ^G)
          1> m(ibrowse).
          Module: ibrowse
          MD5: 3b3e0137d0cbb28070146978a3392945
          Compiled: January 10 2016, 23:34
          Object file: /nix/store/g1rlf65rdgjs4abbyj4grp37ry7ywivj-ibrowse-4.2.2/lib/erlang/lib/ibrowse-4.2.2/ebin/ibrowse.beam
          Compiler options:  [{outdir,"/tmp/nix-build-ibrowse-4.2.2.drv-0/hex-source-ibrowse-4.2.2/_build/default/lib/ibrowse/ebin"},
          debug_info,debug_info,nowarn_shadow_vars,
          warn_unused_import,warn_unused_vars,warnings_as_errors,
          {i,"/tmp/nix-build-ibrowse-4.2.2.drv-0/hex-source-ibrowse-4.2.2/_build/default/lib/ibrowse/include"}]
          Exports:
          add_config/1                  send_req_direct/7
          all_trace_off/0               set_dest/3
          code_change/3                 set_max_attempts/3
          get_config_value/1            set_max_pipeline_size/3
          get_config_value/2            set_max_sessions/3
          get_metrics/0                 show_dest_status/0
          get_metrics/2                 show_dest_status/1
          handle_call/3                 show_dest_status/2
          handle_cast/2                 spawn_link_worker_process/1
          handle_info/2                 spawn_link_worker_process/2
          init/1                        spawn_worker_process/1
          module_info/0                 spawn_worker_process/2
          module_info/1                 start/0
          rescan_config/0               start_link/0
          rescan_config/1               stop/0
          send_req/3                    stop_worker_process/1
          send_req/4                    stream_close/1
          send_req/5                    stream_next/1
          send_req/6                    terminate/2
          send_req_direct/4             trace_off/0
          send_req_direct/5             trace_off/2
          send_req_direct/6             trace_on/0
          trace_on/2
          ok
          2>
```

Notice the `-A beamPackages.ibrowse.env`. That is the key to this
functionality.

### Creating a Shell

Getting access to an environment often isn\'t enough to do real
development. Usually, we need to create a `shell.nix` file and do our
development inside of the environment specified therein. This file looks
a lot like the packaging described above, except that `src` points to
the project root and we call the package directly.
```nix
    { pkgs ? import "<nixpkgs"> {} }:

    with pkgs;

    let

      f = { buildRebar3, ibrowse, jsx, erlware_commons }:
          buildRebar3 {
            name = "hex2nix";
            version = "0.1.0";
            src = ./.;
            beamDeps = [ ibrowse jsx erlware_commons ];
          };
      drv = beamPackages.callPackage f {};

    in

      drv
```

#### Building in a Shell (for Mix Projects) {#building-in-a-shell}

We can leverage the support of the derivation, irrespective of the build
derivation, by calling the commands themselves.
```
    # =============================================================================
    # Variables
    # =============================================================================

    NIX_TEMPLATES := "$(CURDIR)/nix-templates"

    TARGET := "$(PREFIX)"

    PROJECT_NAME := thorndyke

    NIXPKGS=../nixpkgs
    NIX_PATH=nixpkgs=$(NIXPKGS)
    NIX_SHELL=nix-shell -I "$(NIX_PATH)" --pure
    # =============================================================================
    # Rules
    # =============================================================================
    .PHONY= all test clean repl shell build test analyze configure install \
            test-nix-install publish plt analyze

    all: build

    guard-%:
            @ if [ "${${*}}" == "" ]; then \
                    echo "Environment variable $* not set"; \
                    exit 1; \
            fi

    clean:
            rm -rf _build
            rm -rf .cache

    repl:
            $(NIX_SHELL) --run "iex -pa './_build/prod/lib/*/ebin'"

    shell:
            $(NIX_SHELL)

    configure:
            $(NIX_SHELL) --command 'eval "$$configurePhase"'

    build: configure
            $(NIX_SHELL) --command 'eval "$$buildPhase"'

    install:
            $(NIX_SHELL) --command 'eval "$$installPhase"'

    test:
            $(NIX_SHELL) --command 'mix test --no-start --no-deps-check'

    plt:
            $(NIX_SHELL) --run "mix dialyzer.plt --no-deps-check"

    analyze: build plt
            $(NIX_SHELL) --run "mix dialyzer --no-compile"


```        

Using a `shell.nix` as described (see [Creating a
Shell](#creating-a-shell)) should just work. Aside from `test`, `plt`,
and `analyze`, the Make targets work just fine for all of the build
derivations.

Generating Packages from Hex with `hex2nix`
-------------------------------------------

Updating the [Hex](https://hex.pm) package set requires
[hex2nix](https://github.com/erlang-nix/hex2nix). Given the path to the
Erlang modules (usually `pkgs/development/erlang-modules`), it will dump
a file called `hex-packages.nix`, containing all the packages that use a
recognized build system in [Hex](https://hex.pm). It can\'t be
determined, however, whether every package is buildable.

To make life easier for our users, try to build every
[Hex](https://hex.pm) package and remove those that fail. To do that,
simply run the following command in the root of your `nixpkgs`
repository:
```sh
    $ nix-build -A beamPackages
```

That will attempt to build every package in `beamPackages`. Then
manually remove those that fail. Hopefully, someone will improve
[hex2nix](https://github.com/erlang-nix/hex2nix) in the future to
automate the process.
