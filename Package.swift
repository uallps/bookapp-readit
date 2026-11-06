// swift-tools-version: 6.2
// Paquete para Linux y Windows. Compila la MISMA carpeta ReadIt/ que usa Xcode
// (en Mac se abre ReadIt.xcodeproj y se usa el SwiftUI de Apple).
import PackageDescription

#if os(Linux)
let backend: Target.Dependency = .product(name: "BackendGTK4", package: "SwiftOpenUI")
#elseif os(Windows)
let backend: Target.Dependency = .product(name: "BackendWin32", package: "SwiftOpenUI")
#else
let backend: Target.Dependency? = nil
#endif

let package = Package(
    name: "ReadIt",
    // Productos de la línea: cada trait activo es una variable de compilación (#if Prioridades).
    // En Xcode, el mismo papel lo cumple el target «ReadIt Prioridades».
    traits: [
        .trait(name: "Prioridades", description: "Característica opcional: prioridad del libro"),
    ],
    dependencies: [
        .package(url: "https://github.com/uallps/SwiftOpenUI.git", branch: "uallps"),
    ],
    targets: [
        // Sustituye al SwiftUI de Apple: `import SwiftUI` trae SwiftOpenUI y su backend.
        .target(
            name: "SwiftUI",
            dependencies: [.product(name: "SwiftOpenUI", package: "SwiftOpenUI")] + [backend].compactMap { $0 },
            path: "Compat/SwiftUI"
        ),
        // Mismos ajustes de Swift que el proyecto de Xcode.
        .executableTarget(
            name: "ReadIt",
            dependencies: ["SwiftUI"],
            path: "ReadIt",
            exclude: ["Assets.xcassets"],
            swiftSettings: [
                .swiftLanguageMode(.v5),
                .defaultIsolation(MainActor.self),
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
                .enableUpcomingFeature("InferIsolatedConformances"),
                .enableUpcomingFeature("MemberImportVisibility"),
            ]
        ),
    ]
)
