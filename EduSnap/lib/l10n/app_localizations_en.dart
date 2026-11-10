// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'EduSnap';

  @override
  String get tagline => 'Capture. Learn. Remember.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get storageUsage => 'Storage usage';

  @override
  String storageUsageValue(String size) {
    return '$size KB';
  }

  @override
  String get english => 'English';

  @override
  String get chinese => 'Chinese';

  @override
  String get japanese => 'Japanese';

  @override
  String get back => 'Back';

  @override
  String get list => 'List';

  @override
  String get emptyListHint => 'No entries yet.\nTap + to add one.';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get title => 'Title';

  @override
  String get note => 'Note';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get choosePhoto => 'Choose photo';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get cameraAccessNeeded => 'Camera access is needed to take a photo.';

  @override
  String get photoLibraryAccessNeeded =>
      'Photo library access is needed to choose a photo.';

  @override
  String get couldNotOpenPhotoPicker => 'Could not open the photo picker';

  @override
  String get notNow => 'Not now';

  @override
  String get openSettings => 'Open settings';

  @override
  String get leaveWithoutSaving => 'Leave without saving?';

  @override
  String get stay => 'Stay';

  @override
  String get leave => 'Leave';

  @override
  String get titleMissing => 'Title is missing';

  @override
  String get selectedPhoto => 'Selected photo';

  @override
  String get photo => 'Photo';

  @override
  String get noPhoto => 'No photo';

  @override
  String get deleteThisEntry => 'Delete this entry?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get emptyValue => '-';

  @override
  String createdOn(String date) {
    return 'Created on $date';
  }
}
