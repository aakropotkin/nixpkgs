{ stdenv
, fetchPypi, fetchpatch
, buildPythonPackage
, django, djangorestframework, openapi-codec, simplejson
}:
buildPythonPackage rec {

  pname = "django-rest-swagger";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "48f6aded9937e90ae7cbe9e6c932b9744b8af80cc4e010088b3278c700e0685b";
  };

  propagatedBuildInputs = [
    django
    djangorestframework
    openapi-codec
    simplejson
  ];
  
  meta = with stdenv.lib; {
    homepage = "https://github.com/marcgibbons/django-rest-swagger";
    license = licenses.bsdOriginal;
    description = "Swagger UI for Django REST Framework 3.5+";
    maintainers = with maintainers; [ BadDecisionsAlex ];
  };

}
