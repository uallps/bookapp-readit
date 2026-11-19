import SwiftUI

struct BookListView: View {
    @State private var viewModel = BookListViewModel()
    @State private var selectedBookID: UUID?
    @State private var selectedCategory = CategoryFilter.all
    /// La configuración la crea la app y llega por el entorno: es la misma que edita Ajustes.
    @Environment(AppConfig.self) private var config

    var body: some View {
        NavigationStack {
            if let book = selectedBook {
                BookDetailView(book: binding(for: book), availableCategories: categories)
                    .toolbar {
                        ToolbarItem(placement: .leading) {
                            Button("<- Back") {
                                selectedBookID = nil
                            }
                        }
                        .frame(height: 48)
                    }
            } else {
                List {
                    Section(header: Text("Filtrar por categoría")) {
                        ScrollView(.horizontal) {
                            HStack(spacing: 8) {
                                categoryButton("Todas", filter: .all)
                                ForEach(categories, id: \.self) { category in
                                    categoryButton(category, filter: .category(category))
                                }
                            }
                        }
                    }

                    ForEach(filteredBooks) { book in
                        bookRow(book: book)
                    }
                }
                .toolbar {
                    Button("Añadir libro") {
                        viewModel.addBook()
                    }
                }
                .navigationTitle("Libros")
            }
        }
    }

    private var selectedBook: Book? {
        guard let selectedBookID else { return nil }
        return viewModel.book(id: selectedBookID)
    }

    private var categories: [String] {
        var result: [String] = []
        for category in Set(viewModel.books.flatMap(\.categories)).sorted()
        where !result.contains(where: { $0.caseInsensitiveCompare(category) == .orderedSame }) {
            result.append(category)
        }
        return result
    }

    private var filteredBooks: [Book] {
        guard case let .category(category) = selectedCategory,
              categories.contains(category) else { return viewModel.books }
        return viewModel.books.filter { book in
            book.categories.contains { $0.caseInsensitiveCompare(category) == .orderedSame }
        }
    }

    private func categoryButton(_ title: String, filter: CategoryFilter) -> some View {
        Button(action: { selectedCategory = filter }) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(selectedCategory == filter ? Color.bookAccent : Color.secondary.opacity(0.15))
                .foregroundColor(selectedCategory == filter ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    /// Una fila: enlace al detalle del libro, con menú contextual para borrarlo.
    private func bookRow(book: Book) -> some View {
        Button(action: { selectedBookID = book.id }) {
            BookRowView(
                book: book,
                showDueDates: config.showDueDates,
                showPriorities: config.showPriorities
            )
            .contextMenu {
                Button("Eliminar libro") {
                    viewModel.removeBook(id: book.id)
                }
            }
        }
    }

    /// Binding para que el detalle edite el libro a través del ViewModel.
    private func binding(for book: Book) -> Binding<Book> {
        Binding(
            get: { viewModel.book(id: book.id) ?? book },
            set: { viewModel.updateBook($0) }
        )
    }

    private enum CategoryFilter: Hashable {
        case all
        case category(String)
    }
}
