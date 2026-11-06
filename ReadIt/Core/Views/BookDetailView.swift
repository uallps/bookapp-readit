import SwiftUI

/// Detalle de un libro. Recibe un enlace (@Binding) al libro de la lista:
/// lo que se edita aquí cambia el libro del ViewModel, sin copias.
struct BookDetailView: View {
    @Binding var book: Book

    var body: some View {
        Form {
            TextField("Título del libro", text: $book.title)
            Toggle("Leído", isOn: $book.isCompleted)
        }
        .navigationTitle(book.title)
    }
}
