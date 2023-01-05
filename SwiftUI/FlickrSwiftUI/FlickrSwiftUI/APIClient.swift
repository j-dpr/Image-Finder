import Foundation

class APIClient {
    
    private let flickrKey: String = "675894853ae8ec6c242fa4c077bcf4a0"
    
    
    /**
        TODO: Update method signature accordingly to perform network request and figure out how to display
            results in the appropriate ViewController
    */
    func fetch(query: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest"
        components.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: self.flickrKey),
            URLQueryItem(name: "text", value: query),
            URLQueryItem(name: "per_page", value: "20"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]

        guard let url = components.url else {
            print("Failed generate Flickr URL")
            let url = URL(string: "https://www.google.com")!
            return url
        }
                // TODO
        return url
    }
}
