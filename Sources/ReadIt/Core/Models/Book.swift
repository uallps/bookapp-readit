import Foundation

public struct Book: Identifiable, Codable, Sendable {
    public let id: UUID
    public var title: String
    public var author: String?
    public var status: ReadingStatus
    
    public init(id: UUID = UUID(), title: String, author: String? = nil, status: ReadingStatus = .pending) {
        self.id = id
        self.title = title
        self.author = author
        self.status = status
    }
}