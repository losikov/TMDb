//
//  TMDbSearch.swift
//  TMDb
//
//  Created by Alexander Losikov on 11/16/19.
//  Copyright © 2019 Alexander Losikov. All rights reserved.
//

import UIKit

let apiKey = "b16d348937f12c42cea0f7e2dcfdf073"

struct TMDbNameSearchResponse {
    
    let name: String
    let movies: [TMDbMovie]
    
}

class TMDbNameSearchResultHolder {
    
    let data: TMDbNameSearchResponse
    
    init(data: TMDbNameSearchResponse) {
        self.data = data
    }
    
}

class TMDbSearch {
    
    private let tmdbNameSearchCache = NSCache<NSString, TMDbNameSearchResultHolder>()
    
    enum Error: Swift.Error {
        case invalidAPIResponse
    }
        
    func search(for name: String,
                completionHandler: @escaping (TMDbResponse<TMDbNameSearchResponse>) -> Void) {
        if let holder = tmdbNameSearchCache.object(forKey: NSString(string: name)) {
            completionHandler(TMDbResponse.data(holder.data))
            return
        }
        
        guard let searchURL = searchURL(for: name) else {
            completionHandler(TMDbResponse.error(Error.invalidAPIResponse))
            return
        }
        
        URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
            if let error = error {
                print (error.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler(TMDbResponse.error(error))
                }
                return
            }
            
            guard
                let _ = response as? HTTPURLResponse,
                let data = data
                else {
                    DispatchQueue.main.async {
                        completionHandler(TMDbResponse.error(Error.invalidAPIResponse))
                    }
                    return
            }
                         
            do {
                let json = try JSONDecoder().decode(TMDbSearchResponse.self, from: data)
                
                DispatchQueue.main.async {
                    let searchResults = TMDbNameSearchResponse(name: name, movies: json.movies ?? [])
                    self.tmdbNameSearchCache.setObject(TMDbNameSearchResultHolder(data: searchResults),
                                                       forKey: NSString(string: name))
                    
                    completionHandler(TMDbResponse.data(searchResults))
                }
            } catch let error as NSError {
                print ("Failed to parse response: '\(error)'")
                DispatchQueue.main.async {
                    completionHandler(TMDbResponse.error(error))
                }
                return
            }
        }.resume()
    }
    
    private func searchURL(for name: String) -> URL? {
        guard let escapedName = name.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else { return nil }
        
        let url = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(escapedName)"
        return URL(string: url)
    }
    
}
