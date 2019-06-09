Qt {#sec-language-qt}
==

Qt is a comprehensive desktop and mobile application development toolkit
for C++. Legacy support is available for Qt 3 and Qt 4, but all current
development uses Qt 5. The Qt 5 packages in Nixpkgs are updated
frequently to take advantage of new features, but older versions are
typically retained until their support window ends. The most important
consideration in packaging Qt-based software is ensuring that each
package and all its dependencies use the same version of Qt 5; this
consideration motivates most of the tools described below.

Packaging Libraries for Nixpkgs {#ssec-qt-libraries}
-------------------------------

Whenever possible, libraries that use Qt 5 should be built with each
available version. Packages providing libraries should be added to the
top-level function `mkLibsForQt5`, which is used to build a set of
libraries for every Qt 5 version. A special `callPackage` function is
used in this scope to ensure that the entire dependency tree uses the
same Qt 5 version. Import dependencies unqualified, i.e., `qtbase` not
`qt5.qtbase`. *Do not* import a package set such as `qt5` or
`libsForQt5`.

If a library does not support a particular version of Qt 5, it is best
to mark it as broken by setting its `meta.broken` attribute. A package
may be marked broken for certain versions by testing the
`qtbase.version` attribute, which will always give the current Qt 5
version.

Packaging Applications for Nixpkgs {#ssec-qt-applications}
----------------------------------

Call your application expression using `libsForQt5.callPackage` instead
of `callPackage`. Import dependencies unqualified, i.e., `qtbase` not
`qt5.qtbase`. *Do not* import a package set such as `qt5` or
`libsForQt5`.

Qt 5 maintains strict backward compatibility, so it is generally best to
build an application package against the latest version using the
`libsForQt5` library set. In case a package does not build with the
latest Qt version, it is possible to pick a set pinned to a particular
version, e.g. `libsForQt55` for Qt 5.5, if that is the latest version
the package supports. If a package must be pinned to an older Qt
version, be sure to file a bug upstream; because Qt is strictly
backwards-compatible, any incompatibility is by definition a bug in the
application.

When testing applications in Nixpkgs, it is a common practice to build
the package with `nix-build` and run it using the created symbolic link.
This will not work with Qt applications, however, because they have many
hard runtime requirements that can only be guaranteed if the package is
actually installed. To test a Qt application, install it with `nix-env`
or run it inside `nix-shell`.
