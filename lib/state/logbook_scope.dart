import 'package:flutter/widgets.dart';
import '../domain/spot_repository.dart';

class LogbookScope extends InheritedNotifier<SpotRepository> {
  const LogbookScope({
    super.key,
    required SpotRepository logbook,
    required super.child,
  }) : super(notifier: logbook);

  static SpotRepository of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LogbookScope>();
    assert(scope != null, 'LogbookScope not found in context');
    return scope!.notifier!;
  }

  static SpotRepository read(BuildContext context) {
    final scope = context
        .getElementForInheritedWidgetOfExactType<LogbookScope>()
        ?.widget as LogbookScope?;
    return scope!.notifier!;
  }
}
