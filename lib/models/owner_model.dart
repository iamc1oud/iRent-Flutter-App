class OwnerProfileSetup {
  final String profileUrl;
  final double latitude, longitude;
  final String countryISOCode;
  final String locality;
  final String subLocality;

  OwnerProfileSetup(this.profileUrl, this.latitude, this.longitude, this.countryISOCode, this.locality, this.subLocality);

  factory OwnerProfileSetup.fromJson(Map<String, dynamic> json) {

  }

}