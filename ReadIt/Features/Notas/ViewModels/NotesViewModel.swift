#if Notas
import Foundation
import Observation

@Observable
final class NotesViewModel: DataPlugin {
    let name = "Notas y citas"

    private(set) var items: [BookNotes] = [] {
        didSet { save() }
    }

    @ObservationIgnored private let storageProvider: NotesStorageProvider
    @ObservationIgnored private var loaded = false

    init(storageProvider: NotesStorageProvider = JSONNotesStorageProvider()) {
        self.storageProvider = storageProvider
        _Concurrency.Task { await load() }
    }

    func load() async {
        guard !loaded else { return }
        loaded = true
        do {
            items = try await storageProvider.loadNotes()
        } catch {
            print("No se han cargado las notas: (error)")
        }
    }

    func getNotes(bookId: UUID) -> [Note] {
        items.first { $0.bookId == bookId }?.notes ?? []
    }

    func setNotes(_ notes: [Note], for bookId: UUID) {
        var updated = items.filter { $0.bookId != bookId }
        if !notes.isEmpty {
            updated.append(BookNotes(bookId: bookId, notes: notes))
        }
        items = updated
    }

    // MARK: - DataPlugin

    func willDeleteBook(_ book: Book) {
        guard !getNotes(bookId: book.id).isEmpty else { return }
        setNotes([], for: book.id)
        print("\(name): borradas las notas de «\(book.title)»")
    }

    func didDeleteBook(id: UUID) {
        print("\(name): el libro \(id) ya no existe")
    }

    private func save() {
        let snapshot = items
        _Concurrency.Task {
            do {
                try await storageProvider.saveNotes(snapshot)
            } catch {
                print("No se han guardado las notas: \(error)")
            }
        }
    }
}
#endif