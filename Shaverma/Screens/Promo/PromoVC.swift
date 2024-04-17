//
//  PromoVC.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import UIKit
import Combine
import CombineCocoa

final class PromoVC: UIViewController {

    private let viewModel: PromoViewModel
    private let router: PromoRouter
    private var subscriptions: Set<AnyCancellable> = []
    lazy var tableView: UITableView = {
        $0.backgroundColor(.staticWhite).separatorStyle = .none
        $0.register(PromoCell.self)
        $0.contentInset = .init(top: 8, left: 0, bottom: 76, right: 0)
        $0.scrollsToTop = true
        $0.delegate = self
        $0.verticalScrollIndicatorInsets.top = 8
        return $0
    }(UITableView())

    init(
        viewModel: PromoViewModel,
        router: PromoRouter
    ) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
        self.router.vc = self
    }

    required init?(coder: NSCoder) {
        fatalError("Not implement")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.viewDidLoad()
    }
}

private extension PromoVC {
    func setupUI() {
        setupView()
        addSubviews()
        addConstraints()
    }

    func setupView() {
        view.backgroundColor(.staticWhite)
    }

    func addSubviews() {
        [tableView].addOnParent(view: view)
    }

    func addConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func bind() {
        tableView.bind(viewModel.$items, cellType: PromoCell.self) { index, model, cell in
            cell.render(viewModel: model)
        }.store(in: &subscriptions)
    }
}

extension PromoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.row]
        router.routeToDetail(promo: item)
    }
}
