/// Almacenamiento en memoria, para pruebas y vistas previas: no escribe nada en disco.
final class MockStorageProvider: StorageProvider {
    private var storedBooks: [Book] = [
        Book(title: "Libro de prueba 1"),
        Book(title: "Libro de prueba 2", isCompleted: true)
    ]

    func loadBooks() async throws -> [Book] {
        storedBooks
    }

    func saveBooks(books: [Book]) async throws {
        storedBooks = books
    }
}
