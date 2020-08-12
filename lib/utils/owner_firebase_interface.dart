import 'dart:io';


abstract class OwnerFirebaseInterface {
// TODO : Funtion to update the existing profile in users with the location and links of images provided by user.
  /// Takes argument : Map<String, dyanmic> userData
  void updateRegistrationProfile(Map<String, dynamic> userRegistrationData, String userUid, String userType) {}

  /// Takes parameter File profileImage
  Future<String> profilePictureUrl(File profileImage, String userUid);

  /// Extract download link of profile image from storage bucket
  Future<String> getDownloadUrlProfilePicture(String userUid);

  /// Extract download link of home images from storage bucket
  Future<String> getHomeUrl(String uid, int photoNumber);

  /// Upload residence pictures to firebase collection
  /// Format is : homeImages/${uid}_home_${i.toString()}
  /// Returns true on complete.
  Future<bool> uploadHomePicture(List<File> homeImages, String uid);

}
