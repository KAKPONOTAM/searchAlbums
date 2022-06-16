import Foundation

extension Date {
    static func changeStringDateFormat(releaseDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatter.dateStyle = .medium
        guard let date = dateFormatter.date(from: releaseDate) else { return "idk what is this date" }
        dateFormatter.dateFormat = "d MMMM, yyyy"
        return dateFormatter.string(from: date)
    }
}
