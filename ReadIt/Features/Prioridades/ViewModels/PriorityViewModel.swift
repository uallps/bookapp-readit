#if Prioridades
import Foundation
import Observation

@Observable
final class PriorityViewModel: DataPlugin {
    let name = "Prioridad de lectura"

    private(set) var items: [BookPriority] = [] {
        didSet { save() }
    }

    @ObservationIgnored private let storageProvider: PriorityStorageProvider
    @ObservationIgnored private var loaded = false

    init(storageProvider: PriorityStorageProvider = JSONPriorityStorageProvider()) {
        self.storageProvider = storageProvider
        _Concurrency.Task { await load() }
    }

    func load() async {
        guard !loaded else { return }
        loaded = true
        do {
            items = try await storageProvider.loadPriorities()
        } catch {
            print("No se han cargado las prioridades: \(error)")
        }
    }

    func getPriority(bookId: UUID) -> Priority? {
        items.first { $0.bookId == bookId }?.priority
    }

    func setPriority(_ priority: Priority?, for bookId: UUID) {
        var updated = items.filter { $0.bookId != bookId }
        if let priority {
            updated.append(BookPriority(bookId: bookId, priority: priority))
        }
        items = updated
    }

    // MARK: - DataPlugin

    func willDeleteBook(_ book: Book) {
        guard getPriority(bookId: book.id) != nil else { return }
        setPriority(nil, for: book.id)
        print("\(name): borrada la prioridad de «\(book.title)»")
    }

    func didDeleteBook(id: UUID) {
        print("\(name): el libro \(id) ya no existe")
    }

    private func save() {
        let snapshot = items
        _Concurrency.Task {
            do {
                try await storageProvider.savePriorities(snapshot)
            } catch {
                print("No se han guardado las prioridades: \(error)")
            }
        }
    }
}
#endif