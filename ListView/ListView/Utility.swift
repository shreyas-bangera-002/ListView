//
//  Utility.swift
//  ListView
//
//  Created by Shreyas Bangera on 22/07/19.
//  Copyright © 2019 Shreyas Bangera. All rights reserved.
//

import UIKit

extension Array {
    static var empty: [Element] {
        return [Element]()
    }
    
    func add(_ items: [Element]) -> [Element] {
        var list = self
        list.append(contentsOf: items)
        return list
    }
    
    func last(_ slice: Int) -> [Element] {
        guard slice <= count else { return .empty }
        return Array(self[count-slice..<count])
    }
}

extension Optional {
    var isNil: Bool {
        return self == nil
    }
}

protocol Then {}

extension Then where Self: AnyObject {
    func then(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
    
}

extension NSObject: Then {}
extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
extension CGVector: Then {}
extension UIEdgeInsets: Then {}
extension UIOffset: Then {}
extension UIRectEdge: Then {}

protocol Reusable: class {}

extension Reusable {
    static var reuseId: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable {}
extension UICollectionViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}

protocol Configurable where Self: UIView {
    associatedtype T
    func configure(_ item: T)
}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseId)
    }
    
    func register<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseId)
    }
    
    func dequeueCell<T: UITableViewCell>(_: T.Type, at index: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.reuseId, for: index) as! T
    }
    
    func dequeueCell<T: UITableViewCell & Configurable, U>(_: T.Type, at index: IndexPath, with item: U) -> T where T.T == U {
        return dequeueCell(T.self, at: index).then { $0.configure(item) }
    }
    
    func dequeueHeader<T: UITableViewHeaderFooterView>(_: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.reuseId) as! T
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseId)
    }
    
    func dequeueCell<T: UICollectionViewCell>(_: T.Type, at index: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.reuseId, for: index) as! T
    }
    
    func dequeueCell<T: UICollectionViewCell & Configurable, U>(_: T.Type, at index: IndexPath, with item: U) -> T where T.T == U {
        return dequeueCell(T.self, at: index).then { $0.configure(item) }
    }
}
