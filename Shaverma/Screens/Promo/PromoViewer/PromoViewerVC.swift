//
//  PromoViewerVC.swift
//  VeLo Player
//
// Created by Иван Копиев on 17.04.2024.
//

import UIKit
import Combine
import CombineCocoa

final class PromoViewerVC: UIViewController {

    private let viewModel: PromoViewerViewModel
    private let router: PromoViewerRouter
    private var subscriptions: Set<AnyCancellable> = []
    private let imgView = UIImageView()
        .contentMode(.scaleAspectFill)
        .clipsToBounds(true)
        .cornerRadius(16)
    private let titleLabel = UILabel(
        text: "-",
        font: .bold(16),
        textColor: .primaryBase,
        lines: 0,
        alignment: .center
    )
    private let descLabel = UILabel(
        text: "-",
        font: .regular(14),
        textColor: .primaryBase,
        lines: 0,
        alignment: .center
    )
    private lazy var commonStack = UIStackView(
        axis: .vertical,
        spacing: 16,
        arrangedSubviews: [
            UIView(embed: imgView) { 
                $0.height.equalTo(imgView.snp.width).multipliedBy(0.472)
                $0.edges.equalToSuperview().inset(16)
            },
            titleLabel,
            descLabel
        ]
    )

    private lazy var scrollStack = ScrollStack(stack: commonStack)

    init(
        viewModel: PromoViewerViewModel,
        router: PromoViewerRouter
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

private extension PromoViewerVC {
    func setupUI() {
        setupView()
        addSubviews()
        addConstraints()
    }

    func setupView() {
        view.backgroundColor(.staticWhite)
    }

    func addSubviews() {
        [scrollStack].addOnParent(view: view)
    }

    func addConstraints() {
        scrollStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func bind() {
        viewModel.$promo.sink { [weak self] in guard let self else { return }
            titleLabel.text = $0.title
            descLabel.text = $0.desc
            imgView.load(urlString: $0.imageUrl)
        }.store(in: &subscriptions)
    }
}
