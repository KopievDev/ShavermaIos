//
//  PageIndicator.swift
//  VeLo Player
//
//  Created by Иван Копиев on 07.03.2024.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class PageIndicator: Component {

    private let cursorView = UIView()
        .backgroundColor(.orangeButton)
        .size(height: 3)
        .cornerRadius(1.5)
    private let separatorView = UIView()
        .backgroundColor(.secondaryText)
        .size(height: 1)
    private let stackView = UIStackView(
        axis: .horizontal,
        distribution: .fillEqually
    )
    @Published
    private var buttons: [UIButton] = []
    private var centerConstr: NSLayoutConstraint?

    let selectedIndex = CurrentValueSubject<Int, Never>(0)

    private var subscriptions: Set<AnyCancellable> = []
    let viewModel: ViewModel

    init(viewModel: ViewModel = .init()) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }

    public required init?(coder: NSCoder) {
        fatalError("Not implement")
    }

    public func setSelect(index: Int) {
        [centerConstr].forEach { $0?.isActive = false }
        guard index < buttons.count else { return }
        let button = buttons[index]
        UIView.animate(withDuration: 0.3) { [self] in
            centerConstr = cursorView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
            centerConstr?.isActive = true
            buttons.forEach { $0.isSelected = $0.tag == index }
            layoutIfNeeded()
        }
    }

   override func setupUI() {
       backgroundColor(.primaryBase).size(height: 56)
        [separatorView, stackView, cursorView].addOnParent(view: self)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        cursorView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(1.0/CGFloat(viewModel.values.count))
        }
       separatorView.snp.makeConstraints {
           $0.bottom.equalTo(cursorView)
           $0.width.equalToSuperview()
       }
    }

    override func bind() {
        viewModel.$values
            .sink { [unowned self] values in set(data: values) }
            .store(in: &subscriptions)

        buttons
            .compactMap { $0 as? PageButton }
            .forEach { button in
            button.publisher(for: \.isSelected)
                .sink { isSelected in
                    UIView.animate(withDuration: 0.3) {
                        button.titleLabel?.font = isSelected
                            ? MonserratFont.bold(17).font
                            : MonserratFont.regular(16).font
                    }
                }.store(in: &subscriptions)
        }

    }
}

private extension PageIndicator {

    func set(data: [PageButton.ViewModel]) {
        buttons = data.map(PageButton.init)
        buttons.enumerated().forEach {
            $0.element.isSelected = $0.offset == 0
            $0.element.addTarget(self, action: #selector(didTap(button:)), for: .touchUpInside)
            $0.element.tag = $0.offset
        }
        stackView.addArrangedSubview(views: buttons)
    }

    @objc private func didTap(button: UIButton) {
        Haptic.selection()
        selectedIndex.send(button.tag)
        setSelect(index: button.tag)
    }

}

extension PageIndicator {
    class ViewModel {
        @Published var values: [PageButton.ViewModel] = []

        init(values: [PageButton.ViewModel] = []) {
            self.values = values
        }
    }
}

public extension UIButton {

    convenience init(text: String?) {
        self.init(frame: .zero)
        setTitle(text, for: .normal)
    }
}

class PageButton: UIButton {

    init(viewModel: ViewModel) {
        super.init(frame: .zero)
        setTitle(viewModel.title, for: .normal)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        titleLabel?.font = MonserratFont.regular(16).font
        setTitleColor(.staticWhite, for: .selected)
        setTitleColor(.secondaryText, for: .normal)
    }
}

extension PageButton {
    struct ViewModel {
        public let title: String?

        public init(title: String?) {
            self.title = title
        }
    }
}

extension PageButton.ViewModel: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        title = value
    }
}
