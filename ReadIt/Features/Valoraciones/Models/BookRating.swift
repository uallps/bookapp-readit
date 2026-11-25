#if Valoraciones
import Foundation

/// Modelo de valoración personal de un libro (1 a 5 estrellas y reseña).
struct BookRating: Codable, Equatable {
    /// 0 significa sin valorar; de 1 a 5 son las estrellas.
    var stars: Int = 0
    var review: String = ""

    var hasRating: Bool {
        stars > 0 || !review.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
#endif