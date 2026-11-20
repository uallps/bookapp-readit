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
#if Categorias
    var categories: [String] = []
#endif

    var dueDate: Date?
#if Prioridades
    var priority: Priority?
#endif

#if Notas
    // Feature opcional: Notas y citas
    var notes: [Note] = []
#endif

#if ListaDeseos
    // Feature opcional: Lista de Deseos / Por comprar
    var isWishlist: Bool = false
#endif

    // Initializer base explícito
    init(
        id: UUID = UUID(),
        title: String,
        author: String? = nil,
        state: ReadingState = .pending,
        dueDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.state = state
        self.dueDate = dueDate
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, author, state, dueDate
#if Categorias
        case categories, category
#endif
#if Prioridades
        case priority
#endif
#if Notas
        case notes
#endif
#if ListaDeseos
        case isWishlist
#endif
    }

    // Decodificación defensiva sin romper los inicializadores ni la compatibilidad
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        title = try container.decode(String.self, forKey: .title)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        state = try container.decodeIfPresent(ReadingState.self, forKey: .state) ?? .pending

#if Categorias
        var decodedCategories = try container.decodeIfPresent([String].self, forKey: .categories) ?? []
        if let legacyCategory = try container.decodeIfPresent(String.self, forKey: .category) {
            decodedCategories.append(legacyCategory)
        }
        categories = Self.normalizedCategories(decodedCategories)
#endif
        dueDate = try container.decodeIfPresent(Date.self, forKey: .dueDate)

#if Prioridades
        priority = try container.decodeIfPresent(Priority.self, forKey: .priority)
#endif

#if Notas
        notes = try container.decodeIfPresent([Note].self, forKey: .notes) ?? []
#endif

#if ListaDeseos
        isWishlist = try container.decodeIfPresent(Bool.self, forKey: .isWishlist) ?? false
#endif
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(author, forKey: .author)
        try container.encode(state, forKey: .state)
#if Categorias
        try container.encode(categories, forKey: .categories)
#endif
        try container.encodeIfPresent(dueDate, forKey: .dueDate)
#if Prioridades
        try container.encodeIfPresent(priority, forKey: .priority)
#endif
#if Notas
        try container.encode(notes, forKey: .notes)
#endif
#if ListaDeseos
        try container.encode(isWishlist, forKey: .isWishlist)
#endif
    }

}

// Extensión con conveniencias cuando Prioridades está activo
#if Prioridades
extension Book {
    init(
        id: UUID = UUID(),
        title: String,
        author: String? = nil,
        state: ReadingState = .pending,
        dueDate: Date? = nil,
        priority: Priority? = nil
    ) {
        self.init(
            id: id,
            title: title,
            author: author,
            state: state,
            dueDate: dueDate
        )
        self.priority = priority
    }
}
#endif