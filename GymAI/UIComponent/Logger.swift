import UIKit

enum LogType: String {
    case error
    case warning
    case success
    case action
    case canceled
    case test
    case debug
    case other
}

class Logger {
    private init() {}

    static func log(_ logType: LogType, _ message: String, _ output: UITextView? = nil, _ fileName: String = #file, _ line : Int = #line) {
        var currentLogType = ""
        switch logType {
        case LogType.error:
            currentLogType = "!!!📕 Error"
        case LogType.warning:
            currentLogType = "!!!📙 Warning"
        case LogType.success:
            currentLogType = "!!!📗 Success"
        case LogType.action:
            currentLogType = "!!!📘 Action"
        case LogType.canceled:
            currentLogType = "!!!📓 Cancelled"
        case LogType.test:
            currentLogType = "!!!🔖 Test"
        case LogType.debug:
            currentLogType = "!!!📒 Debug"
        case LogType.other:
            currentLogType = "!!!📒 other"
        }
        let loggerString = "\n\(formattedDate()) \(currentLogType) \(getFileName(fileName)) \(line): \(message)\n"
        print(loggerString)
    }

    static private func getFileName(_ path: String) -> String {
        return (path as NSString).lastPathComponent
    }

    static private func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        return "\(dateFormatter.string(from: Date()))"
    }
}
