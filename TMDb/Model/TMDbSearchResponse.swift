//
//  TMDbSearchResponse.swift
//  TMDb
//
//  Created by Alexander Losikov on 11/16/19.
//  Copyright © 2019 Alexander Losikov. All rights reserved.
//

import Foundation

struct TMDbSearchResponse {
    
    var movies: [TMDbMovie]?
    
}

extension TMDbSearchResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
    
}
