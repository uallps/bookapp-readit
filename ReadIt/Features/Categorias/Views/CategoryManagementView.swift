#if Categorias
import SwiftUI

struct CategoryManagementView: View {
    @Binding var book: Book
    let availableCategories: [String]

    @Environment(AppConfig.self) private var config
    @State private var newCategory = ""

    var body: some View {
        if config.enableCategories {
            Section(header: Text("Crear categoría")) {
                TextField("Nombre de la categoría", text: $newCategory)
                Button("Añadir categoría") {
                    book.addCategory(newCategory)
                    newCategory = ""
                }
                .disabled(newCategory.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            Section(header: Text("Añadir categoría existente")) {
                if availableCategories.isEmpty {
                    Text("Todavía no hay categorías en la biblioteca")
                        .foregroundColor(.secondary)
                } else if availableCategoriesToAdd.isEmpty {
                    Text("Este libro ya tiene todas las categorías existentes")
                        .foregroundColor(.secondary)
                } else {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 100), alignment: .leading)],
                        alignment: .leading,
                        spacing: 8
                    ) {
                        ForEach(availableCategoriesToAdd, id: \.self) { category in
                            Button(category) {
                                book.addCategory(category)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color.secondary.opacity(0.15)))
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }

            Section(header: Text("Categorías asignadas")) {
                if book.categories.isEmpty {
                    Text("Sin categorías")
                        .foregroundColor(.secondary)
                }

                ForEach(book.categories, id: \.self) { category in
                    HStack {
                        Text(category)
                        Spacer()
                        Button("Quitar") {
                            book.removeCategory(category)
                        }
                    }
                }
            }
        }
    }

    private var availableCategoriesToAdd: [String] {
        availableCategories.filter { category in
            !book.categories.contains {
                $0.caseInsensitiveCompare(category) == .orderedSame
            }
        }
    }
}
#endif
