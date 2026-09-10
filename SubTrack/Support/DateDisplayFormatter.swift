import Foundation

/// Formats renewal dates consistently across the SubTrack interface.
enum DateDisplayFormatter {
    private static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }()

    private static let fullFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static func short(_ date: Date) -> String {
        shortFormatter.string(from: date)
    }

    static func full(_ date: Date) -> String {
        fullFormatter.string(from: date)
    }
}
