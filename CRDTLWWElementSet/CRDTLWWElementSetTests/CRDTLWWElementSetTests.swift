//
//  CRDTLWWElementSetTests.swift
//  CRDTLWWElementSetTests
//
//  Created by Azis Senoaji Prasetyotomo on 15/01/20.
//  Copyright © 2020 siza. All rights reserved.
//

import XCTest
@testable import CRDTLWWElementSet

class CRDTLWWElementSetTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddNode() {
        let setA = CRDTLWWSet<String>()
        setA.add(CRDTNode(value: "A", timeStampDate: Date()))
        setA.add(CRDTNode(value: "B", timeStampDate: Date()))
        XCTAssertEqual(setA.sortedData.count, 2)
        XCTAssertEqual(setA.data.count, 2)
        let resultA = setA.query(element: "A")
        let resultB = setA.query(element: "B")
        XCTAssertNotNil(resultA)
        XCTAssertNotNil(resultB)
        XCTAssertTrue(resultA!.value == "A")
        XCTAssertTrue(resultB!.value == "B")

    }
    
    func testOverrideNode() {
        let setA = CRDTLWWSet<String>()
        setA.add(CRDTNode(value: "A", timeStampDate: Date(timeIntervalSinceReferenceDate: 1)))
        setA.add(CRDTNode(value: "A", timeStampDate: Date(timeIntervalSinceReferenceDate: 2)))
        XCTAssertEqual(setA.sortedData.count, 1)
        XCTAssertEqual(setA.query(element: "A")!.timestampDate,
                       Date(timeIntervalSinceReferenceDate: 2))
    }
    
    func testRemoveNode() {
        let setA = CRDTLWWSet<String>()
        setA.add(CRDTNode(value: "A"))
        setA.remove(CRDTNode(value: "A"))
        
        XCTAssertEqual(setA.sortedData.count, 0)
        XCTAssertEqual(setA.data.count, 0)
    }
    
    func testMustNotRemoveNode() {
        let setA = CRDTLWWSet<String>()
        setA.add(CRDTNode(value: "A", timeStampDate: Date(timeIntervalSinceReferenceDate: 2)))
        setA.remove(CRDTNode(value: "A", timeStampDate: Date(timeIntervalSinceReferenceDate: 1)))

        XCTAssertEqual(setA.data.count, 1)
        XCTAssertEqual(setA.sortedData.count, 1)
    }
    
    func testRemoveNothingNode() {
        let setA = CRDTLWWSet<String>()
        setA.add(CRDTNode(value: "A", timeStampDate: Date()))
        setA.remove(CRDTNode(value: "B", timeStampDate: Date()))
        
        XCTAssertEqual(setA.data.count, 1)
        XCTAssertEqual(setA.sortedData.count, 1)
    }
    
    func testSetOrder() {
        let setA = CRDTLWWSet<String>()
        setA.add(CRDTNode(value: "A", timeStampDate: Date(timeIntervalSinceReferenceDate: 2)))
        setA.add(CRDTNode(value: "B", timeStampDate: Date(timeIntervalSinceReferenceDate: 1)))
        setA.add(CRDTNode(value: "C", timeStampDate: Date(timeIntervalSinceReferenceDate: 5)))
        setA.add(CRDTNode(value: "D", timeStampDate: Date(timeIntervalSinceReferenceDate: 4)))

        XCTAssertEqual(setA.sortedData.count, 4)
        XCTAssertEqual(setA.sortedData[0],
                       CRDTNode(value: "B", timeStampDate: Date(timeIntervalSinceReferenceDate: 1)))
        XCTAssertEqual(setA.sortedData[1],
                       CRDTNode(value: "A", timeStampDate: Date(timeIntervalSinceReferenceDate: 2)))
        XCTAssertEqual(setA.sortedData[2],
                       CRDTNode(value: "D", timeStampDate: Date(timeIntervalSinceReferenceDate: 4)))
        XCTAssertEqual(setA.sortedData[3],
                       CRDTNode(value: "C", timeStampDate: Date(timeIntervalSinceReferenceDate: 5)))
        
        setA.remove(CRDTNode(value: "D", timeStampDate: Date(timeIntervalSinceReferenceDate: 8)))
        
        XCTAssertEqual(setA.sortedData.count, 3)
        XCTAssertEqual(setA.sortedData[0],
                       CRDTNode(value: "B", timeStampDate: Date(timeIntervalSinceReferenceDate: 1)))
        XCTAssertEqual(setA.sortedData[1],
                       CRDTNode(value: "A", timeStampDate: Date(timeIntervalSinceReferenceDate: 2)))
        XCTAssertEqual(setA.sortedData[2],
                       CRDTNode(value: "C", timeStampDate: Date(timeIntervalSinceReferenceDate: 5)))

    }

    func testEmptySet() {
        let someSet = CRDTLWWSet<String>()
        XCTAssertEqual(someSet.sortedData.count, 0)
        XCTAssertEqual(someSet.data.count, 0)
    }

}
