#if Progreso
import Foundation
import Observation

/// Modelo de datos independiente para F1 (Progreso)
struct BookProgress: Codable {
    let bookId: UUID
    var currentPage: Int
    var totalPages: Int

    var percentage: Double {
        guard totalPages > 0 else { return 0 }
        return Double(currentPage) / Double(totalPages)
    }
}

/// Plugin de datos para gestionar el progreso de lectura
@Observable
final class ProgressViewModel: DataPlugin {
    let name = "Progreso de lectura"

    /// Cada cambio en los progresos se guarda automáticamente en book-progress.json
    var progresses: [UUID: BookProgress] = [:] {
        didSet { save() }
    }

    @ObservationIgnored private let storageProvider: ProgressStorageProvider
    @ObservationIgnored private var loaded = false

    init(storageProvider: ProgressStorageProvider = JSONProgressStorageProvider()) {
        self.storageProvider = storageProvider
        _Concurrency.Task { await loadProgresses() }
    }

    func loadProgresses() async {
        guard !loaded else { return }
        loaded = true
        do {
            let list = try await storageProvider.loadProgresses()
            progresses = Dictionary(uniqueKeysWithValues: list.map { ($0.bookId, $0) })
        } catch {
            print("No se han cargado progresos: \(error)")
        }
    }

    func updateProgress(bookId: UUID, current: Int, total: Int) {
        progresses[bookId] = BookProgress(bookId: bookId, currentPage: current, totalPages: total)
    }

    func getProgress(bookId: UUID) -> BookProgress? {
        return progresses[bookId]
    }

    // MARK: - DataPlugin

    func willDeleteBook(_ book: Book) {
        guard progresses[book.id] != nil else { return }
        progresses.removeValue(forKey: book.id)
        print("\(name): borrado el progreso de «\(book.title)»")
    }

    func didDeleteBook(id: UUID) {
        print("\(name): el libro \(id) ya no existe")
    }

    private func save() {
        let items = Array(progresses.values)
        _Concurrency.Task {
            do {
                try await storageProvider.saveProgresses(items)
            } catch {
                print("No se han guardado los progresos: \(error)")
            }
        }
    }
}
#endif