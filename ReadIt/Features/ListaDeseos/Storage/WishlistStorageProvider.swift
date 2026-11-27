#if ListaDeseos
import Foundation

struct WishlistEntry: Codable, Equatable {
    let bookId: UUID
}

protocol WishlistStorageProvider {
    func loadWishlist() async throws -> [WishlistEntry]
    func saveWishlist(_ items: [WishlistEntry]) async throws
}

final class JSONWishlistStorageProvider: WishlistStorageProvider {
    private let fileURL: URL

    init(fileName: String = "book-wishlist.json") {
        let baseDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        let appDir = baseDir.appendingPathComponent("ReadIt", isDirectory: true)
        try? FileManager.default.createDirectory(at: appDir, withIntermediateDirectories: true)
        self.fileURL = appDir.appendingPathComponent(fileName)
    }

    func loadWishlist() async throws -> [WishlistEntry] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([WishlistEntry].self, from: data)
    }

    func saveWishlist(_ items: [WishlistEntry]) async throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(items)
        try data.write(to: fileURL, options: .atomic)
    }
}
#endif