//
//  collectionViewTests.swift
//  collectionViewTests
//
//  Created by Nurmukhanbet Sertay on 23.09.2023.
//

import XCTest
@testable import collectionView

final class MyApiManagerDelegateSpy {
    
}

extension MyApiManagerDelegateSpy: MyApiManagerDelegate {
    func test() {
        print("test started")
    }
}

final class collectionViewTests: XCTestCase {
    
    var sut: APIManager!
    var delegate: MyApiManagerDelegateSpy!
    
    override class func setUp() {
        super.setUp()
        delegate = MyApiManagerDelegateSpy()
        testStressLoadImages()
        testStressLoadImagesSequentially()
        testStressLoadImagesConcurrently()
    }
    
    override class func tearDown() {
        super.tearDown()
        print("End")
    }
    
    func testStressLoadImages() {
        let expectation = self.expectation(description: "Stress Load Images")
        let apiManager = sut
        let numberOfRequests = 100 // Adjust the number of requests as needed
        
        var completedRequests = 0
        let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
        
        for id in 1...numberOfRequests {
            concurrentQueue.async {
                apiManager?.loadImages(id: id) { image in
                    // This block is called when each image is loaded
                    completedRequests += 1
                    
                    if completedRequests == numberOfRequests {
                        expectation.fulfill()
                    }
                }
            }
        }
        
        // Wait for all requests to complete (with a timeout)
        waitForExpectations(timeout: 30.0) { error in
            if let error = error {
                XCTFail("Timeout error: \(error)")
            }
        }
    }
    
    func testStressLoadImagesSequentially() {
        let expectation = self.expectation(description: "Stress Load Images Sequentially")
        let apiManager = sut
        let numberOfRequests = 100 // Adjust the number of requests as needed
        
        var completedRequests = 0
        
        func loadNextImage(id: Int) {
            apiManager?.loadImages(id: id) { image in
                // This block is called when each image is loaded
                completedRequests += 1
                
                if completedRequests < numberOfRequests {
                    loadNextImage(id: id + 1)
                } else {
                    expectation.fulfill()
                }
            }
        }
        
        loadNextImage(id: 1)
        
        // Wait for all requests to complete (with a timeout)
        waitForExpectations(timeout: 30.0) { error in
            if let error = error {
                XCTFail("Timeout error: \(error)")
            }
        }
    }
    
    func testStressLoadImagesConcurrently() {
           let expectation = self.expectation(description: "Stress Load Images Concurrently")
           let apiManager = sut
           let numberOfRequests = 100 // Adjust the number of requests as needed
           
           var completedRequests = 0
           let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
           
           for id in 1...numberOfRequests {
               concurrentQueue.async {
                   apiManager?.loadImages(id: id) { image in
                       // This block is called when each image is loaded
                       completedRequests += 1
                       
                       if completedRequests == numberOfRequests {
                           expectation.fulfill()
                       }
                   }
               }
           }
           
           // Wait for all requests to complete (with a timeout)
           waitForExpectations(timeout: 30.0) { error in
               if let error = error {
                   XCTFail("Timeout error: \(error)")
               }
           }
       }

}
