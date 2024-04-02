//
//  SmallButton.swift
//  VeLo Player
//
//  Created by Иван Копиев on 07.03.2024.
//
//
//import UIKit
//import Combine
//import SnapKit
//
//class SmallButton: UIButton {
//    let viewModel: ViewModel
//
//    private let textLabel = UILabel(
//        text: "Tile",
//        font: .systemFont(ofSize: 13, weight: .regular),
//        textColor: .primaryText,
//        lines: 1,
//        alignment: .right
//    )
//    private let imgView = UIImageView(width: 16, height: 16)
//        .tintColor(.primary)
//        .contentMode(.scaleAspectFit)
//
//    private lazy var stack = UIStackView(
//        axis: .horizontal,
//        spacing: 4,
//        arrangedSubviews: [
//            textLabel,
//            imgView
//        ]
//    )
//
//    private var subscriptions: Set<AnyCancellable> = []
//
//    init(viewModel: ViewModel) {
//        self.viewModel = viewModel
//        super.init(frame: .zero)
//        commonInit()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//
//}
//
//private extension SmallButton {
//    func commonInit() {
//        setupUI()
//        bind()
//    }
//
//    func setupUI() {
//        stack.isUserInteractionEnabled = false
//        [stack].addOnParent(view: self)
//        stack.snp.makeConstraints { $0.edges.equalToSuperview() }
//    }
//
//    func bind() {
//        tapPublisher
//            .sink { Haptic.selection() }
//            .store(in: &subscriptions)
//        viewModel.$image
//            .assign(to: \.image, on: imgView)
//            .store(in: &subscriptions)
//        viewModel.$text
//            .sink { [weak self] in guard let self else { return }
//                textLabel.text = $0
//            }.store(in: &subscriptions)
//    }
//}
//
//extension SmallButton {
//    class ViewModel {
//        @Published
//        var text: String
//        @Published
//        var image: UIImage?
//
//        init(text: String, image: UIImage?) {
//            self.text = text
//            self.image = image
//        }
//    }
//}
