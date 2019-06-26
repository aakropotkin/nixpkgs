{ stdenv
, fetchPypi, fetchpatch
, buildPythonPackage
, jinja2
}:
buildPythonPackage rec {

  pname = "coreschema";
  version = "0.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9503506007d482ab0867ba14724b93c18a33b22b6d19fb419ef2d239dd4a1607";
  };

  propagatedBuildInputs = [
    jinja2
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/core-api/python-coreschema";
    license = licenses.bsdOriginal;
    description = "Core Schema.";
    maintainers = with maintainers; [ BadDecisionsAlex ];
  };

}
