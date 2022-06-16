import Foundation

struct TracksData: Decodable {
    let results: [Track]
}

struct Track: Decodable {
    var trackName: String?
}
