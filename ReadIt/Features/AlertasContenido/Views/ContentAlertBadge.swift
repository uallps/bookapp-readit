#if AlertasContenido
import SwiftUI

struct ContentAlertBadge: View {
    @Environment(AppConfig.self) private var config

    let isSensitive: Bool

    var body: some View {
        if config.enableContentAlerts, isSensitive {
            Text("+18")
                .font(.caption2)
                .bold()
                .padding(.horizontal, 7)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color(red: 0.62, green: 0.06, blue: 0.06))
                )
                .foregroundColor(.white)
        }
    }
}
#endif
