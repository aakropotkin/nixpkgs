{ stdenv
, fetchPypi
, buildPythonPackage
, django, djangorestframework, coreschema, coreapi
, uritemplate, six, inflection, ruamel_yaml
}:
buildPythonPackage rec {
  pname = "drf-yasg";
  version = "1.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "82b535a22fc13e0a202217df4c6470c40b54d21f742e69798f53c69afccbfdac";
  };

  doCheck = false;

  propagatedBuildInputs = [
    django
    djangorestframework
    coreapi
    coreschema
    uritemplate
    six
    inflection
    ruamel_yaml
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/axnsan12/drf-yasg";
    license = licenses.bsd0;
    description = ''
      Generate real Swagger/OpenAPI 2.0 specifications from a Django Rest Framework API.
    '';
    maintainers = with maintainers; [BadDecisionsAlex];
  };
}
