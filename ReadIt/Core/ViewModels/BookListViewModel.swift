import Foundation
import Observation

@Observable
final class BookListViewModel {
    /// Cada cambio en la lista (marcar, añadir, borrar o editar en el detalle) se guarda.
    var books: [Book] = BookListViewModel.sampleBooks {
        didSet { save() }
    }

    private static var sampleBooks: [Book] {
#if Prioridades
        [
            Book(title: "El nombre del viento", author: "Patrick Rothfuss", state: .reading, priority: .high),
            Book(title: "Dune", author: "Frank Herbert", state: .pending, priority: .medium),
            Book(title: "1984", author: "George Orwell", state: .finished)
        ]
#else
        [
            Book(title: "El nombre del viento", author: "Patrick Rothfuss", state: .reading),
            Book(title: "Dune", author: "Frank Herbert", state: .pending),
            Book(title: "1984", author: "George Orwell", state: .finished)
        ]
#endif
    }

    @ObservationIgnored private let storageProvider: StorageProvider
    @ObservationIgnored private var loaded = false

    /// Por defecto guarda en JSON; en pruebas se le pasa un MockStorageProvider.
    init(storageProvider: StorageProvider = JSONStorageProvider()) {
        self.storageProvider = storageProvider
        _Concurrency.Task { await loadBooks() }
    }

    /// Carga los libros guardados, solo la primera vez que se llama.
    func loadBooks() async {
        guard !loaded else { return }
        loaded = true
        do {
            books = try await storageProvider.loadBooks()
        } catch {
            print("No se han cargado libros: \(error)")
        }
    }

    func updateState(id: UUID, to newState: ReadingState) {
        guard let index = books.firstIndex(where: { $0.id == id }) else { return }
        books[index].state = newState
    }

    func addBook() {
        books.append(Book(title: "Libro de ejemplo", state: .pending))
    }

    func removeBook(id: UUID) {
        books.removeAll { $0.id == id }
    }

    /// El libro con ese id, si sigue en la lista.
    func book(id: UUID) -> Book? {
        books.first { $0.id == id }
    }

    /// Sustituye el libro que tiene el mismo id (lo usa el detalle al editar).
    func updateBook(_ book: Book) {
        guard let index = books.firstIndex(where: { $0.id == book.id }) else { return }
        books[index] = book
    }

    /// Guarda la lista completa en disco.
    private func save() {
        let currentBooks = books
        _Concurrency.Task {
            do {
                try await storageProvider.saveBooks(books: currentBooks)
            } catch {
                print("No se han guardado los libros: \(error)")
            }
        }
    }
}