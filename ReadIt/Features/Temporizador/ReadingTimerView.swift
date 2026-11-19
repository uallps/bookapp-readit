#if Temporizador
import SwiftUI

struct ReadingTimerView: View {
    @Environment(ReadingTimerViewModel.self) private var timerVM

    var body: some View {
        VStack(spacing: 24) {
            Text("Sesión de lectura")
                .font(.title2)
                .bold()

            Text(timerVM.formattedElapsed)
                .font(.largeTitle)
                .bold()
                .padding(.vertical, 12)

            HStack(spacing: 16) {
                Button(timerVM.isRunning ? "Pausar" : "Iniciar") {
                    timerVM.toggle()
                }
                .buttonStyle(.borderedProminent)

                Button("Reiniciar") {
                    timerVM.reset()
                }
                .buttonStyle(.bordered)
                .disabled(timerVM.elapsedSeconds == 0 && !timerVM.isRunning)

                Button("Guardar sesión") {
                    timerVM.saveSession()
                }
                .buttonStyle(.bordered)
                .disabled(timerVM.elapsedSeconds == 0)
            }

            Divider()
                .padding(.vertical, 8)

            VStack(spacing: 6) {
                Text("Tiempo total registrado")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(timerVM.formattedTotal)
                    .font(.title3)
                    .bold()
            }

            Spacer()
        }
        .padding(24)
        .navigationTitle("Temporizador")
    }
}
#endif