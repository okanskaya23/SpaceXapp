//
//  SpaceXTests.swift
//  SpaceXTests
//
//  Created by Okan Sarp Kaya on 13.05.2022.
//

import XCTest
@testable import SpaceX

class SpaceXTests: XCTestCase {
    
    func placeHolderImageCheck(){
        XCTAssertNotNil(Network.defaultImageURL)
    }
    
    func checkPaginationLimit(){
        XCTAssertNotNil(Network.paginationLimit)
    }
}
