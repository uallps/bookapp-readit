import Foundation

/// Estado de lectura con los 3 valores obligatorios del Core
enum ReadingState: String, Codable, CaseIterable {
    case pending = "Pendiente"
    case reading = "Leyendo"
    case finished = "Terminado"
}

/// Codable: el libro se puede guardar y leer en JSON.
struct Book: Identifiable, Codable {
    var id = UUID()
    var title: String
    var author: String?
    var state: ReadingState = .pending
    var categories: [String] = []

    var dueDate: Date?
#if Prioridades
    var priority: Priority?
#endif

    private enum CodingKeys: String, CodingKey {
        case id, title, author, state, categories, category, dueDate, priority
    }

    init(
        id: UUID = UUID(),
        title: String,
        author: String? = nil,
        state: ReadingState = .pending,
        categories: [String] = [],
        dueDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.state = state
        self.categories = Self.normalizedCategories(categories)
        self.dueDate = dueDate
    }

#if Prioridades
    init(
        id: UUID = UUID(),
        title: String,
        author: String? = nil,
        state: ReadingState = .pending,
        categories: [String] = [],
        dueDate: Date? = nil,
        priority: Priority
    ) {
        self.init(
            id: id,
            title: title,
            author: author,
            state: state,
            categories: categories,
            dueDate: dueDate
        )
        self.priority = priority
    }
#endif

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        title = try container.decode(String.self, forKey: .title)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        state = try container.decodeIfPresent(ReadingState.self, forKey: .state) ?? .pending
        var decodedCategories = try container.decodeIfPresent([String].self, forKey: .categories) ?? []
        if let legacyCategory = try container.decodeIfPresent(String.self, forKey: .category) {
            decodedCategories.append(legacyCategory)
        }
        categories = Self.normalizedCategories(decodedCategories)
        dueDate = try container.decodeIfPresent(Date.self, forKey: .dueDate)
#if Prioridades
        priority = try container.decodeIfPresent(Priority.self, forKey: .priority)
#endif
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(author, forKey: .author)
        try container.encode(state, forKey: .state)
        try container.encode(categories, forKey: .categories)
        try container.encodeIfPresent(dueDate, forKey: .dueDate)
#if Prioridades
        try container.encodeIfPresent(priority, forKey: .priority)
#endif
    }

    mutating func addCategory(_ category: String) {
        let normalized = category.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty,
              !categories.contains(where: { $0.caseInsensitiveCompare(normalized) == .orderedSame })
        else { return }
        categories.append(normalized)
    }

    mutating func removeCategory(_ category: String) {
        categories.removeAll { $0 == category }
    }

    private static func normalizedCategories(_ categories: [String]) -> [String] {
        var result: [String] = []
        for category in categories {
            let normalized = category.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !normalized.isEmpty,
                  !result.contains(where: { $0.caseInsensitiveCompare(normalized) == .orderedSame })
            else { continue }
            result.append(normalized)
        }
        return result
    }
}