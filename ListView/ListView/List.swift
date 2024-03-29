//
//  List.swift
//  ListView
//
//  Created by Shreyas Bangera on 22/07/19.
//  Copyright © 2019 Shreyas Bangera. All rights reserved.
//

import Foundation

struct List<Section,Item> {
    let section: Section?
    var items: [Item]?
    
    static func dataSource(sections: [Section?], items: [[Item]?]) -> [List<Section,Item>] {
        let diff = abs(sections.count - items.count)
        let data = List.list(sections: sections, items: items)
        guard sections.count == items.count else {
            return data.add(sections.count > items.count ?
                List.list(sections: sections.last(diff), items: Array(repeating: [], count: diff)) :
                List.list(sections: Array(repeating: nil, count: diff), items: items.last(diff)))
        }
        return data
    }
    
    static func list(sections: [Section?], items: [[Item]?]) -> [List<Section,Item>] {
        return zip(sections, items).map({ .init(section: $0.0, items: $0.1) })
    }
}
