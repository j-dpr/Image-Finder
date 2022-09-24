//
//  List.swift
//  FlickrSwiftUI
//
//  Created by Jd on 23/09/22.
//

import Foundation

struct FlickrSearchResults: Codable {
    let photos: Photos
    let stat: String
}

struct Photos: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [Photo]
}
