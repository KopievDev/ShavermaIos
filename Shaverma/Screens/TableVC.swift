//
//  TableVC.swift
//  Shaverma
//
//  Created by Иван Копиев on 02.04.2024.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

protocol WithTable: UIViewController {
    var tableView: UITableView { get }
}

class TableVC: UIViewController, WithTable {

    lazy var tableView: UITableView = {
        $0.backgroundColor(.staticWhite).separatorStyle = .none
        $0.register(UITableViewCell.self)
        $0.contentInset = .init(top: 8, left: 0, bottom: 76, right: 0)
        $0.scrollsToTop = true
        $0.verticalScrollIndicatorInsets.top = 8
        return $0
    }(UITableView())
    
    @Published var items: [String] = [
        " text ",
        " text 13e ",
        " text 23e",
        " text 23f2",
        " text 23r2r",
        " text 23r2",
        " text 23r2",
        " text ",
        " text 13e ",
        " text 23e",
        " text 23f2",
        " text 23r2r",
        " text 23r2",
        " text 23r2",   
        " text ",
        " text 13e ",
        " text 23e",
        " text 23f2",
        " text 23r2r",
        " text 23r2",
        " text 23r2",
        " text ",
        " text 13e ",
        " text 23e",
        " text 23f2",
        " text 23r2r",
        " text 23r2",
        " text 23r2",
        " text ",
        " text 13e ",
        " text 23e",
        " text 23f2",
        " text 23r2r",
        " text 23r2",
        " text 23r2",
    ]
    private var subscriptions: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        [tableView].addOnParent(view: view)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tableView.bind($items, cellType: UITableViewCell.self) { index, model, cell in
            cell.textLabel?.text = model
        }.store(in: &subscriptions)
    }
}
