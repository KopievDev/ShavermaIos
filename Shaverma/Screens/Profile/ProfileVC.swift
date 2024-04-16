//
//  ProfileVC.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import UIKit
import Combine
import CombineCocoa

final class ProfileVC: UIViewController {

    private let viewModel: ProfileViewModel
    private let router: ProfileRouter
    private var subscriptions: Set<AnyCancellable> = []
    private lazy var tableView: UITableView = {
        $0.register(MenuCell.self)
        $0.contentInset = .init(top: 8, left: 0, bottom: 76, right: 0)
        $0.scrollsToTop = true
        $0.delegate = self
        $0.verticalScrollIndicatorInsets.top = 8
        return $0
    }(UITableView())
    init(
        viewModel: ProfileViewModel,
        router: ProfileRouter
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

private extension ProfileVC {
    func setupUI() {
        setupView()
        addSubviews()
        addConstraints()
    }

    func setupView() {

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
        tableView.bind(viewModel.$cells, cellType: MenuCell.self) { index, model, cell in
            cell.render(viewModel: model)
        }.store(in: &subscriptions)
    }
}

extension ProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.cells[indexPath.row]
        switch model.type {
        case "logout":
            router.logout()
        case "address":
            router.routeToShowAddress()
        default: break
        }
    }
}

class MenuCell: BaseCell<MenuItem> {
    

    private let titleLabel = UILabel(
        font: .bold(15),
        textColor: .primaryBase,
        lines: 0,
        alignment: .left
    )

    private let imgView = UIImageView(width: 24, height: 24)

    override func commonInit() {
        [titleLabel, imgView].addOnParent(view: contentView)

        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(12)
            $0.right.equalTo(imgView.snp.left)
        }

        imgView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
        }
    }

    override func render(viewModel: MenuItem) {
        titleLabel.text = viewModel.title
        imgView.image = viewModel.icon?.value
        imgView.tintColor = viewModel.icon?.tint
    }
}
