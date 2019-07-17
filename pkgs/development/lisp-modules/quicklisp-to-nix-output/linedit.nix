args @ { fetchurl, ... }:
rec {
  baseName = ''linedit'';
  version = ''20180430-git'';

  description = ''Readline-style library.'';

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."osicat" args."terminfo" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/linedit/2018-04-30/linedit-20180430-git.tgz'';
    sha256 = ''01sxr0jx2xj52x84pnmr4rg4f6zc93mhbg3v0av3q2pk9lqwgf70'';
  };

  packageName = "linedit";

  asdFilesToKeep = ["linedit.asd"];
  overrides = x: x;
}
/* (SYSTEM linedit DESCRIPTION Readline-style library. SHA256
    01sxr0jx2xj52x84pnmr4rg4f6zc93mhbg3v0av3q2pk9lqwgf70 URL
    http://beta.quicklisp.org/archive/linedit/2018-04-30/linedit-20180430-git.tgz
    MD5 a9f679411d01ec162eb1ba7c76e25d7a NAME linedit FILENAME linedit DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME osicat FILENAME osicat) (NAME terminfo FILENAME terminfo)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain osicat terminfo
     trivial-features)
    VERSION 20180430-git SIBLINGS NIL PARASITES NIL) */
