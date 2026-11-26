import Foundation

/// Registro Singleton de plugins. El núcleo habla con él, nunca con un plugin concreto.
final class PluginRegistry {
    static let shared = PluginRegistry()

    private(set) var plugins: [FeaturePlugin] = []

    private init() {}

    func register(_ plugin: FeaturePlugin) {
        guard !plugins.contains(where: { $0 === plugin }) else { return }
        plugins.append(plugin)
        print("Plugin registrado: \(plugin.name)")
    }

    private var dataPlugins: [DataPlugin] {
        plugins.compactMap { $0 as? DataPlugin }
    }

    func notifyBookWillBeDeleted(_ book: Book) {
        for plugin in dataPlugins {
            plugin.willDeleteBook(book)
        }
    }

    func notifyBookDidDelete(id: UUID) {
        for plugin in dataPlugins {
            plugin.didDeleteBook(id: id)
        }
    }
}