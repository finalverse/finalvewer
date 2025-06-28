// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "FinalviewerIOS",
    platforms: [.iOS(.v15)],
    products: [
        .executable(name: "FinalviewerApp", targets: ["FinalviewerApp"])
    ],
    targets: [
        .target(
            name: "ViewerBridge",
            path: "Bridging",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("../../indra/newview")
            ],
            linkerSettings: [
                .linkedLibrary("viewer"),
                .linkedLibrary("BulletDynamics"),
                .linkedLibrary("BulletCollision"),
                .linkedLibrary("LinearMath"),
                .linkedLibrary("fmod"),
                .linkedFramework("AVFoundation")
            ]
        ),
        .executableTarget(
            name: "FinalviewerApp",
            dependencies: ["ViewerBridge"],
            path: "Sources/FinalviewerApp"
        )
    ]
)
