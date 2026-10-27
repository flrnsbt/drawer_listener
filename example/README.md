# drawer_state_observer Example

This example demonstrates the usage of the `drawer_state_observer` package with multiple approaches.

## ⚠️ Warning

This package is a workaround. In production code, prefer using Scaffold's `onDrawerChanged` and `onEndDrawerChanged` callbacks instead.

## Running the Example

```bash
cd example
flutter pub get
flutter run
```

## Examples Included

### 1. Widget Approach
Demonstrates using `DrawerStateObserver` widget to rebuild UI when drawer state changes. This is the simplest approach for most use cases.

### 2. Stream Approach
Shows how to use the stream-based API with `StreamSubscription` for reactive programming patterns. This is useful when you need to handle drawer state changes in a more functional/reactive way.

### 3. Proper Flutter Approach (RECOMMENDED)
Demonstrates the official Flutter way using Scaffold's `onDrawerChanged` and `onEndDrawerChanged` callbacks. This is the recommended approach for all production code.

## Features

- **Home Screen**: Navigation menu to access all examples
- **Visual Feedback**: Color-coded status cards that change when drawers open/close
- **Warning Messages**: Clear documentation about when to use each approach
- **Both Drawers**: Examples support both main drawer and end drawer

## Comparison

| Approach | When to Use | Pros | Cons |
|----------|-------------|------|------|
| **Widget** | Simple UI updates | Easy to use, automatic cleanup | Less flexible for complex logic |
| **Stream** | Reactive programming | Functional style, can combine streams | Manual subscription management |
| **Scaffold Callbacks** | Production code | Official API, no overhead, performant | Requires access to Scaffold widget |

## Architecture

```
example/
├── lib/
│   ├── main.dart                 # Home screen with navigation
│   ├── widget_example.dart       # Widget-based approach
│   ├── stream_example.dart       # Stream-based approach
│   └── proper_approach_example.dart # Official Flutter approach
└── pubspec.yaml                  # Dependencies
```
