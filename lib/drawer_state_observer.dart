/// A hacky solution to detect Scaffold drawer open state.
///
/// WARNING: This package is NOT recommended for general use.
/// It's a workaround for specific scenarios where you cannot modify
/// the Scaffold widget directly.
///
/// The proper way to detect drawer state changes in Flutter is to use
/// the built-in callbacks on the Scaffold widget:
///
/// ```dart
/// Scaffold(
///   drawer: Drawer(...),
///   onDrawerChanged: (bool isOpen) {
///     // React to drawer state changes
///   },
///   endDrawer: Drawer(...),
///   onEndDrawerChanged: (bool isOpen) {
///     // React to end drawer state changes
///   },
/// )
/// ```
///
/// Use this package only if you absolutely cannot modify the Scaffold widget
/// (e.g., when working with third-party widgets or legacy code).
library;

export 'src/stream.dart';
export 'src/widget.dart';