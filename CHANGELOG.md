## 0.0.3

* Added warning to README about using `material_ui` package instead of the SDK-embedded `material` package

## 0.0.2

* Updated README.md file

## 0.0.1

* Initial release
* Added `DrawerStateObserver` widget for listening to drawer state changes
* Added stream-based API with `observeDrawerState` and `observeEndDrawerState` functions
* Added BuildContext extension methods `observeDrawer()` and `observeEndDrawer()` for convenient access
* Fixed critical bug in `observeEndDrawerStateOrNull` where it was incorrectly checking `!isDrawerOpen` instead of `isEndDrawerOpen`
* Added comprehensive documentation with warnings about the hacky nature of this package
* Added example app demonstrating usage
