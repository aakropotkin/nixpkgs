{ stdenv
, fetchPypi, fetchpatch
, buildPythonPackage
, coreapi
}:
buildPythonPackage rec {

  pname = "openapi-codec";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bce63289edf53c601ea3683120641407ff6b708803b8954c8a876fe778d2145";
  };

  propagatedBuildInputs = [
    coreapi
  ];

  meta = with stdenv.lib; {
    homepage = "http://github.com/core-api/python-openapi-codec/";
    license = licenses.bsdOriginal;
    description = "An OpenAPI codec for Core API.";
    maintainers = with maintainers; [ BadDecisionsAlex ];
  };

}
