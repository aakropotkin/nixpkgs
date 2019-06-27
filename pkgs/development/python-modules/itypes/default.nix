{ stdenv
, fetchPypi, fetchpatch
, buildPythonPackage
}:
buildPythonPackage rec {

  pname = "itypes";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6e77bb9fd68a4bfeb9d958fea421802282451a25bac4913ec94db82a899c073";
  };

  meta = with stdenv.lib; {
    homepage = "http://github.com/tomchristie/itypes";
    license = licenses.bsdOriginal;
    description = "Simple immutable types for python.";
    maintainers = with maintainers; [ BadDecisionsAlex ];
  };

}
