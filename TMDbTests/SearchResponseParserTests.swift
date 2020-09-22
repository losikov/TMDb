//
//  SearchResponseParserTests.swift
//  TMDbTests
//
//  Created by Alexander Losikov on 11/16/19.
//  Copyright © 2019 Alexander Losikov. All rights reserved.
//

import XCTest

class MovieTests: XCTestCase {
    
    func testParserAllProps() {
        let json = """
        {
            "results": [
                {
                    "title": "title",
                    "overview": "overview",
                    "poster_path": "poster_path",
                }
            ]
        }
        """
        
        let result = try! JSONDecoder().decode(SearchResponse.self, from: json.data(using: .utf8)!)
        let movie = result.movies![0]
        
        XCTAssertEqual(movie.title, "title")
        XCTAssertEqual(movie.overview, "overview")
        XCTAssertEqual(movie.posterPath, "poster_path")
        XCTAssertEqual(movie.imageUrlString(), "https://image.tmdb.org/t/p/w600_and_h900_bestv2/poster_path")
    }
    
    func testMissedPoster() {
        let json = """
        {
            "results": [
                {
                    "title": "title",
                    "overview": "overview"
                }
            ]
        }
        """
        
        let result = try! JSONDecoder().decode(SearchResponse.self, from: json.data(using: .utf8)!)
        let movie = result.movies![0]
        
        XCTAssertEqual(movie.title, "title")
        XCTAssertEqual(movie.overview, "overview")
        XCTAssertNil(movie.posterPath)
        XCTAssertNil(movie.imageUrlString())
    }
    
    func testMissedProps() {
        let json = """
        {
            "results": [
                {
                    "poster_path": "poster_path"
                }
            ]
        }
        """
        
        let result = try! JSONDecoder().decode(SearchResponse.self, from: json.data(using: .utf8)!)
        let movie = result.movies![0]
        
        XCTAssertNil(movie.title)
        XCTAssertNil(movie.overview)
        XCTAssertEqual(movie.posterPath, "poster_path")
        XCTAssertEqual(movie.imageUrlString(), "https://image.tmdb.org/t/p/w600_and_h900_bestv2/poster_path")
    }
    
    func testMissedResuts() {
        let json = "{}"
        
        let result = try! JSONDecoder().decode(SearchResponse.self, from: json.data(using: .utf8)!)
        
        XCTAssertNil(result.movies)
    }
}
