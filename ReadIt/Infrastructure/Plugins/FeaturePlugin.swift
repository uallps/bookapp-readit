import Foundation

/// Protocolo base para cualquier plugin de ReadIt.
protocol FeaturePlugin: AnyObject {
    var name: String { get }
}