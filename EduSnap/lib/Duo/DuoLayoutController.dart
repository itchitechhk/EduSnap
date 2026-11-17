import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itchi_flutter_duo_layout/itchi_flutter_duo_layout.dart';

/// Hosts Duo side-rail Back + fold pose for the app shell.
class DuoLayoutController extends ChangeNotifier {
  final navigatorKey = GlobalKey<NavigatorState>();

  StreamSubscription<DuoFoldSnapshot>? _foldSub;
  StreamSubscription<void>? _backSub;

  DuoFoldSnapshot? _fold;
  ItchiSideBackStatus? _sideBackStatus;
  bool _started = false;

  DuoFoldSnapshot? get fold => _fold;
  ItchiSideBackStatus? get sideBackStatus => _sideBackStatus;

  /// Native rail Back is showing — hide Flutter AppBar leading Back.
  bool get isSideBackActive =>
      _sideBackStatus == ItchiSideBackStatus.available;

  /// Fully open spanning both panes — use the full-screen (dual) layout.
  bool get useFullScreenLayout => _fold?.wantsTwoPanes == true;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    _foldSub = ItchiDuoFold.snapshots.listen((snapshot) {
      _fold = snapshot;
      notifyListeners();
    });

    _backSub = ItchiDuoSideBack.onBack.listen((_) {
      navigatorKey.currentState?.maybePop();
    });

    await _enableSideBack();
  }

  Future<void> _enableSideBack() async {
    var status = await ItchiDuoSideBack.setVisible(true);
    // Native view may not be ready on the first call — retry after a frame.
    if (status == ItchiSideBackStatus.viewUnavailable) {
      await Future<void>.delayed(Duration.zero);
      status = await ItchiDuoSideBack.setVisible(true);
    }
    _sideBackStatus = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _foldSub?.cancel();
    _backSub?.cancel();
    unawaited(ItchiDuoSideBack.setVisible(false));
    super.dispose();
  }
}

class DuoScope extends InheritedNotifier<DuoLayoutController> {
  const DuoScope({
    super.key,
    required DuoLayoutController controller,
    required super.child,
  }) : super(notifier: controller);

  static DuoLayoutController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DuoScope>();
    assert(scope != null, 'DuoScope not found in the widget tree.');
    return scope!.notifier!;
  }

  static DuoLayoutController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DuoScope>()?.notifier;
  }
}
