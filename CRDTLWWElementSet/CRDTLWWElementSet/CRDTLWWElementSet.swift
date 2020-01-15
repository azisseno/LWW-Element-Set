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
        return left.value == right.value && left.timestampDate == right.timestampDate
    }

    public static func <(left: CRDTNode, right: CRDTNode) -> Bool {
        return left.timestampDate < right.timestampDate
    }
}

public enum CRDTOpration {
    case addition
    case removal
}

public class CRDTLWWSet<T : Hashable> : Equatable {

    public struct Node<T: Hashable>: Equatable {
        public var node: CRDTNode<T>
        public var operation: CRDTOpration
    }
    
    public var sortedExistingData: [CRDTNode<T>] {
        return _sortedExistingData
    }
    
    public var completeData: [T: Node<T>] {
        return _data
    }
    
    public let uniqueCode = UUID().uuidString
    
    private var _sortedExistingData: [CRDTNode<T>] = []
    private var _data: [T: Node<T>] = [:] {
        didSet {
            var results = [CRDTNode<T>]()
            for item in _data where item.value.operation == .addition {
                results.append(item.value.node)
            }
            _sortedExistingData = results.sorted { $0 < $1 }
        }
    }

    public func add(_ node: CRDTNode<T>) {
        if let existingNode = _data[node.value] {
            if existingNode.node.timestampDate < node.timestampDate {
                _data[node.value] = Node(node: node, operation: .addition)
            }
        } else {
            _data[node.value] = Node(node: node, operation: .addition)
        }
    }

    public func remove(_ node: CRDTNode<T>) {
        if let existingNode = _data[node.value] {
            if existingNode.node.timestampDate < node.timestampDate {
                _data[node.value] = Node(node: node, operation: .removal)
            }
        } else {
            _data[node.value] = Node(node: node, operation: .removal)
        }
    }

    public func merge(_ set: CRDTLWWSet<T>) {
        for item in set._data {
            switch item.value.operation {
            case .addition:
                add(item.value.node)
            case .removal:
                remove(item.value.node)
            }
        }
    }

    public func query(element: T) -> CRDTNode<T>? {
        if let set = _data[element], set.operation == .addition {
            return set.node
        }
        return nil
    }

    public static func ==(left: CRDTLWWSet, right: CRDTLWWSet) -> Bool {
        guard left._data == right._data else {
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
