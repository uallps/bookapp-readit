#if Categorias
import Foundation

extension Book {
    init(
        id: UUID = UUID(),
        title: String,
        author: String? = nil,
        state: ReadingState = .pending,
        categories: [String],
        dueDate: Date? = nil
    ) {
        self.init(id: id, title: title, author: author, state: state, dueDate: dueDate)
        self.categories = Self.normalizedCategories(categories)
    }

    mutating func addCategory(_ category: String) {
        let normalized = category.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty,
              !categories.contains(where: { $0.caseInsensitiveCompare(normalized) == .orderedSame })
        else { return }
        categories.append(normalized)
    }

    mutating func removeCategory(_ category: String) {
        categories.removeAll { $0 == category }
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
}
#endif