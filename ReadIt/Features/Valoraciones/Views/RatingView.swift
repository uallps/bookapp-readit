#if Valoraciones
import SwiftUI

struct RatingView: View {
    @Binding var rating: BookRating

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                ForEach(1..<6, id: \.self) { star in  //Aqui hago una modificacion por si no se aceptaran rangos cerrado  tenia 1...5
                    Button(star <= rating.stars ? "★" : "☆") {
                        rating.stars = (rating.stars == star) ? 0 : star
                    }
                    .foregroundColor(star <= rating.stars ? .yellow : .gray)
                }

                Spacer()

                Text(rating.stars > 0 ? "\(rating.stars) / 5" : "Sin valorar")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            TextField("Escribe tu reseña personal...", text: $rating.review)

            if rating.hasRating {
                Button("Borrar valoración") {
                    rating.stars = 0
                    rating.review = ""
                }
                .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }
}
#endif