import Foundation

#if Notas
/// Modelo de datos para las notas o citas vinculadas a un libro.
public struct Note: Identifiable, Codable, Equatable {
    public let id: UUID
    public var text: String
    public var page: Int?
    public var dateAdded: Date

    public init(id: UUID = UUID(), text: String, page: Int? = nil, dateAdded: Date = Date()) {
        self.id = id
        self.text = text
        self.page = page
        self.dateAdded = dateAdded
    }
}
#endif