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
#if os(macOS)
                        ToolbarItem(placement: .navigation) {
                            backButton
                        }
#elseif os(iOS)
                        ToolbarItem(placement: .navigationBarLeading) {
                            backButton
                        }
#else
                        ToolbarItem(placement: .leading) {
                            backButton
                        }
#endif
                    }
            } else {
                List {
                    Section(header: Text("Filtrar por categoría")) {
                        ScrollView(.horizontal) {
                            HStack(spacing: 8) {
                                categoryButton("Todas", filter: .all)

#if ListaDeseos
                                if config.enableWishlist {
                                    categoryButton("Wishlist", filter: .wishlist)
                                }
#endif

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
        switch selectedCategory {
        case .all:
            return viewModel.books

#if ListaDeseos
        case .wishlist:
            return viewModel.books.filter { $0.isWishlist }
#endif

        case .category(let category):
            guard categories.contains(category) else { return viewModel.books }
            return viewModel.books.filter { book in
                book.categories.contains { $0.caseInsensitiveCompare(category) == .orderedSame }
            }
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

    /// Fila con control de estado, acceso al detalle y menú contextual.
    private func bookRow(book: Book) -> some View {
        HStack(spacing: 8) {
            Button {
                let newState: ReadingState = book.state == .finished ? .pending : .finished
                viewModel.updateState(id: book.id, to: newState)
            } label: {
                Image(systemName: book.state == .finished ? "checkmark.circle.fill" : "circle")
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(book.state == .finished ? "Marcar como pendiente" : "Marcar como terminado")

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
            .buttonStyle(.plain)
        }
    }

    private var backButton: some View {
        Button("<- Back") {
            selectedBookID = nil
        }
        .frame(height: 48)
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
#if ListaDeseos
        case wishlist
#endif
        case category(String)
    }
}