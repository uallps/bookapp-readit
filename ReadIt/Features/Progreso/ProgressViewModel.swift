#if Progreso
import Foundation
import Observation

/// Modelo de datos independiente para F1 (Progreso)
struct BookProgress: Codable {
    let bookId: UUID
    var currentPage: Int
    var totalPages: Int
    
    var percentage: Double {
        guard totalPages > 0 else { return 0 }
        return Double(currentPage) / Double(totalPages)
    }
}

/// ViewModel exclusivo para gestionar el progreso
@Observable
final class ProgressViewModel {
    // Diccionario para buscar rápido el progreso de un libro por su ID
    var progresses: [UUID: BookProgress] = [:]
    
    func updateProgress(bookId: UUID, current: Int, total: Int) {
        progresses[bookId] = BookProgress(bookId: bookId, currentPage: current, totalPages: total)
    }
    
    func getProgress(bookId: UUID) -> BookProgress? {
        return progresses[bookId]
    }
}
#endif