# drawer_state_observer

A hacky solution to detect Scaffold drawer open state for cases where you cannot customize the Scaffold/Drawer implementation.

> **⚠️ Note:** This package is designed to work with the [`material_ui`](https://pub.dev/packages/material_ui) package, **not** with the `material` package embedded in the Flutter SDK. The `material_ui` package is the newly preferred Material UI implementation, while the SDK-embedded `material` package will be deprecated and removed in the future. Make sure you correctly use `material_ui` in your dependencies before using this package.

## ⚠️ IMPORTANT WARNING

**This package is NOT recommended for general use.** It's a workaround for specific scenarios where you cannot modify the Scaffold widget directly.

### Preferred Flutter Approach

The proper way to detect drawer state changes in Flutter is to use the built-in callbacks on the Scaffold widget:

```dart
Scaffold(
  drawer: Drawer(...),
  onDrawerChanged: (bool isOpen) {
    // React to drawer state changes
  },
  endDrawer: Drawer(...),
  onEndDrawerChanged: (bool isOpen) {
    // React to end drawer state changes
  },
)
```

These callbacks are the official, stable, and recommended way to handle drawer state changes. Use this package only if you absolutely cannot modify the Scaffold widget (e.g., when working with third-party widgets or legacy code that wraps Scaffold).

## Features

- Listen to drawer open/close state changes via Stream
- Widget-based approach using `DrawerStateObserver`
- Works with both regular drawer and end drawer
- Uses Scaffold geometry change detection internally

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  drawer_state_observer: ^0.0.1
  material_ui: ^1.8.0
```

## Usage

### Widget Approach

Use `DrawerStateObserver` to rebuild parts of your UI when drawer state changes:

```dart
DrawerStateObserver(
  builder: (context, isDrawerOpen, isEndDrawerOpen, child) {
    return Column(
      children: [
        Text('Drawer open: $isDrawerOpen'),
        Text('End drawer open: $isEndDrawerOpen'),
        if (child != null) child,
      ],
    );
  },
  child: YourBodyWidget(),
)
```

### Stream Approach

Use the stream-based API to listen to drawer state changes reactively:

```dart
// Listen to regular drawer
context.observeDrawer().listen((isOpen) {
  print('Drawer is ${isOpen ? "open" : "closed"}');
});

// Listen to end drawer
context.observeEndDrawer().listen((isOpen) {
  print('End drawer is ${isOpen ? "open" : "closed"}');
});

// Or use the functions directly
observeDrawerState(context).listen((isOpen) {
  // Handle drawer state
});

observeEndDrawerStateOrNull(context)?.listen((isOpen) {
  // Handle end drawer state (nullable)
});
```

### Complete Example

```dart
import 'package:material_ui/material_ui.dart';
import 'package:drawer_state_observer/drawer_state_observer.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('Menu'),
            ),
            ListTile(title: Text('Item 1')),
            ListTile(title: Text('Item 2')),
          ],
        ),
      ),
      body: DrawerStateObserver(
        builder: (context, isDrawerOpen, isEndDrawerOpen, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Drawer Status',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 16),
                Text('Main drawer: ${isDrawerOpen ? "OPEN" : "CLOSED"}'),
                Text('End drawer: ${isEndDrawerOpen ? "OPEN" : "CLOSED"}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

## How It Works

This package uses a workaround by:

1. Finding the nearest `ScaffoldState` using `Scaffold.maybeOf(context)`
2. Listening to `Scaffold.geometryOf(context)` which triggers on layout changes
3. Checking the internal `isDrawerOpen`/`isEndDrawerOpen` properties when geometry changes
4. Broadcasting these changes via streams or rebuilding widgets

This is "hacky" because:

- It relies on internal implementation details of Scaffold
- It polls on geometry changes rather than using proper callbacks
- It may have performance implications due to listening to all geometry changes
- It may break if Flutter's internal Scaffold implementation changes

## Limitations

- Must be used inside a widget tree that has a Scaffold ancestor
- Cannot detect drawer state if no Scaffold is found in the context
- The stream approach requires proper disposal to avoid memory leaks
- May not work correctly with custom Scaffold implementations
- Performance overhead from listening to geometry changes

## Additional Information

### When to Use This Package

Use this package only when:

- You cannot modify the Scaffold widget (e.g., third-party library)
- You need to detect drawer state from a descendant widget
- You're working with legacy code that cannot be refactored

### When NOT to Use This Package

Do NOT use this package when:

- You have control over the Scaffold widget - use `onDrawerChanged`/`onEndDrawerChanged` instead
- You're building new code - design it properly from the start
- Performance is critical - this has overhead from geometry listening

## License

See the [LICENSE](LICENSE) file for details