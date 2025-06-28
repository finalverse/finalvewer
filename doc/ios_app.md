# Finalviewer iOS App

[![iOS Build](https://github.com/finalviewer/finalviewer/actions/workflows/ios.yml/badge.svg)](https://github.com/finalviewer/finalviewer/actions/workflows/ios.yml)

This folder contains a minimal Swift package that can be opened in Xcode to run the viewer core on iOS.

## Prerequisites

- Xcode 15 or newer
- iOS 15 SDK
- The viewer dynamic library built following [building_ios.md](building_ios.md)

## Opening the project

1. Build the dynamic library using the instructions in `doc/building_ios.md`.
2. Open `ios/Package.swift` in Xcode. The package defines an executable target `FinalviewerApp`.
3. Ensure the built viewer dynamic library is accessible to the project (for example by copying the resulting `.dylib` into a location referenced by the "viewer" linker setting).
4. Select the `FinalviewerApp` scheme and run on a simulator or device.

## Integrating assets

- Copy any required textures, meshes and UI assets into `ios/Sources/FinalviewerApp` or add them via the Xcode asset catalog.
- Modify `Package.swift` if additional resource bundles are needed.

The SwiftUI interface provides login, chat and HUD layers while `WorldView` uses SceneKit with gesture recognizers for camera control. The `ViewerBridge` layer exposes functions from the C++ core.

## Running tests

Run the UI tests on a simulator with:

```bash
xcodebuild -scheme FinalviewerApp -destination 'platform=iOS Simulator,name=iPhone 15' test
```

This matches the command executed by the continuous integration workflow.
