import Foundation

extension Date {
    static func changeStringDateFormat(releaseDate: String) -> String {
        let dateFormatter = DateFormatter()
        let newFormatter = ISO8601DateFormatter()
        guard let date = newFormatter.date(from: releaseDate) else { return "" }
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "d MMMM, yyyy"
        return dateFormatter.string(from: date)
    }
}
