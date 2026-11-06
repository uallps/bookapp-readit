/// Contrato de almacenamiento de libros. El ViewModel solo conoce este protocolo,
/// así que se puede cambiar dónde se guardan los libros sin tocarlo.
protocol StorageProvider {
    func loadBooks() async throws -> [Book]
    func saveBooks(books: [Book]) async throws
}
