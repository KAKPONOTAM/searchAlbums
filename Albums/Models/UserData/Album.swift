import Foundation

struct AlbumData: Decodable {
    let results: [Album]
}

struct Album: Decodable {
    let artistName: String
    var artworkUrl100: String
    let collectionId: Int
    let collectionName: String
    let country: String
    let primaryGenreName: String
    let releaseDate: String
    let trackCount: Int
}

