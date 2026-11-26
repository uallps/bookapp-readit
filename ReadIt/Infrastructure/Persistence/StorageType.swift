import Foundation

/// Alternativas de almacenamiento (XOR): en Apple se puede elegir SwiftData;
/// en Linux y Windows solo existe la opción por defecto (JSON / StorageFactory).
enum StorageType: String, CaseIterable, Identifiable {
    case json = "JSON"
#if canImport(SwiftData)
    case swiftData = "SwiftData"
#endif

    var id: String { rawValue }

    func makeProvider() -> StorageProvider {
        switch self {
        case .json:
            return StorageFactory.makeDefault()
#if canImport(SwiftData)
        case .swiftData:
            return SwiftDataBookStorageProvider.shared
#endif
        }
    }
}