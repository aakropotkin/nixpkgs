Java {#sec-language-java}
====

Ant-based Java packages are typically built from source as follows:
```nix
    stdenv.mkDerivation {
      name = "...";
      src = fetchurl { ... };

      buildInputs = [ jdk ant ];

      buildPhase = "ant";
    }
```
Note that `jdk` is an alias for the OpenJDK (self-built where available,
or pre-built via Zulu). Platforms with OpenJDK not (yet) in Nixpkgs
(`Aarch32`, `Aarch64`) point to the (unfree) `oraclejdk`.

JAR files that are intended to be used by other packages should be
installed in `$out/share/java`. JDKs have a stdenv setup hook that add
any JARs in the `share/java` directories of the build inputs to the
CLASSPATH environment variable. For instance, if the package `libfoo`
installs a JAR named `foo.jar` in its `share/java` directory, and
another package declares the attribute
```nix
    buildInputs = [ jdk libfoo ];
```
then CLASSPATH will be set to
`/nix/store/...-libfoo/share/java/foo.jar`.

Private JARs should be installed in a location like
`$out/share/package-name`.

If your Java package provides a program, you need to generate a wrapper
script to run it using the OpenJRE. You can use `makeWrapper` for this:
```nix
    buildInputs = [ makeWrapper ];

    installPhase =
      ''
        mkdir -p $out/bin
        makeWrapper ${jre}/bin/java $out/bin/foo \
          --add-flags "-cp $out/share/java/foo.jar org.foo.Main"
      '';
```
Note the use of `jre`, which is the part of the OpenJDK package that
contains the Java Runtime Environment. By using `${jre}/bin/java`
instead of `${jdk}/bin/java`, you prevent your package from depending on
the JDK at runtime.

Note all JDKs passthru `home`, so if your application requires
environment variables like JAVA\_HOME being set, that can be done in a
generic fashion with the `--set` argument of `makeWrapper`:
```nix
      --set JAVA_HOME ${jdk.home}
```
It is possible to use a different Java compiler than `javac` from the
OpenJDK. For instance, to use the GNU Java Compiler:
```nix
    buildInputs = [ gcj ant ];
```
Here, Ant will automatically use `gij` (the GNU Java Runtime) instead of
the OpenJRE.
