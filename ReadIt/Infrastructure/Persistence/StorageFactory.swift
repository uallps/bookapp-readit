import Foundation

#if PersistenciaJSON && PersistenciaCoreData
#error("Restricción XOR violada (O5): no puedes activar PersistenciaJSON y PersistenciaCoreData a la vez.")
#endif

enum StorageFactory {
    static var activeEngineName: String {
#if PersistenciaJSON
        "JSON (books.json)"
#elseif PersistenciaCoreData
        "Core Data / Binario (books.plist)"
#else
        "En memoria (sin persistencia en disco)"
#endif
    }

    static func makeDefault() -> StorageProvider {
#if PersistenciaJSON
        JSONStorageProvider()
#elseif PersistenciaCoreData
        CoreDataStorageProvider()
#else
        MockStorageProvider()
#endif
    }
}