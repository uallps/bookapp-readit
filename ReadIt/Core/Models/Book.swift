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
    
    // Feature opcional: Prioridades
    var priority: Priority? 
}