class OwnerProfileSetup {
  final String profileUrl;
  final double latitude, longitude;
  final String countryISOCode;
  final String locality;
  final String subLocality;
  final String profilePictureDownloadUrl;

  OwnerProfileSetup(
      {this.profilePictureDownloadUrl,
      this.profileUrl,
      this.latitude,
      this.longitude,
      this.countryISOCode,
      this.locality,
      this.subLocality});

  Map<String, dynamic> toJson() => {
        'profileUrl': this.profileUrl,
        'latitude': this.latitude,
        'longitude': this.longitude,
        'countryISOCode': this.countryISOCode,
        'subLocality': this.subLocality,
        "isRegistered": true,
        "profilePictureDownloadUrl": ""
      };
}
