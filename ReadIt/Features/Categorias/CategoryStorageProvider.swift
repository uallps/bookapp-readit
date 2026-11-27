#if Categorias
import Foundation

protocol CategoryStorageProvider {
    func loadCategories() async throws -> [BookCategories]
    func saveCategories(_ categories: [BookCategories]) async throws
}

final class JSONCategoryStorageProvider: CategoryStorageProvider {
    private let fileURL: URL

    init(filename: String = "book-categories.json") {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documents.appendingPathComponent(filename)
    }

    func loadCategories() async throws -> [BookCategories] {
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([BookCategories].self, from: data)
        } catch {
            return try migrateLegacyCategories()
        }
    }

    func saveCategories(_ categories: [BookCategories]) async throws {
        let data = try JSONEncoder().encode(categories)
        try FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try data.write(to: fileURL)
    }

    private func migrateLegacyCategories() throws -> [BookCategories] {
        let legacyURL = fileURL.deletingLastPathComponent().appendingPathComponent("books.json")
        let data = try Data(contentsOf: legacyURL)
        let legacyBooks = try JSONDecoder().decode([LegacyBookCategories].self, from: data)
        return legacyBooks
            .compactMap { legacyBook -> BookCategories? in
                let categories = legacyBook.categories ?? []
                guard !categories.isEmpty else { return nil }
                return BookCategories(bookId: legacyBook.id, categories: categories)
            }
    }

    private struct LegacyBookCategories: Codable {
        let id: UUID
        let categories: [String]?
    }
}
#endif
