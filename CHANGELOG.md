## 0.0.1

* Initial release
* Added `DrawerStateObserver` widget for listening to drawer state changes
* Added stream-based API with `observeDrawerState` and `observeEndDrawerState` functions
* Added BuildContext extension methods `observeDrawer()` and `observeEndDrawer()` for convenient access
* Fixed critical bug in `observeEndDrawerStateOrNull` where it was incorrectly checking `!isDrawerOpen` instead of `isEndDrawerOpen`
* Added comprehensive documentation with warnings about the hacky nature of this package
* Added example app demonstrating usage
