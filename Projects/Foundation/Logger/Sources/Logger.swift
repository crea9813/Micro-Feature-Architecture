import Foundation
import OSLog

public extension Logger {
    static var subsystem = Bundle.main.bundleIdentifier!
    
    static let ui = Logger.init(subsystem: subsystem, category: "UI")
    static let api = Logger.init(subsystem: subsystem, category: "API")
}

public enum OSLogCategory: String {
    case ui
    case api
}

public class SMLogger {
    public static func log(category: OSLogCategory, level: OSLogType, message: String) {
        switch category {
        case .api: Logger.api.log(level: level, "\(message)")
        case .ui: Logger.ui.log(level: level, "\(message)")
        }
    }
}
