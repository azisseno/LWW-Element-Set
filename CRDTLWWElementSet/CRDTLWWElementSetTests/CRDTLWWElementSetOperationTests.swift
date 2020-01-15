//
//  CRDTLWWElementSetOperationTests.swift
//  CRDTLWWElementSetTests
//
//  Created by Azis Senoaji Prasetyotomo on 15/01/20.
//  Copyright © 2020 siza. All rights reserved.
//

import XCTest
@testable import CRDTLWWElementSet

class CRDTLWWElementSetOperationTests: XCTestCase {
    
    func testSameSetMerge() {
        let setA = CRDTLWWSet<String>()
        setA.add(CRDTNode(value: "A"))
        XCTAssert(setA == setA + setA, "duplication doesn't matter")
    }

    func testMergeDifferentOrder() {
        let setA = CRDTLWWSet<String>()
        setA.add(CRDTNode(value: "A"))
        
        let setB = CRDTLWWSet<String>()
        setB.add(CRDTNode(value: "B"))

        XCTAssert(setA + setB == setB + setA, "order should not matter")
    }

    func testMergeAssociative() {
        let setA = CRDTLWWSet<String>()
        setA.add(CRDTNode(value: "A"))
        
        let setB = CRDTLWWSet<String>()
        setB.add(CRDTNode(value: "B"))

        let setC = CRDTLWWSet<String>()
        setB.add(CRDTNode(value: "C"))

        let sumA = (setA + setB) + setC
        let sumB = (setC + setA) + setB
        
        XCTAssert(sumA == sumB, "sumA and sumB must be equal")
    }

    func testComplexMerge() {
        
        let setA = CRDTLWWSet<String>()
        setA.add(CRDTNode(value: "A", timeStampDate: Date(timeIntervalSinceReferenceDate: 1)))
        setA.add(CRDTNode(value: "B", timeStampDate: Date(timeIntervalSinceReferenceDate: 2)))
        
        let setB = CRDTLWWSet<String>()
        setB.add(CRDTNode(value: "B", timeStampDate: Date(timeIntervalSinceReferenceDate: 2)))
        setB.add(CRDTNode(value: "C", timeStampDate: Date(timeIntervalSinceReferenceDate: 2)))

        let setC = CRDTLWWSet<String>()
        setB.remove(CRDTNode(value: "B", timeStampDate: Date(timeIntervalSinceReferenceDate: 3)))
        setB.remove(CRDTNode(value: "C", timeStampDate: Date(timeIntervalSinceReferenceDate: 1)))
        setB.remove(CRDTNode(value: "D", timeStampDate: Date(timeIntervalSinceReferenceDate: 3)))

        let merged = setA + setB + setC
        print(merged.completeData)
        print(merged.sortedExistingData)

        XCTAssertEqual(merged.sortedExistingData.count, 2)
        XCTAssertEqual(merged.completeData.count, 4)
        XCTAssertNotNil(merged.query(element: "A")) // cat 1 never been removed
        XCTAssertNotNil(merged.query(element: "C")) // parrot 2 can't be removed before it exists
        XCTAssertNil(merged.query(element: "B")) // dog removed
        XCTAssertNil(merged.query(element: "D")) // rubbish never exists

    }
    
}

