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
#if AlertasContenido
    var hasSensitiveContent = false
#endif

#if FechaObjetivo
    // Fecha límite para terminar el libro (O2)
    var dueDate: Date?
#endif

#if ListaDeseos
    // Feature opcional: Lista de Deseos / Por comprar
    var isWishlist: Bool = false
#endif

#if Valoraciones
    // Valoración con estrellas y reseña (F4)
    var rating: BookRating = BookRating()
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
#if FechaObjetivo
        self.dueDate = dueDate
#endif
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, author, state
#if FechaObjetivo
        case dueDate
#endif
#if Categorias
        case categories, category
#endif
#if AlertasContenido
        case hasSensitiveContent
#endif
#if ListaDeseos
        case isWishlist
#endif
#if Valoraciones
        case rating
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
#if AlertasContenido
        hasSensitiveContent = try container.decodeIfPresent(Bool.self, forKey: .hasSensitiveContent) ?? false
#endif
#if FechaObjetivo
        dueDate = try container.decodeIfPresent(Date.self, forKey: .dueDate)
#endif

#if ListaDeseos
        isWishlist = try container.decodeIfPresent(Bool.self, forKey: .isWishlist) ?? false
#endif

#if Valoraciones
        rating = try container.decodeIfPresent(BookRating.self, forKey: .rating) ?? BookRating()
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
#if AlertasContenido
        try container.encode(hasSensitiveContent, forKey: .hasSensitiveContent)
#endif
#if FechaObjetivo
        try container.encodeIfPresent(dueDate, forKey: .dueDate)
#endif
#if ListaDeseos
        try container.encode(isWishlist, forKey: .isWishlist)
#endif
#if Valoraciones
        try container.encode(rating, forKey: .rating)
#endif
    }

}