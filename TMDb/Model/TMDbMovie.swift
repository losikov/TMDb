//
//  TMDbMovie.swift
//  TMDb
//
//  Created by Alexander Losikov on 11/16/19.
//  Copyright © 2019 Alexander Losikov. All rights reserved.
//

import Foundation

struct TMDbMovie {
    
    let title: String?
    let overview: String?
    let posterPath: String?
        
    func imageUrlString() -> String? {
        guard let posterPath = posterPath else { return nil }
        
        return "https://image.tmdb.org/t/p/w600_and_h900_bestv2/" + posterPath
    }
    
}

extension TMDbMovie: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case posterPath = "poster_path"
    }
    
}
