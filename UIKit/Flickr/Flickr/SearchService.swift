//
//  SearchService.swift
//  Flickr
//
//  Created by Jd on 22/09/22.
//

import Foundation

protocol SearchServiceDelegate {
    func addItem(_ item: Photo)
    func updateSource()
}

class SearchService {
    
    var delegate: SearchServiceDelegate?
    
    func request(_ endpoint: URL){
        print(endpoint.absoluteString)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: endpoint) { (data, response, error) in
            if error != nil  {
                print(error!)
                return
            }
            
            if let safeData = data {
                self.parseJson(safeData)
            }
        }
        
        task.resume()
    }
    
    func parseJson (_ response: Data){
        do{
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(FlickrSearchResults.self, from: response)
            
            //let object = FlickrSearchResults(photos: decoderData.photos, stat: decoderData.stat)
            
            if decodedData.stat == "ok" {
                
                if delegate != nil{
                    for item in decodedData.photos.photo {
                        let newItem = Photo(id: item.id, farm: item.farm, server: item.server, secret: item.secret)
                        delegate?.addItem(newItem)
                    }
                    delegate?.updateSource()
                }
                
            }
           
        }catch{
            print(error)
        }
        
    }
    
}
