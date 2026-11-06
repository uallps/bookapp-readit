import SwiftUI

struct BookListView: View {
    @State private var viewModel = BookListViewModel()
    /// La configuración la crea la app y llega por el entorno: es la misma que edita Ajustes.
    @Environment(AppConfig.self) private var config

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.books) { book in
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

    /// Una fila: enlace al detalle del libro, con menú contextual para borrarlo.
    private func bookRow(book: Book) -> some View {
        NavigationLink(destination: BookDetailView(book: binding(for: book))) {
            BookRowView(
                book: book,
                showDueDates: config.showDueDates,
                showPriorities: config.showPriorities,
                toggleCompletion: { viewModel.toggleCompletion(id: book.id) }
            )
            .contextMenu {
                Button("Eliminar libro") {
                    viewModel.removeBook(id: book.id)
                }
            }
        }
    }

    /// Un enlace (Binding) para que el detalle edite el libro. No toca los datos:
    /// leer y escribir se traducen a métodos del ViewModel.
    private func binding(for book: Book) -> Binding<Book> {
        Binding(
            get: { viewModel.book(id: book.id) ?? book },
            set: { viewModel.updateBook($0) }
        )
    }
}
