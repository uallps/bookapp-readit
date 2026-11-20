#if Categorias
import Foundation
import Observation

@Observable
final class CategoriesViewModel {
    func categories(in books: [Book]) -> [String] {
        var result: [String] = []
        for category in Set(books.flatMap(\.categories)).sorted()
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
            book.categories.contains { $0.caseInsensitiveCompare(category) == .orderedSame }
        }
    }
}
#endif
