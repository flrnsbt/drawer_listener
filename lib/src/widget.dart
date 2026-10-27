import 'package:material_ui/material_ui.dart';

/// A widget that rebuilds when the drawer or end drawer open state changes.
///
/// This is a workaround for detecting drawer state when you cannot modify
/// the Scaffold widget directly. The preferred approach is to use
/// Scaffold's [onDrawerChanged] and [onEndDrawerChanged] callbacks.
///
/// WARNING: This is a hacky solution that relies on listening to Scaffold
/// geometry changes. Prefer customizing your Scaffold with proper callbacks
/// instead of using this widget.
///
/// Example:
/// ```dart
/// DrawerStateObserver(
///   builder: (context, isDrawerOpen, isEndDrawerOpen, child) {
///     return Text('Drawer: ${isDrawerOpen ? "open" : "closed"}');
///   },
/// )
/// ```
class DrawerStateObserver extends StatefulWidget {
  /// Creates a widget that listens to drawer state changes.
  const DrawerStateObserver({
    super.key,
    this.child,
    required this.builder,
  });

  /// The child widget that will be passed to the builder.
  ///
  /// This is useful when the child is expensive to rebuild and should
  /// be preserved when the drawer state changes.
  final Widget? child;

  /// Called whenever the drawer or end drawer state changes.
  ///
  /// The builder receives the current [BuildContext], the open state of
  /// both drawers, and the [child] widget if provided.
  final Widget Function(
    BuildContext context,
    bool isDrawerOpen,
    bool isEndDrawerOpen,
    Widget? child,
  )
  builder;

  @override
  State<DrawerStateObserver> createState() => _DrawerStateObserverState();
}

class _DrawerStateObserverState extends State<DrawerStateObserver> {
  /// The nearest ScaffoldState in the widget tree.
  ScaffoldState? _nearestScaffold;

  /// Current open state of the main drawer.
  bool _isDrawerOpen = false;

  /// Current open state of the end drawer.
  bool _isEndDrawerOpen = false;

  /// The Listenable from Scaffold.geometryOf that triggers on layout changes.
  Listenable? _geometryListenable;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Clean up previous listeners
    _geometryListenable?.removeListener(_isVisible);
    _geometryListenable = null;
    _nearestScaffold = null;

    // Find the nearest Scaffold and set up geometry listener
    _nearestScaffold = Scaffold.maybeOf(context);
    if (_nearestScaffold != null) {
      _geometryListenable = Scaffold.geometryOf(context);
      _geometryListenable!.addListener(_isVisible);

      // Initialize with current state
      _isDrawerOpen = _nearestScaffold!.isDrawerOpen;
      _isEndDrawerOpen = _nearestScaffold!.isEndDrawerOpen;
    }
  }

  /// Called when Scaffold geometry changes.
  ///
  /// This is a workaround to detect drawer state changes by checking
  /// the isDrawerOpen/isEndDrawerOpen properties whenever geometry changes.
  void _isVisible() {
    if (_nearestScaffold == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isDrawerOpen = _nearestScaffold!.isDrawerOpen;
      final isEndDrawerOpen = _nearestScaffold!.isEndDrawerOpen;

      // Only rebuild if state actually changed
      if (_isDrawerOpen != isDrawerOpen ||
          _isEndDrawerOpen != isEndDrawerOpen) {
        _isDrawerOpen = isDrawerOpen;
        _isEndDrawerOpen = isEndDrawerOpen;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _geometryListenable?.removeListener(_isVisible);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _isDrawerOpen,
      _isEndDrawerOpen,
      widget.child,
    );
  }
}
