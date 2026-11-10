// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'EduSnap';

  @override
  String get tagline => '撮影。学習。記憶。';

  @override
  String get getStarted => 'はじめる';

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get storageUsage => 'ストレージ使用量';

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
  String get back => '戻る';

  @override
  String get list => '一覧';

  @override
  String get emptyListHint => 'まだ項目がありません。\n+ をタップして追加してください。';

  @override
  String get add => '追加';

  @override
  String get edit => '編集';

  @override
  String get save => '保存';

  @override
  String get title => 'タイトル';

  @override
  String get note => 'メモ';

  @override
  String get addPhoto => '写真を追加';

  @override
  String get changePhoto => '写真を変更';

  @override
  String get choosePhoto => '写真を選択';

  @override
  String get gallery => 'ギャラリー';

  @override
  String get camera => 'カメラ';

  @override
  String get cameraAccessNeeded => '写真を撮るにはカメラへのアクセスが必要です。';

  @override
  String get photoLibraryAccessNeeded => '写真を選ぶにはフォトライブラリへのアクセスが必要です。';

  @override
  String get couldNotOpenPhotoPicker => '写真ピッカーを開けませんでした';

  @override
  String get notNow => '後で';

  @override
  String get openSettings => '設定を開く';

  @override
  String get leaveWithoutSaving => '保存せずに離れますか？';

  @override
  String get stay => '残る';

  @override
  String get leave => '離れる';

  @override
  String get titleMissing => 'タイトルが未入力です';

  @override
  String get selectedPhoto => '選択した写真';

  @override
  String get photo => '写真';

  @override
  String get noPhoto => '写真なし';

  @override
  String get deleteThisEntry => 'この項目を削除しますか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get emptyValue => '-';

  @override
  String createdOn(String date) {
    return '$date に作成';
  }
}
