# Build instructions for iOS

> [!WARNING]
> Please note that we do not give support for compiling the viewer on your own. However, there is a self-compilers group in Second Life that can be joined to ask questions related to compiling the viewer: [Finalviewer Self Compilers](https://tinyurl.com/finalviewer-self-compilers)

These steps describe how to build the viewer core as a dynamic library for iOS.

## Install Xcode and the iOS SDK

1. Download and install Xcode from the Mac App Store or the [Apple developer website](https://developer.apple.com/download).
2. Launch Xcode once so that it installs the required command line tools and iOS SDK.

## Prepare the build environment

1. The repository already contains the `fs-build-variables` directory at its root, so there is no
   need to clone it separately.
2. Export the variables file and configure Autobuild so the required compiler flags are defined:
   ```bash
   export AUTOBUILD_VARIABLES_FILE=../fs-build-variables/variables
   autobuild configure -A 64 -c ReleaseFS_open
   ```
   Running `autobuild configure` populates the `LL_BUILD` environment variable used by the CMake scripts.

## Configure CMake

1. Create a build directory:
   ```
   mkdir build-ios
   cd build-ios
   ```
2. Run CMake from the repository root using the iOS toolchain. Configuring from
   the root ensures that CMake can locate the modules under `indra/cmake`:
   ```
   cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchain-iOS.cmake ../indra
   ```

## Build the dynamic library

Compile the target using CMake:

```
cmake --build . --config Release
```

The resulting `.dylib` or framework will be created in the build directory.
