#if Categorias
import Foundation
import Observation

struct BookCategories: Codable {
    let bookId: UUID
    var categories: [String]
}

@Observable
final class CategoriesViewModel: DataPlugin {
    let name = "Categorías"

    var bookCategories: [UUID: BookCategories] = [:] {
        didSet { save() }
    }

    @ObservationIgnored private let storageProvider: CategoryStorageProvider
    @ObservationIgnored private var loaded = false

    init(storageProvider: CategoryStorageProvider = JSONCategoryStorageProvider()) {
        self.storageProvider = storageProvider
        _Concurrency.Task { await loadCategories() }
    }

    func loadCategories() async {
        guard !loaded else { return }
        loaded = true
        do {
            let items = try await storageProvider.loadCategories()
            bookCategories = Dictionary(uniqueKeysWithValues: items.map { ($0.bookId, $0) })
        } catch {
            print("No se han cargado categorías: \(error)")
        }
    }

    func categories(for bookId: UUID) -> [String] {
        bookCategories[bookId]?.categories ?? []
    }

    func updateCategories(bookId: UUID, categories: [String]) {
        let normalized = Self.normalizedCategories(categories)
        if normalized.isEmpty {
            bookCategories.removeValue(forKey: bookId)
        } else {
            bookCategories[bookId] = BookCategories(bookId: bookId, categories: normalized)
        }
    }

    func addCategory(_ category: String, to bookId: UUID) {
        var categories = categories(for: bookId)
        let normalized = category.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty,
              !categories.contains(where: { $0.caseInsensitiveCompare(normalized) == .orderedSame })
        else { return }
        categories.append(normalized)
        updateCategories(bookId: bookId, categories: categories)
    }

    func removeCategory(_ category: String, from bookId: UUID) {
        updateCategories(bookId: bookId, categories: categories(for: bookId).filter { $0 != category })
    }

    func categories(in books: [Book]) -> [String] {
        var result: [String] = []
        let allCategories = books.flatMap { categories(for: $0.id) }
        for category in Set(allCategories).sorted()
        where !result.contains(where: { $0.caseInsensitiveCompare(category) == .orderedSame }) {
            result.append(category)
        }
        return result
    }

    func filteredBooks(_ books: [Book], by category: String?) -> [Book] {
        guard let category,
              categories(in: books).contains(where: { $0.caseInsensitiveCompare(category) == .orderedSame })
        else { return books }
        return books.filter { book in
            categories(for: book.id).contains { $0.caseInsensitiveCompare(category) == .orderedSame }
        }
    }

    // MARK: - DataPlugin

    func willDeleteBook(_ book: Book) {
        guard bookCategories[book.id] != nil else { return }
        bookCategories.removeValue(forKey: book.id)
        print("\(name): borradas las categorías de «\(book.title)»")
    }

    func didDeleteBook(id: UUID) {
        print("\(name): el libro \(id) ya no existe")
    }

    static func normalizedCategories(_ categories: [String]) -> [String] {
        var result: [String] = []
        for category in categories {
            let normalized = category.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !normalized.isEmpty,
                  !result.contains(where: { $0.caseInsensitiveCompare(normalized) == .orderedSame })
            else { continue }
            result.append(normalized)
        }
        return result
    }

    private func save() {
        let items = Array(bookCategories.values)
        _Concurrency.Task {
            do {
                try await storageProvider.saveCategories(items)
            } catch {
                print("No se han guardado las categorías: \(error)")
            }
        }
    }
}
#endif
