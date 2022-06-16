import Foundation
import UIKit

class NetworkManager {
    class func getAlbums(searchAlbum: String, completion: @escaping (AlbumData) -> ()) {
        let searchString = searchAlbum.replacingOccurrences(of: " ", with: "+")
        let urlString = "https://itunes.apple.com/search?entity=album&attribute=albumTerm&offset=0&limit=100&term=\(searchString)"
        guard let url = URL(string: urlString) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            if error == nil,
               let data = data {
                do {
                    let album = try JSONDecoder().decode(AlbumData.self, from: data)
                    DispatchQueue.main.async {
                        completion(album)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        dataTask.resume()
    }
    
    class func getAlbumTracks (collectionId: Int, completion: @escaping (TracksData) -> ()) {
        let urlString = "https://itunes.apple.com/lookup?entity=song&id=\(collectionId)"
        guard let url = URL(string: urlString) else { return }
        let dataTask =  URLSession.shared.dataTask(with: url) { data, _, error in
            if error == nil,
               let data = data {
                do {
                    let tracks = try JSONDecoder().decode(TracksData.self, from: data)
                    DispatchQueue.main.async {
                        completion(tracks)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        dataTask.resume()
    }
    
    class func getAlbumImageFromData(urlString: String, completion: @escaping(UIImage) -> ()) {
        DispatchQueue.global().async {
            guard let url = URL(string: urlString) else { return }
            
            if let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    guard let albumImage = UIImage(data: imageData) else { return }
                    completion(albumImage)
                }
            }
        }
    }
}
