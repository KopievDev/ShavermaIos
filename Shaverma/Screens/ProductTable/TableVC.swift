//
//  ProductTable.swift
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
    var category: Category { get }
}

class TableVC: UIViewController, WithTable {

    lazy var tableView: UITableView = {
        $0.backgroundColor(.staticWhite).separatorStyle = .none
        $0.register(ProductCell.self)
        $0.contentInset = .init(top: 8, left: 0, bottom: 76, right: 0)
        $0.scrollsToTop = true
        $0.verticalScrollIndicatorInsets.top = 8
        return $0
    }(UITableView())

    let category: Category

    @Published var items: [Product] = []
    private var subscriptions: Set<AnyCancellable> = []

    init(category: Category) {
        self.category = category
        switch category.name {
        case "Шаурма":
            items = Product.shaverma
        case "Закуски":
            items = Product.zakuson
        case "Напитки":
            items = Product.drinks
        case "Соусы":
            items = Product.sauses
        default:
            items = Product.shaverma
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(.notImplememt)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        [tableView].addOnParent(view: view)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tableView.bind($items, cellType: ProductCell.self) { index, model, cell in
            cell.render(viewModel: model)
        }.store(in: &subscriptions)
    }
}
