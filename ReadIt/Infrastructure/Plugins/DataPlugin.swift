import Foundation

/// Plugin con datos propios ligados a los libros (patrón observador al borrar).
protocol DataPlugin: FeaturePlugin {
    func willDeleteBook(_ book: Book)
    func didDeleteBook(id: UUID)
}