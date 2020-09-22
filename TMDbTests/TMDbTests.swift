//
//  TMDbTests.swift
//  TMDbTests
//
//  Created by Alexander Losikov on 11/16/19.
//  Copyright © 2019 Alexander Losikov. All rights reserved.
//

import XCTest
@testable import TMDb

class TMDbTests: XCTestCase {
    
    let tmdb = TMDbSearch()

    @discardableResult private func search(_ name: String, expectedMinCount: Int) -> Int {
        let expectation = self.expectation(description: "Success response")
        var moviesCount = 0
        
        tmdb.search(for: name) { response in
            XCTAssertTrue(Thread.isMainThread, "should call on main thread")
            
            switch response {
            case .error(let error):
                XCTFail(error.localizedDescription)
            case .data(let data):
                XCTAssertEqual(data.name, name)
                XCTAssertTrue(data.movies.count >= expectedMinCount)
                moviesCount = data.movies.count
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
        
        return moviesCount
    }
    
    func testSearchValidName() {
        search("Harry Potter", expectedMinCount: 18)
    }
    
    func testSearchEmptyName() {
        search("", expectedMinCount: 0)
    }

    func testCachePerformance() {
        // the first request should store a result in a cache
        let moviesCount = search("A", expectedMinCount: 1)
        self.measure {
             // all other requests should take the result from the cache
            search("A", expectedMinCount: moviesCount)
        }
    }

}
