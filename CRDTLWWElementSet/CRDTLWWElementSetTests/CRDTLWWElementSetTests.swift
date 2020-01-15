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

    func testAddNode() {
        let setA = CRDTLWWSet<String>()
        setA.add(CRDTNode(value: "A"))
        setA.add(CRDTNode(value: "B"))
        XCTAssertEqual(setA.sortedExistingData.count, 2)
        XCTAssertEqual(setA.completedSet.count, 2)
        
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
        XCTAssertEqual(setA.sortedExistingData.count, 1)
        XCTAssertEqual(setA.completedSet.count, 1)
        XCTAssertEqual(setA.query(element: "A")!.timestampDate,
                       Date(timeIntervalSinceReferenceDate: 2))
    }
    
    func testRemoveNode() {
        let setA = CRDTLWWSet<String>()
        setA.add(CRDTNode(value: "A"))
        setA.remove(CRDTNode(value: "A"))
        
        XCTAssertEqual(setA.sortedExistingData.count, 0)
        XCTAssertEqual(setA.completedSet.count, 1)
    }
    
    func testMustNotRemoveNode() {
        let setA = CRDTLWWSet<String>()
        setA.add(CRDTNode(value: "A", timeStampDate: Date(timeIntervalSinceReferenceDate: 2)))
        setA.remove(CRDTNode(value: "A", timeStampDate: Date(timeIntervalSinceReferenceDate: 1)))

        XCTAssertEqual(setA.sortedExistingData.count, 1)
        XCTAssertEqual(setA.completedSet.count, 1)
    }
    
    func testRemoveNothingNode() {
        let setA = CRDTLWWSet<String>()
        setA.add(CRDTNode(value: "A"))
        setA.remove(CRDTNode(value: "B"))
        
        XCTAssertEqual(setA.sortedExistingData.count, 1)
        XCTAssertEqual(setA.completedSet.count, 2)

    }
    
    func testSetOrder() {
        let setA = CRDTLWWSet<String>()
        setA.add(CRDTNode(value: "A", timeStampDate: Date(timeIntervalSinceReferenceDate: 2)))
        setA.add(CRDTNode(value: "B", timeStampDate: Date(timeIntervalSinceReferenceDate: 1)))
        setA.add(CRDTNode(value: "C", timeStampDate: Date(timeIntervalSinceReferenceDate: 5)))
        setA.add(CRDTNode(value: "D", timeStampDate: Date(timeIntervalSinceReferenceDate: 4)))

        XCTAssertEqual(setA.sortedExistingData.count, 4)
        XCTAssertEqual(setA.sortedExistingData[0],
                       CRDTNode(value: "B", timeStampDate: Date(timeIntervalSinceReferenceDate: 1)))
        XCTAssertEqual(setA.sortedExistingData[1],
                       CRDTNode(value: "A", timeStampDate: Date(timeIntervalSinceReferenceDate: 2)))
        XCTAssertEqual(setA.sortedExistingData[2],
                       CRDTNode(value: "D", timeStampDate: Date(timeIntervalSinceReferenceDate: 4)))
        XCTAssertEqual(setA.sortedExistingData[3],
                       CRDTNode(value: "C", timeStampDate: Date(timeIntervalSinceReferenceDate: 5)))
        
        setA.remove(CRDTNode(value: "D", timeStampDate: Date(timeIntervalSinceReferenceDate: 8)))
        
        XCTAssertEqual(setA.sortedExistingData.count, 3)
        XCTAssertEqual(setA.sortedExistingData[0],
                       CRDTNode(value: "B", timeStampDate: Date(timeIntervalSinceReferenceDate: 1)))
        XCTAssertEqual(setA.sortedExistingData[1],
                       CRDTNode(value: "A", timeStampDate: Date(timeIntervalSinceReferenceDate: 2)))
        XCTAssertEqual(setA.sortedExistingData[2],
                       CRDTNode(value: "C", timeStampDate: Date(timeIntervalSinceReferenceDate: 5)))

    }

    func testEmptySet() {
        let someSet = CRDTLWWSet<String>()
        XCTAssertEqual(someSet.sortedExistingData.count, 0)
    }

}
