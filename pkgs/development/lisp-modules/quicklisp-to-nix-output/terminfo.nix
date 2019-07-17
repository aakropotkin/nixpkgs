args @ { fetchurl, ... }:
rec {
  baseName = ''terminfo'';
  version = ''20180831-git'';

  description = ''Terminfo database front-end.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/terminfo/2018-08-31/terminfo-20180831-git.tgz'';
    sha256 = ''0gvnbb3lcq5ffrx5j9yimf919ji7fx3ar9xk89k9a3pap4v1nv8v'';
  };

  packageName = "terminfo";

  asdFilesToKeep = ["terminfo.asd"];
  overrides = x: x;
}
/* (SYSTEM terminfo DESCRIPTION Terminfo database front-end. SHA256
    0gvnbb3lcq5ffrx5j9yimf919ji7fx3ar9xk89k9a3pap4v1nv8v URL
    http://beta.quicklisp.org/archive/terminfo/2018-08-31/terminfo-20180831-git.tgz
    MD5 0b3ee86845c43c92cfb8eaddaa94ce42 NAME terminfo FILENAME terminfo DEPS
    NIL DEPENDENCIES NIL VERSION 20180831-git SIBLINGS NIL PARASITES NIL) */
