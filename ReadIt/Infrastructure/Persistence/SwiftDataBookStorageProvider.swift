#if canImport(SwiftData)
import Foundation
import SwiftData

/// Modelo de base de datos para SwiftData. `Book` sigue siendo un struct.
@Model
final class BookEntity {
    @Attribute(.unique) var id: UUID
    var title: String
    var author: String?
    var state: ReadingState
    var position: Int

#if AlertasContenido
    var hasSensitiveContent: Bool
#endif
#if FechaObjetivo
    var dueDate: Date?
#endif
#if Valoraciones
    var rating: BookRating
#endif

    init(book: Book, position: Int) {
        self.id = book.id
        self.title = book.title
        self.author = book.author
        self.state = book.state
        self.position = position
#if AlertasContenido
        self.hasSensitiveContent = book.hasSensitiveContent
#endif
#if FechaObjetivo
        self.dueDate = book.dueDate
#endif
#if Valoraciones
        self.rating = book.rating
#endif
    }

    func update(from book: Book, position: Int) {
        self.title = book.title
        self.author = book.author
        self.state = book.state
        self.position = position
#if AlertasContenido
        self.hasSensitiveContent = book.hasSensitiveContent
#endif
#if FechaObjetivo
        self.dueDate = book.dueDate
#endif
#if Valoraciones
        self.rating = book.rating
#endif
    }

    var book: Book {
        var result = Book(
            id: id,
            title: title,
            author: author,
            state: state
        )
#if AlertasContenido
        result.hasSensitiveContent = hasSensitiveContent
#endif
#if FechaObjetivo
        result.dueDate = dueDate
#endif
#if Valoraciones
        result.rating = rating
#endif
        return result
    }
}

/// Guarda los libros en una base de datos de SwiftData (`ReadIt.store`).
final class SwiftDataBookStorageProvider: StorageProvider {
    static let shared = SwiftDataBookStorageProvider()

    private let container: ModelContainer

    private init() {
        do {
            container = try ModelContainer(
                for: BookEntity.self,
                configurations: ModelConfiguration("ReadIt")
            )
        } catch {
            fatalError("No se ha podido abrir el almacén de SwiftData: \(error)")
        }
    }

    private var context: ModelContext { container.mainContext }

    func loadBooks() async throws -> [Book] {
        let byPosition = FetchDescriptor<BookEntity>(sortBy: [SortDescriptor(\.position)])
        return try context.fetch(byPosition).map(\.book)
    }

    func saveBooks(books: [Book]) async throws {
        var stored: [UUID: BookEntity] = [:]
        for entity in try context.fetch(FetchDescriptor<BookEntity>()) {
            stored[entity.id] = entity
        }

        for (position, book) in books.enumerated() {
            if let entity = stored.removeValue(forKey: book.id) {
                entity.update(from: book, position: position)
            } else {
                context.insert(BookEntity(book: book, position: position))
            }
        }

        for entity in stored.values {
            context.delete(entity)
        }

        try context.save()
    }
}
#endif