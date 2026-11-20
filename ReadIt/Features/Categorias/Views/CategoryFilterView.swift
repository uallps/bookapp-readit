#if Categorias
import SwiftUI

struct CategoryFilterView: View {
    @Environment(AppConfig.self) private var config

    let categories: [String]
    @Binding var selectedCategory: String?
    let isAllSelected: Bool
    let onSelection: () -> Void

    var body: some View {
        if config.enableCategories {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    categoryButton("Todas", category: nil, isSelected: isAllSelected)

                    ForEach(categories, id: \.self) { category in
                        categoryButton(
                            category,
                            category: category,
                            isSelected: selectedCategory == category
                        )
                    }
                }
            }
        }
    }

    private func categoryButton(_ title: String, category: String?, isSelected: Bool) -> some View {
        Button {
            selectedCategory = category
            onSelection()
        } label: {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(isSelected ? Color.bookAccent : Color.secondary.opacity(0.15))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
#endif
