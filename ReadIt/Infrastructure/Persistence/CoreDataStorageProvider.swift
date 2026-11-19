#if PersistenciaCoreData
import Foundation

/// Persistencia local binaria (variante alternativa a JSON, compatible con Linux y macOS).
final class CoreDataStorageProvider: StorageProvider {
    private let fileURL: URL

    init(filename: String = "books.plist") {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documents.appendingPathComponent(filename)
    }

    func loadBooks() async throws -> [Book] {
        let data = try Data(contentsOf: fileURL)
        return try PropertyListDecoder().decode([Book].self, from: data)
    }

    func saveBooks(books: [Book]) async throws {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        let data = try encoder.encode(books)
        try FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: fileURL)
    }
}
#endif