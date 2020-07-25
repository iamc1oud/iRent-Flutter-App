class GuestProfileSetup {
  final String profileUrl;
  final String profilePictureDownloadUrl;

  GuestProfileSetup(
      {this.profilePictureDownloadUrl,
        this.profileUrl,
     });

  Map<String, dynamic> toJson() => {
    'profileUrl': this.profileUrl,
    "isRegistered": true,
    "profilePictureDownloadUrl": ""
  };
}
