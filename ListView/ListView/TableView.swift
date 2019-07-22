//
//  TableView.swift
//  ListView
//
//  Created by Shreyas Bangera on 22/07/19.
//  Copyright © 2019 Shreyas Bangera. All rights reserved.
//

import UIKit

class TableView<Section,Item>: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    private var data = [List<Section,Item>]()
    var original = [List<Section,Item>]()
    var isExpanded = [Bool]()
    var didSelect: ((TableView<Section,Item>, IndexPath, Item) -> Void)?
    var didDeSelect: ((TableView<Section,Item>, IndexPath, Item) -> Void)?
    var header: ((TableView<Section,Item>, Int, Section) -> UIView?)?
    var footer: ((TableView<Section,Item>, Int, Section) -> UIView?)?
    var headerHeight: ((Int) -> CGFloat)?
    var footerHeight: ((Int) -> CGFloat)?
    var configureCell: ((TableView<Section,Item>, IndexPath, Item) -> UITableViewCell)?
    
    init() {
        super.init(frame: .zero, style: .plain)
        backgroundColor = .clear
        tableFooterView = UIView()
        dataSource = self
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = data[indexPath.section].items?[indexPath.row],
            let cell = configureCell?(self, indexPath, item) else {
                return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = data[indexPath.section].items?[indexPath.row] else { return }
        didSelect?(self, indexPath, item)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let item = data[indexPath.section].items?[indexPath.row] else { return }
        didDeSelect?(self, indexPath, item)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = data[section].section else { return nil }
        return header?(self, section, item)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let item = data[section].section else { return nil }
        return footer?(self, section, item)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return data[section].section.isNil ? 0 : headerHeight?(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return data[section].section.isNil ? 0 : footerHeight?(section) ?? 0
    }
    
    func update(_ sections: [Section?] = .empty, items: [[Item]?] = .empty) {
        let list = List.dataSource(sections: sections, items: items)
        isExpanded = Array(repeating: true, count: list.count)
        original = list
        data = list
        reloadData()
    }
    
    func toggle(_ section: Int) {
        isExpanded[section].toggle()
        data[section].items = isExpanded[section] ? original[section].items : .empty
        reloadSections([section], with: .automatic)
    }
}

class TableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        render()
    }
    
    func render() {}
}

class TableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: nil)
        render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        render()
    }
    
    func render() {}
}
