import Foundation
import Observation

@Observable
final class BookListViewModel {
    /// Cada cambio en la lista (marcar, añadir, borrar o editar en el detalle) se guarda.
    var books: [Book] = [
        Book(title: "El nombre del viento", dueDate: Date(timeIntervalSince1970: 1_794_700_800), priority: .high),
        Book(title: "Dune", priority: .medium),
        Book(title: "1984")
    ] {
        didSet { save() }
    }

    @ObservationIgnored private let storageProvider: StorageProvider
    @ObservationIgnored private var loaded = false

    /// Por defecto guarda en JSON; en pruebas se le pasa un MockStorageProvider.
    init(storageProvider: StorageProvider = JSONStorageProvider()) {
        self.storageProvider = storageProvider
        _Concurrency.Task { await loadBooks() }
    }

    /// Carga los libros guardados, solo la primera vez que se llama.
    /// Si aún no hay fichero, se quedan los libros de ejemplo.
    func loadBooks() async {
        guard !loaded else { return }
        loaded = true
        do {
            books = try await storageProvider.loadBooks()
        } catch {
            print("No se han cargado libros: \(error)")
        }
    }

    func toggleCompletion(id: UUID) {
        guard let index = books.firstIndex(where: { $0.id == id }) else { return }
        books[index].isCompleted.toggle()
    }

    func addBook() {
        books.append(Book(title: "Libro de ejemplo"))
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

    /// Guarda la lista completa. `_Concurrency.Task` es la tarea asíncrona de Swift.
    private func save() {
        let books = books
        _Concurrency.Task {
            do {
                try await storageProvider.saveBooks(books: books)
            } catch {
                print("No se han guardado los libros: \(error)")
            }
        }
    }
}
