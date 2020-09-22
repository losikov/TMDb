//
//  UIImageView_CachesTests.swift
//  TMDbTests
//
//  Created by Alexander Losikov on 11/16/19.
//  Copyright © 2019 Alexander Losikov. All rights reserved.
//

import XCTest

class ImageCache: XCTestCase {
    var imageView: UIImageView!

    override func setUp() {
        imageView = UIImageView()
    }

    private func loadImage(_ urlString: String = "https://image.tmdb.org/t/p/w600_and_h900_bestv2//dCtFvscYcXQKTNvyyaQr2g2UacJ.jpg",
                           checkImageContent: Bool = true) {
        let expectation = self.expectation(description: "Image loaded")
        var handersCallsCounter = 0
        imageView.loadImageWithUrl(string: urlString,
                                   placeholder: #imageLiteral(resourceName: "poster_placeholder"),
                                   startedHandler: {
                                       XCTAssertTrue(Thread.isMainThread)
                                       XCTAssertNil(imageView.image)
                                    
                                       handersCallsCounter += 1
                                       XCTAssertEqual(handersCallsCounter, 1, "startedHandler should be called first")
                                   },
                                   completionHandler: { image in
                                       XCTAssertTrue(Thread.isMainThread)
                                       if (checkImageContent) {
                                           XCTAssertEqual(#imageLiteral(resourceName: "harry").pngData(), image!.pngData())
                                       }
                                    
                                       handersCallsCounter += 1
                                       XCTAssertEqual(handersCallsCounter, 2, "completionHandler should be called second")
                                       expectation.fulfill()
                                   })
        
        if let image = imageView.image { // image is set from cache
            if (checkImageContent) {
                XCTAssertEqual(#imageLiteral(resourceName: "harry").pngData(), image.pngData())
            }
            expectation.fulfill()
        }
           
        waitForExpectations(timeout: 8, handler: nil)
    }
    
    func testSuccessLoadImage() {
        loadImage()
    }
    
    func testFailLoadImage() {
        let expectation = self.expectation(description: "Image fail")
        var handersCallsCounter = 0
        imageView.loadImageWithUrl(string: "https://image.tmdb.org/t/p/w600_and_h900_bestv2/fail.jpg",
                                   placeholder: #imageLiteral(resourceName: "poster_placeholder"),
                                   startedHandler: {
                                       XCTAssertTrue(Thread.isMainThread)
                                       XCTAssertNil(imageView.image)
                                    
                                       handersCallsCounter += 1
                                       XCTAssertEqual(handersCallsCounter, 1, "startedHandler should be called first")
                                   },
                                   completionHandler: { image in
                                       XCTAssertTrue(Thread.isMainThread)
                                       XCTAssertEqual(#imageLiteral(resourceName: "poster_placeholder").pngData(), image!.pngData())
                                    
                                       handersCallsCounter += 1
                                       XCTAssertEqual(handersCallsCounter, 2, "completionHandler should be called second")
                                       expectation.fulfill()
                                   })
        
        if let _ = imageView.image {
            XCTFail("Should not set any image")
        }
           
        waitForExpectations(timeout: 8, handler: nil)
    }

    func testCachePerformance() {
        let imageUrl = "https://image.tmdb.org/t/p/w600_and_h900_bestv2//7ITPWkDkFBIb4M9wgHDcjG2fMB4.jpg"
        // the first request should store a result in a cache
        loadImage(imageUrl, checkImageContent: false)
        self.measure {
             // all other requests should take the result from the cache
            loadImage(imageUrl, checkImageContent: false)
        }
    }

}
