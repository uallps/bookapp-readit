import Foundation

public enum ReadingStatus: String, Codable, CaseIterable, Sendable {
    case pending = "Pendiente"
    case reading = "Leyendo"
    case completed = "Leído"
}