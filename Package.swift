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
        .trait(name: "Progreso", description: "Característica opcional F1: Progreso de lectura"),
        .trait(name: "Temporizador", description: "Característica opcional O4: Temporizador de lectura en vivo"),
        .trait(name: "PersistenciaJSON", description: "Característica opcional O5 (XOR): Persistencia local en JSON"),
        .trait(name: "PersistenciaCoreData", description: "Característica opcional O5 (XOR): Persistencia local estructurada (Core Data / Binario)"),
        .trait(name: "Notas", description: "Característica opcional F2: Notas y citas"),
        .trait(name: "Categorias", description: "Característica opcional F3: Categorías"),
        .trait(name: "AlertasContenido", description: "Característica opcional O8: Alertas de contenido sensible"),
        .trait(name: "ListaDeseos", description: "Característica opcional: Lista de deseos"),
        .trait(name: "BusquedaOrden", description: "Característica opcional O10: Búsqueda y ordenación"),
        .trait(name: "Valoraciones", description: "Característica opcional F4: Valoraciones y reseñas"),
        .trait(name: "FechaObjetivo", description: "Característica opcional O2: Fecha objetivo de lectura"),
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