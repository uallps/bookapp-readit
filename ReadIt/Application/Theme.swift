import SwiftUI

// El tema de la app: colores y estilos en un solo sitio, añadidos con extensiones.
// Para cambiar el aspecto se toca este fichero, no las vistas.

extension Color {
    /// Color principal de ReadIt.
    static let bookAccent = Color(red: 0.19, green: 0.38, blue: 0.58)
}

/// Estilo del texto secundario de las filas (fecha, prioridad).
struct CaptionStyle: ViewModifier {
    var color: Color = .secondary

    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(color)
    }
}

extension View {
    /// Aplica el estilo de texto secundario: `Text("…").bookCaption()`,
    /// o con otro color: `.bookCaption(color: .red)`.
    func bookCaption(color: Color = .secondary) -> some View {
        modifier(CaptionStyle(color: color))
    }
}

#if Prioridades
extension Priority {
    /// Color de cada prioridad. Solo existe en el producto con prioridades.
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .red
        }
    }
}
#endif
