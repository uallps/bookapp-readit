#if BusquedaOrden
import Foundation
import Observation

enum BookSortOrder: Hashable, CaseIterable, Identifiable {
    case original
    case titleAscending
    case titleDescending
    case authorAscending
    case authorDescending

    var id: Self { self }

    var title: String {
        switch self {
        case .original: return "Orden original"
        case .titleAscending: return "Título: A-Z"
        case .titleDescending: return "Título: Z-A"
        case .authorAscending: return "Autor: A-Z"
        case .authorDescending: return "Autor: Z-A"
        }
    }
}

@Observable
final class BookSearchSortViewModel: FeaturePlugin {
    let name = "Búsqueda y ordenación"

    var searchText = ""
    var sortOrder: BookSortOrder = .original

    func filteredAndSortedBooks(_ books: [Book]) -> [Book] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let filteredBooks = query.isEmpty
            ? books
            : books.filter {
                $0.title.localizedStandardContains(query)
                    || ($0.author?.localizedStandardContains(query) ?? false)
            }

        guard sortOrder != .original else { return filteredBooks }

        return filteredBooks.enumerated().sorted { left, right in
            let comparison = compare(left.element, right.element)
            return comparison == .orderedSame
                ? left.offset < right.offset
                : comparison == .orderedAscending
        }.map(\.element)
    }

    private func compare(_ left: Book, _ right: Book) -> ComparisonResult {
        switch sortOrder {
        case .original:
            return .orderedSame
        case .titleAscending:
            return left.title.localizedStandardCompare(right.title)
        case .titleDescending:
            return reversed(left.title.localizedStandardCompare(right.title))
        case .authorAscending:
            return compareAuthors(left.author, right.author, descending: false)
        case .authorDescending:
            return compareAuthors(left.author, right.author, descending: true)
        }
    }

    private func compareAuthors(
        _ left: String?,
        _ right: String?,
        descending: Bool
    ) -> ComparisonResult {
        switch (left, right) {
        case (nil, nil):
            return .orderedSame
        case (nil, _):
            return .orderedDescending
        case (_, nil):
            return .orderedAscending
        case let (left?, right?):
            let comparison = left.localizedStandardCompare(right)
            return descending ? reversed(comparison) : comparison
        }
    }

    private func reversed(_ comparison: ComparisonResult) -> ComparisonResult {
        switch comparison {
        case .orderedAscending: return .orderedDescending
        case .orderedDescending: return .orderedAscending
        case .orderedSame: return .orderedSame
        }
    }
}
#endif
