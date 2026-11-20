#if Estadisticas
import Foundation
import Observation

/// Modelo con el resumen de métricas calculadas para F5 (Estadísticas).
struct ReadingStatisticsSummary {
    let totalBooks: Int
    let pendingBooks: Int
    let readingBooks: Int
    let finishedBooks: Int

    let totalPagesRead: Int
    let totalPagesTracked: Int
    let trackedBooksCount: Int
    let averageBookProgress: Double

    var completionPercentage: Double {
        guard totalBooks > 0 else { return 0 }
        return Double(finishedBooks) / Double(totalBooks)
    }

    var readingPercentage: Double {
        guard totalBooks > 0 else { return 0 }
        return Double(readingBooks) / Double(totalBooks)
    }

    var pendingPercentage: Double {
        guard totalBooks > 0 else { return 0 }
        return Double(pendingBooks) / Double(totalBooks)
    }

    var pagesCompletionPercentage: Double {
        guard totalPagesTracked > 0 else { return 0 }
        return Double(totalPagesRead) / Double(totalPagesTracked)
    }
}

/// ViewModel exclusivo para calcular las estadísticas de lectura (F5).
/// Depende de F1 (Progreso) según la relación <<requires>> del modelo de características.
@Observable
final class StatsViewModel {
    func count(for state: ReadingState, in books: [Book]) -> Int {
        books.filter { $0.state == state }.count
    }

    func percentage(for state: ReadingState, in books: [Book]) -> Double {
        guard !books.isEmpty else { return 0 }
        return Double(count(for: state, in: books)) / Double(books.count)
    }

    func categoryBreakdown(from books: [Book]) -> [(category: String, count: Int)] {
        var counts: [String: Int] = [:]
        for book in books {
            for category in book.categories {
                counts[category, default: 0] += 1
            }
        }
        return counts
            .map { (category: $0.key, count: $0.value) }
            .sorted { lhs, rhs in
                if lhs.count == rhs.count {
                    return lhs.category.localizedCaseInsensitiveCompare(rhs.category) == .orderedAscending
                }
                return lhs.count > rhs.count
            }
    }

#if Progreso
    func buildSummary(books: [Book], progresses: [UUID: BookProgress]) -> ReadingStatisticsSummary {
        let total = books.count
        let pending = count(for: .pending, in: books)
        let reading = count(for: .reading, in: books)
        let finished = count(for: .finished, in: books)

        let trackedProgresses = books.compactMap { book -> BookProgress? in
            guard let progress = progresses[book.id], progress.totalPages > 0 else { return nil }
            return progress
        }

        let pagesRead = trackedProgresses.reduce(0) { $0 + min($1.currentPage, $1.totalPages) }
        let pagesTotal = trackedProgresses.reduce(0) { $0 + $1.totalPages }
        let avgProgress: Double = trackedProgresses.isEmpty
            ? 0
            : trackedProgresses.reduce(0.0) { $0 + min(max($1.percentage, 0), 1) } / Double(trackedProgresses.count)

        return ReadingStatisticsSummary(
            totalBooks: total,
            pendingBooks: pending,
            readingBooks: reading,
            finishedBooks: finished,
            totalPagesRead: pagesRead,
            totalPagesTracked: pagesTotal,
            trackedBooksCount: trackedProgresses.count,
            averageBookProgress: avgProgress
        )
    }
#else
    func buildSummary(books: [Book]) -> ReadingStatisticsSummary {
        ReadingStatisticsSummary(
            totalBooks: books.count,
            pendingBooks: count(for: .pending, in: books),
            readingBooks: count(for: .reading, in: books),
            finishedBooks: count(for: .finished, in: books),
            totalPagesRead: 0,
            totalPagesTracked: 0,
            trackedBooksCount: 0,
            averageBookProgress: 0
        )
    }
#endif
}
#endif
