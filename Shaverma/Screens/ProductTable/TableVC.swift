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
    @Published
    var isLoading: Bool = false
    let api = ShavermaAPI.shared
    let category: Category

    @Published var items: [Product] = []
    private var subscriptions: Set<AnyCancellable> = []

    init(category: Category) {
        self.category = category
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
        tableView.bind($items, cellType: ProductCell.self) { [unowned self] index, model, cell in
            cell.render(viewModel: model)
            cell.productAction = { product in
                self.update(product: product)
            }
        }.store(in: &subscriptions)

        $isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in guard let self else { return }
                $0 ? showLoader() : dismissLoader()
            }.store(in: &subscriptions)

        loadProducts()

    }

    func update(product: Product) {
        guard let index = items.firstIndex(where: { $0.id == product.id }) else { return }
        items[index] = product
        //TODO: - Добавить отправку кол-ва
    }

    func loadProducts() {
        Task { @MainActor in
            do {
                isLoading = true
                defer { isLoading = false }
                items = try await api.products(category: category)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
