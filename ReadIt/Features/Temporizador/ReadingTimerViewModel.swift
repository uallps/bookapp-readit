#if Temporizador
import Foundation
import Observation

@Observable
final class ReadingTimerViewModel: FeaturePlugin {
    let name = "Temporizador de lectura"

    var elapsedSeconds: Int = 0
    var isRunning: Bool = false
    var totalAccumulatedSeconds: Int {
        didSet {
            defaults.set(totalAccumulatedSeconds, forKey: "timerTotalSeconds")
            defaults.synchronize()
        }
    }

    @ObservationIgnored private var timerTask: _Concurrency.Task<Void, Never>?
    @ObservationIgnored private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.totalAccumulatedSeconds = defaults.integer(forKey: "timerTotalSeconds")
    }

    var formattedElapsed: String {
        formatTime(elapsedSeconds)
    }

    var formattedTotal: String {
        formatTime(totalAccumulatedSeconds)
    }

    func toggle() {
        isRunning ? pause() : start()
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        timerTask = _Concurrency.Task {
            while !_Concurrency.Task.isCancelled {
                try? await _Concurrency.Task.sleep(nanoseconds: 1_000_000_000)
                guard !_Concurrency.Task.isCancelled else { break }
                elapsedSeconds += 1
            }
        }
    }

    func pause() {
        isRunning = false
        timerTask?.cancel()
        timerTask = nil
    }

    func reset() {
        pause()
        elapsedSeconds = 0
    }

    func saveSession() {
        guard elapsedSeconds > 0 else { return }
        totalAccumulatedSeconds += elapsedSeconds
        reset()
    }

    private func formatTime(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
#endif