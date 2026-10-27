import Foundation

@MainActor
public class BookViewModel {
    public var books: [Book] = []
    
    public init() {
        loadSampleData()
    }
    
    public func addBook(title: String, author: String? = nil, status: ReadingStatus = .pending) {
        let newBook = Book(title: title, author: author, status: status)
        books.append(newBook)
    }
    
    public func updateStatus(for book: Book, newStatus: ReadingStatus) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index].status = newStatus
        }
    }
    
    public func deleteBook(id: UUID) {
        books.removeAll { $0.id == id }
    }
    
    private func loadSampleData() {
        books = [
            Book(title: "El Quijote", author: "Miguel de Cervantes", status: .completed),
            Book(title: "Cien años de soledad", author: "Gabriel García Márquez", status: .reading),
            Book(title: "Clean Code", author: "Robert C. Martin", status: .pending)
        ]
    }
}