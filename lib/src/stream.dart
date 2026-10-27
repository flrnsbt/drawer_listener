import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

/// Internal helper function to create a stream that listens to drawer state changes.
///
/// This is a workaround that uses Scaffold geometry changes to detect drawer state.
/// The proper approach is to use Scaffold's onDrawerChanged/onEndDrawerChanged callbacks.
///
/// Returns null if no Scaffold is found in the context.
Stream<bool>? _drawerListenerOrNull(
  BuildContext context,
  bool Function(ScaffoldState) isDrawerOpen,
) {
  ScaffoldState? scaffoldState = Scaffold.maybeOf(context);
  if (scaffoldState == null) return null;
  ValueListenable<ScaffoldGeometry>? scaffoldGeometry = Scaffold.geometryOf(
    context,
  );
  late StreamController<bool> drawerController;

  /// Listener callback that fires when Scaffold geometry changes.
  ///
  /// This checks if the drawer state has changed and emits the new state
  /// to the stream. Also handles cleanup if the context is unmounted or
  /// the Scaffold has changed.
  void listener() {
    void cancel() {
      scaffoldGeometry?.removeListener(listener);
      drawerController.close();
    }

    if (!context.mounted) {
      cancel();
      return;
    }
    final newScaffoldState = Scaffold.maybeOf(context);
    if (newScaffoldState == null || newScaffoldState != scaffoldState) {
      cancel();
      return;
    }
    drawerController.add(isDrawerOpen(newScaffoldState));
  }

  /// Cleanup function to remove the listener and close the stream.
  void cancel() {
    scaffoldGeometry?.removeListener(listener);
    drawerController.close();
  }

  drawerController = StreamController<bool>.broadcast(
    onListen: () {
      if (context.mounted) {
        // Emit current state immediately
        drawerController.add(isDrawerOpen(scaffoldState));
        // Set up geometry listener for subsequent changes
        scaffoldGeometry = Scaffold.geometryOf(context);
        scaffoldGeometry!.addListener(listener);
      }
    },
    onCancel: cancel,
  );

  return drawerController.stream.distinct();
}

/// Creates a stream that emits the main drawer's open state.
///
/// Returns null if no Scaffold is found in the context.
/// The stream emits true when the drawer is open, false when closed.
///
/// This is a workaround. Prefer using Scaffold's onDrawerChanged callback.
Stream<bool>? observeDrawerStateOrNull(BuildContext context) {
  return _drawerListenerOrNull(
    context,
    (ScaffoldState scaffoldState) => scaffoldState.isDrawerOpen,
  );
}

/// Creates a stream that emits the main drawer's open state.
///
/// Asserts that a Scaffold exists in the context.
/// Throws an assertion error in debug mode if no Scaffold is found.
///
/// This is a workaround. Prefer using Scaffold's onDrawerChanged callback.
Stream<bool> observeDrawerState(BuildContext context) {
  final stream = observeDrawerStateOrNull(context);
  assert(stream != null);
  return stream!;
}

/// Creates a stream that emits the end drawer's open state.
///
/// Returns null if no Scaffold is found in the context.
/// The stream emits true when the end drawer is open, false when closed.
///
/// This is a workaround. Prefer using Scaffold's onEndDrawerChanged callback.
Stream<bool>? observeEndDrawerStateOrNull(BuildContext context) {
  return _drawerListenerOrNull(
    context,
    (ScaffoldState scaffoldState) => scaffoldState.isEndDrawerOpen,
  );
}

/// Creates a stream that emits the end drawer's open state.
///
/// Asserts that a Scaffold exists in the context.
/// Throws an assertion error in debug mode if no Scaffold is found.
///
/// This is a workaround. Prefer using Scaffold's onEndDrawerChanged callback.
Stream<bool> observeEndDrawerState(BuildContext context) {
  final stream = observeEndDrawerStateOrNull(context);
  assert(stream != null);
  return stream!;
}

/// Extension on BuildContext to provide convenient access to drawer streams.
///
/// Example:
/// ```dart
/// context.observeDrawer().listen((isOpen) {
///   print('Drawer is ${isOpen ? "open" : "closed"}');
/// });
/// ```
extension BuildContextDrawerListener on BuildContext {
  /// Returns a stream that emits the main drawer's open state.
  ///
  /// This is a workaround. Prefer using Scaffold's onDrawerChanged callback.
  Stream<bool> observeDrawer() => observeDrawerState(this);

  /// Returns a stream that emits the end drawer's open state.
  ///
  /// This is a workaround. Prefer using Scaffold's onEndDrawerChanged callback.
  Stream<bool> observeEndDrawer() => observeEndDrawerState(this);
}
