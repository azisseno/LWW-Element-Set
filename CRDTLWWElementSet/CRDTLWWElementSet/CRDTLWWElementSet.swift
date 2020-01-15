//
//  CRDTLWWElementSet.swift
//  CRDTLWWElementSet
//
//  Created by Azis Senoaji Prasetyotomo on 15/01/20.
//  Copyright © 2020 siza. All rights reserved.
//

import Foundation

public struct CRDTNode<T : Hashable> : Comparable {
    
    let value: T
    let timestampDate: Date
    
    public init(value: T, timeStampDate: Date = Date()) {
        self.value = value
        self.timestampDate = timeStampDate
    }

    public static func ==(left: CRDTNode, right: CRDTNode) -> Bool {
        return left.value == right.value
    }

    public static func <(left: CRDTNode, right: CRDTNode) -> Bool {
        return left.timestampDate < right.timestampDate
    }
}

public class CRDTLWWSet<T : Hashable> : Equatable {

    public var sortedData: [CRDTNode<T>] {
        return _sortedData
    }
    
    public var data: [T: CRDTNode<T>] {
        return _data
    }
    
    public let uniqueCode = UUID().uuidString
    
    private var _sortedData: [CRDTNode<T>] = []
    private var _data: [T: CRDTNode<T>] = [:] {
        didSet {
            var results = [CRDTNode<T>]()
            results = data.map { $0.value }
            _sortedData = results.sorted { $0 < $1 }
        }
    }

    public func add(_ node: CRDTNode<T>) {
        if let existingNode = data[node.value] {
            if existingNode.timestampDate < node.timestampDate {
                _data[node.value] = node
            }
        } else {
            _data[node.value] = node
        }
    }

    public func remove(_ node: CRDTNode<T>) {
        if let existingNode = data[node.value] {
            if existingNode.timestampDate < node.timestampDate {
                _data[node.value] = nil
            }
        }
    }

    public func merge(_ set: CRDTLWWSet<T>) {
        for item in set.data {
            add(item.value)
        }
    }

    public func query(element: T) -> CRDTNode<T>? {
        return data[element]
    }

    public static func ==(left: CRDTLWWSet, right: CRDTLWWSet) -> Bool {
        guard left.data == right.data else {
            return false
        }
        return true
    }

    public static func +(left: CRDTLWWSet, right: CRDTLWWSet) -> CRDTLWWSet<T> {
        let set = left
        set.merge(right)
        return set
    }
}
