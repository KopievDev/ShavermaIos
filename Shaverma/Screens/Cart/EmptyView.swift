//
//  EmptyView.swift
//  Shaverma
//
//  Created by Иван Копиев on 18.04.2024.
//

import UIKit
import Combine

final class EmptyView: Component {

    let viewModel: ViewModel
    private let imgView = UIImageView(width: 64, height: 64)
        .contentMode(.scaleAspectFit)
        .tintColor(.orangeButton)
        .image(.cart)

    private let titleLabel = UILabel(
        font: .regular(16),
        textColor: .primaryBase,
        lines: 0,
        alignment: .center
    )
    private lazy var stack = UIStackView(
        axis: .vertical,
        spacing: 4,
        arrangedSubviews: [
            imgView, 
            titleLabel
        ]
    )
    private var subscriptions: Set<AnyCancellable> = []

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError(.notImplememt)
    }
    
    override func setupUI() {
        backgroundColor(.clear)
        [stack].addOnParent(view: self)
        stack.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
    }

    override func bind() {
        viewModel.$icon
            .sink { [weak self] image in guard let self else { return }
                imgView.image = image
            }.store(in: &subscriptions)

        viewModel.$title
            .sink { [weak self] title in guard let self else { return }
                titleLabel.text = title
            }.store(in: &subscriptions)
    }
}

extension EmptyView {
    class ViewModel {
        @Published
        var icon: UIImage?
        @Published
        var title: String?

        init(icon: UIImage? = nil, title: String? = nil) {
            self.icon = icon
            self.title = title
        }
    }
}
