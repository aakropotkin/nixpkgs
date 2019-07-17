args @ { fetchurl, ... }:
rec {
  baseName = ''osicat'';
  version = ''20180228-git'';

  description = ''A lightweight operating system interface'';

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/osicat/2018-02-28/osicat-20180228-git.tgz'';
    sha256 = ''066i5rapczj6wklrd2bz41a11hhmld89xh3822yhiczvzyndypd1'';
  };

  packageName = "osicat";

  asdFilesToKeep = ["osicat.asd"];
  overrides = x: x;
}
/* (SYSTEM osicat DESCRIPTION A lightweight operating system interface SHA256
    066i5rapczj6wklrd2bz41a11hhmld89xh3822yhiczvzyndypd1 URL
    http://beta.quicklisp.org/archive/osicat/2018-02-28/osicat-20180228-git.tgz
    MD5 542afd5702809ff4a0bf775a183ee527 NAME osicat FILENAME osicat DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain trivial-features) VERSION
    20180228-git SIBLINGS (osicat-tests) PARASITES NIL) */
