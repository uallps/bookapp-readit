/// Almacenamiento en memoria, para pruebas y vistas previas: no escribe nada en disco.
final class MockStorageProvider: StorageProvider {
    private var storedBooks: [Book] = [
        Book(title: "Libro de prueba 1"), // Por defecto será state: .pending
        // Cambiamos isCompleted por state y añadimos un autor de prueba
        Book(title: "Libro de prueba 2", author: "Autor Desconocido", state: .finished)
    ]

    func loadBooks() async throws -> [Book] {
        storedBooks
    }

    func saveBooks(books: [Book]) async throws {
        storedBooks = books
    }
}