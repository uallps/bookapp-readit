#if Categorias
import SwiftUI

struct CategoryManagementView: View {
    @Binding var book: Book
    let availableCategories: [String]

    @Environment(AppConfig.self) private var config
    @Environment(CategoriesViewModel.self) private var categoriesVM
    @State private var newCategory = ""

    var body: some View {
        if config.enableCategories {
            Section(header: Text("Crear categoría")) {
                TextField("Nombre de la categoría", text: $newCategory)
                Button("Añadir categoría") {
                    categoriesVM.addCategory(newCategory, to: book.id)
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
                    ScrollView(.horizontal) {
                        HStack(spacing: 8) {
                            ForEach(availableCategoriesToAdd, id: \.self) { category in
                                categoryButton(category)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }

            Section(header: Text("Categorías asignadas")) {
                let bookCategories = categoriesVM.categories(for: book.id)
                if bookCategories.isEmpty {
                    Text("Sin categorías")
                        .foregroundColor(.secondary)
                }

                ForEach(bookCategories, id: \.self) { category in
                    HStack {
                        Text(category)
                        Spacer()
                        Button("Quitar") {
                            categoriesVM.removeCategory(category, from: book.id)
                        }
                    }
                }
            }
        }
    }

    private var availableCategoriesToAdd: [String] {
        availableCategories.filter { category in
            !categoriesVM.categories(for: book.id).contains {
                $0.caseInsensitiveCompare(category) == .orderedSame
            }
        }
    }

    private func categoryButton(_ category: String) -> some View {
        Button(category) {
            categoriesVM.addCategory(category, to: book.id)
        }
        .fixedSize(horizontal: true, vertical: false)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Capsule().fill(Color.secondary.opacity(0.15)))
        .buttonStyle(.plain)
    }
}
#endif
