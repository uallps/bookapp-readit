#if FechaObjetivo
import SwiftUI

struct DueDateView: View {
    @Binding var dueDate: Date?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Toggle("Activar fecha objetivo", isOn: Binding(
                get: { dueDate != nil },
                set: { enabled in
                    if enabled {
                        // Por defecto ponemos 7 días desde hoy
                        dueDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
                    } else {
                        dueDate = nil
                    }
                }
            ))

            if let date = dueDate {
                Text("Fecha límite: \(date.formatted(date: .abbreviated, time: .omitted))")
                    .font(.subheadline)
                    .bold()

                Text(remainingText(for: date))
                    .font(.caption)
                    .foregroundColor(remainingColor(for: date))

                HStack(spacing: 8) {
                    Button("-7 días") { adjustDays(-7) }
                    Button("-1 día") { adjustDays(-1) }
                    Button("+1 día") { adjustDays(1) }
                    Button("+7 días") { adjustDays(7) }
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func adjustDays(_ days: Int) {
        let base = dueDate ?? Date()
        dueDate = Calendar.current.date(byAdding: .day, value: days, to: base)
    }

    private func remainingDays(for date: Date) -> Int {
        let startToday = Calendar.current.startOfDay(for: Date())
        let startTarget = Calendar.current.startOfDay(for: date)
        return Calendar.current.dateComponents([.day], from: startToday, to: startTarget).day ?? 0
    }

    private func remainingText(for date: Date) -> String {
        let days = remainingDays(for: date)
        if days < 0 {
            return "Vencida hace \(abs(days)) día(s)"
        } else if days == 0 {
            return "Vence hoy"
        } else {
            return "Quedan \(days) día(s)"
        }
    }

    private func remainingColor(for date: Date) -> Color {
        let days = remainingDays(for: date)
        if days < 0 { return .red }
        if days <= 3 { return .orange }
        return .secondary
    }
}
#endif