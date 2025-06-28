import Foundation
import ModelIO

class AssetLoader {
    static let shared = AssetLoader()
    private let cache: URLCache

    private init() {
        cache = URLCache(memoryCapacity: 64 * 1024 * 1024,
                          diskCapacity: 512 * 1024 * 1024)
        URLCache.shared = cache
    }

    private func resolve(_ urlString: String) -> URL? {
        if urlString.hasPrefix("ll://") {
            let path = urlString.dropFirst(5)
            return URL(string: "https://assets.example.com/\(path)")
        }
        return URL(string: urlString)
    }

    func loadTexture(from urlString: String, completion: @escaping (MDLTexture?) -> Void) {
        guard let url = resolve(urlString) else { completion(nil); return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            var texture: MDLTexture? = nil
            if let data = data {
                texture = MDLTexture(data: data)
            }
            completion(texture)
        }
        task.resume()
    }

    func loadMesh(from urlString: String, completion: @escaping (MDLMesh?) -> Void) {
        guard let url = resolve(urlString) else { completion(nil); return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        let task = URLSession.shared.downloadTask(with: request) { localURL, _, _ in
            var mesh: MDLMesh? = nil
            if let localURL = localURL {
                let asset = MDLAsset(url: localURL)
                mesh = asset.object(at: 0) as? MDLMesh
            }
            completion(mesh)
        }
        task.resume()
    }
}
