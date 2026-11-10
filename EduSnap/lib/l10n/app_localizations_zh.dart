// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'EduSnap';

  @override
  String get tagline => '拍攝。學習。記住。';

  @override
  String get getStarted => '開始使用';

  @override
  String get settings => '設定';

  @override
  String get language => '語言';

  @override
  String get storageUsage => '儲存空間';

  @override
  String storageUsageValue(String size) {
    return '$size KB';
  }

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get japanese => '日本語';

  @override
  String get back => '返回';

  @override
  String get list => '清單';

  @override
  String get emptyListHint => '尚無項目。\n點一下 + 來新增。';

  @override
  String get add => '新增';

  @override
  String get edit => '編輯';

  @override
  String get save => '儲存';

  @override
  String get title => '標題';

  @override
  String get note => '筆記';

  @override
  String get addPhoto => '新增照片';

  @override
  String get changePhoto => '更換照片';

  @override
  String get choosePhoto => '選擇照片';

  @override
  String get gallery => '相簿';

  @override
  String get camera => '相機';

  @override
  String get cameraAccessNeeded => '需要相機權限才能拍照。';

  @override
  String get photoLibraryAccessNeeded => '需要照片圖庫權限才能選擇照片。';

  @override
  String get couldNotOpenPhotoPicker => '無法開啟照片選擇器';

  @override
  String get notNow => '暫時不要';

  @override
  String get openSettings => '開啟設定';

  @override
  String get leaveWithoutSaving => '要離開且不儲存嗎？';

  @override
  String get stay => '留下';

  @override
  String get leave => '離開';

  @override
  String get titleMissing => '尚未填寫標題';

  @override
  String get selectedPhoto => '已選取的照片';

  @override
  String get photo => '照片';

  @override
  String get noPhoto => '沒有照片';

  @override
  String get deleteThisEntry => '要刪除這個項目嗎？';

  @override
  String get cancel => '取消';

  @override
  String get delete => '刪除';

  @override
  String get emptyValue => '-';

  @override
  String createdOn(String date) {
    return '$date 建立';
  }
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appName => 'EduSnap';

  @override
  String get tagline => '拍攝。學習。記住。';

  @override
  String get getStarted => '開始使用';

  @override
  String get settings => '設定';

  @override
  String get language => '語言';

  @override
  String get storageUsage => '儲存空間';

  @override
  String storageUsageValue(String size) {
    return '$size KB';
  }

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get japanese => '日本語';

  @override
  String get back => '返回';

  @override
  String get list => '清單';

  @override
  String get emptyListHint => '尚無項目。\n點一下 + 來新增。';

  @override
  String get add => '新增';

  @override
  String get edit => '編輯';

  @override
  String get save => '儲存';

  @override
  String get title => '標題';

  @override
  String get note => '筆記';

  @override
  String get addPhoto => '新增照片';

  @override
  String get changePhoto => '更換照片';

  @override
  String get choosePhoto => '選擇照片';

  @override
  String get gallery => '相簿';

  @override
  String get camera => '相機';

  @override
  String get cameraAccessNeeded => '需要相機權限才能拍照。';

  @override
  String get photoLibraryAccessNeeded => '需要照片圖庫權限才能選擇照片。';

  @override
  String get couldNotOpenPhotoPicker => '無法開啟照片選擇器';

  @override
  String get notNow => '暫時不要';

  @override
  String get openSettings => '開啟設定';

  @override
  String get leaveWithoutSaving => '要離開且不儲存嗎？';

  @override
  String get stay => '留下';

  @override
  String get leave => '離開';

  @override
  String get titleMissing => '尚未填寫標題';

  @override
  String get selectedPhoto => '已選取的照片';

  @override
  String get photo => '照片';

  @override
  String get noPhoto => '沒有照片';

  @override
  String get deleteThisEntry => '要刪除這個項目嗎？';

  @override
  String get cancel => '取消';

  @override
  String get delete => '刪除';

  @override
  String get emptyValue => '-';

  @override
  String createdOn(String date) {
    return '$date 建立';
  }
}
