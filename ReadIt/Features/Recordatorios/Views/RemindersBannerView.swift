#if Recordatorios && !FechaObjetivo
#error("O3 (Recordatorios) requiere activar también el trait FechaObjetivo (O2)")
#endif

#if Recordatorios && FechaObjetivo
import SwiftUI

struct RemindersBannerView: View {
    let books: [Book]
    @State private var readToday = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Aviso de hábito diario
            HStack {
                Text(readToday ? "Hábito diario completado" : "Recuerda leer un rato hoy")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(readToday ? .green : .primary)

                Spacer()

                Button(readToday ? "Hecho" : "Marcar") {
                    readToday.toggle()
                }
            }

            // Alertas para libros no terminados que vencen pronto o ya vencieron
            if urgentBooks.isEmpty {
                Text("No tienes libros próximos a vencer")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                ForEach(urgentBooks) { book in
                    if let dueDate = book.dueDate {
                        HStack {
                            Text(book.title)
                                .font(.caption)
                                .bold()
                            Spacer()
                            Text(alertText(for: dueDate))
                                .font(.caption)
                                .foregroundColor(alertColor(for: dueDate))
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }

    // Libros pendientes o leyendo cuya fecha límite ya pasó o falta <= 3 días
    private var urgentBooks: [Book] {
        books.filter { book in
            guard book.state != .finished, let dueDate = book.dueDate else { return false }
            return daysUntil(dueDate) <= 3
        }
    }

    private func daysUntil(_ date: Date) -> Int {
        let startToday = Calendar.current.startOfDay(for: Date())
        let startTarget = Calendar.current.startOfDay(for: date)
        return Calendar.current.dateComponents([.day], from: startToday, to: startTarget).day ?? 0
    }

    private func alertText(for date: Date) -> String {
        let days = daysUntil(date)
        if days < 0 {
            return "Vencido hace \(abs(days)) día(s)"
        } else if days == 0 {
            return "Vence hoy"
        } else {
            return "Vence en \(days) día(s)"
        }
    }

    private func alertColor(for date: Date) -> Color {
        daysUntil(date) < 0 ? .red : .orange
    }
}
#endif