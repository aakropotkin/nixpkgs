{ stdenv
, fetchPypi, fetchpatch
, buildPythonPackage
, coreschema, itypes, requests, uritemplate
}:
buildPythonPackage rec {

  pname = "coreapi";
  version = "2.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "46145fcc1f7017c076a2ef684969b641d18a2991051fddec9458ad3f78ffc1cb";
  };

  propagatedBuildInputs = [
    coreschema
    itypes
    requests
    uritemplate
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/core-api/python-client";
    license = licenses.bsdOriginal;
    description = "Python client library for Core API.";
    maintainers = with maintainers; [ BadDecisionsAlex ];
  };

}
