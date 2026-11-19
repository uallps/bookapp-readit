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
    
    // Feature opcional: Fecha objetivo de finalización
    var dueDate: Date? 
    
#if Prioridades
    // Feature opcional: Prioridades
    var priority: Priority? 
#endif

#if Notas
    // Feature opcional: Notas y citas
    var notes: [Note] = []
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

    enum CodingKeys: String, CodingKey {
        case id, title, author, state, dueDate
#if Prioridades
        case priority
#endif
#if Notas
        case notes
#endif
    }

    // Decodificación defensiva sin romper los inicializadores
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.title = try container.decode(String.self, forKey: .title)
        self.author = try container.decodeIfPresent(String.self, forKey: .author)
        self.state = try container.decodeIfPresent(ReadingState.self, forKey: .state) ?? .pending
        self.dueDate = try container.decodeIfPresent(Date.self, forKey: .dueDate)

#if Prioridades
        self.priority = try container.decodeIfPresent(Priority.self, forKey: .priority)
#endif

#if Notas
        self.notes = try container.decodeIfPresent([Note].self, forKey: .notes) ?? []
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
        self.init(id: id, title: title, author: author, state: state, dueDate: dueDate)
        self.priority = priority
    }
}
#endif