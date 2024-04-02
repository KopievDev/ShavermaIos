//
//  Button.swift
//  VeLo Player
//
//  Created by Иван Копиев on 12.03.2024.
//

import UIKit
import Combine
import CombineCocoa

final class Button: UIButton {
    let viewModel: ViewModel

    private let spin = SpinnerView()
        .size(width: 20, height: 20)
        .alpha(0)
    private let imgView = UIImageView()
        .size(width: 20, height: 20)
    private var subscriptions = Set<AnyCancellable>()
    private var haptic: AnyCancellable?

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError(.notImplememt)
    }

    func updateWith(viewModel: ViewModel) {
        self.viewModel.backgroundColor = viewModel.backgroundColor
        self.viewModel.title = viewModel.title
        self.viewModel.textColor = viewModel.textColor
        self.viewModel.iconUrl = viewModel.iconUrl
        self.viewModel.icon = viewModel.icon
        self.viewModel.withAnimate = viewModel.withAnimate
        self.viewModel.isEnabled = viewModel.isEnabled
        self.viewModel.isLoading = viewModel.isLoading
        self.viewModel.withHaptic = viewModel.withHaptic
        self.viewModel.withAnimateColors = viewModel.withAnimateColors
        self.viewModel.id = viewModel.id
    }
}

private extension Button {

    func commonInit() {
        setupUI()
        bind()
    }

    func setupUI() {
        setTitleColor(.staticWhite, for: .disabled)
        [spin, imgView].addOnParent(view: self)
        translatesAutoresizingMaskIntoConstraints = false
        size(height: 46).cornerRadius(23)
        setTitleColor(viewModel.textColor, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        imgView.tintColor(viewModel.textColor)
        isEnabled = viewModel.isEnabled
        backgroundColor = viewModel.isEnabled
            ? viewModel.backgroundColor
            : .disabledButton
        guard let titleLabel else { return }
        spin.snp.makeConstraints { $0.centerX.centerY.equalToSuperview() }
        imgView.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(8)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
    }

    func bind() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in self?.updateLoader(isLoading: isLoading) }
            .store(in: &subscriptions)

        viewModel.$isEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in guard let self else { return }
                self.isEnabled = isEnabled
                updateBackround(color: viewModel.backgroundColor)
            }.store(in: &subscriptions)

        viewModel.$title
            .sink { [weak self] title in self?.setTitle(title, for: .normal) }
            .store(in: &subscriptions)

        viewModel.$withAnimate
            .sink(weakObject: self) { $0?.withAnimate($1) }
            .store(in: &subscriptions)

        viewModel.$withAnimateColors
            .sink(weakObject: self) { $0?.withAnimateColors($1) }
            .store(in: &subscriptions)

        viewModel.$withHaptic
            .sink(weakObject: self) { $0?.withHaptic($1) }
            .store(in: &subscriptions)

        viewModel.$corners
            .sink { [weak self] corners in self?.corners(corners, radius: 23) }
            .store(in: &subscriptions)

        viewModel.$icon
            .sink { [weak self] image in guard let self else { return }
                imgView.image = image
                if let url = viewModel.iconUrl, image == nil { imgView.load(urlString: url) }
            }.store(in: &subscriptions)

        viewModel.$textColor
            .sink { [weak self] in self?.setTitleColor($0, for: .normal) }
            .store(in: &subscriptions)

        viewModel.$backgroundColor
            .sink { [weak self] in self?.updateBackround(color: $0) }
            .store(in: &subscriptions)

        viewModel.$iconUrl
            .compactMap { $0 }
            .sink { [weak self] in self?.imgView.load(urlString: $0) }
            .store(in: &subscriptions)
    }

    func updateBackround(color: UIColor) {
        UIView.animate(withDuration: 0.2) { [self] in
            backgroundColor = isEnabled ? color : .disabledButton
        }
    }

    func updateLoader(isLoading: Bool) {
        UIView.animate(withDuration: 0.3) { [self] in
            titleLabel?.alpha = isLoading ? 0:1
            imgView.alpha = isLoading ? 0:1
            spin.alpha = isLoading ? 1:0
            isUserInteractionEnabled = !isLoading
        }
    }
}

// MARK: - ViewModel -
extension Button {

    class ViewModel {
        var id: String
        @Published 
        var title: String?
        @Published 
        var icon: UIImage?
        @Published
        var iconUrl: String?
        @Published
        var backgroundColor: UIColor
        @Published
        var textColor: UIColor
        @Published
        var isLoading = false
        @Published 
        var isEnabled = true
        @Published 
        var withAnimate = true
        @Published
        var withAnimateColors = true
        @Published
        var withHaptic = true
        @Published
        var corners: Corners = .full

        init(
            id: String = UUID().uuidString,
            title: String? = nil,
            icon: UIImage? = nil,
            iconUrl: String? = nil,
            backgroundColor: UIColor,
            textColor: UIColor,
            isLoading: Bool = false,
            isEnabled: Bool = true,
            withAnimate: Bool = true,
            withAnimateColors: Bool = true,
            withHaptic: Bool = true,
            corners: Corners
        ) {
            self.id = id
            self.title = title
            self.icon = icon
            self.iconUrl = iconUrl
            self.backgroundColor = backgroundColor
            self.textColor = textColor
            self.isLoading = isLoading
            self.isEnabled = isEnabled
            self.withAnimate = withAnimate
            self.withAnimateColors = withAnimateColors
            self.withHaptic = withHaptic
            self.corners = corners
        }
    }
}


// MARK: - Helpers -
extension Button {

    @discardableResult
    func isLoading(_ isLoading: Bool = true) -> Self {
        viewModel.isLoading = isLoading
        return self
    }

    @discardableResult
    func withAnimateColors(_ withAnimate: Bool = true) -> Self {
        withAnimate ? startColorsAnimatingPressActions() : ()
        return self
    }

    @discardableResult
    func withHaptic(_ withHaptic: Bool = true) -> Self {
        guard withHaptic else {
            haptic = nil
            return self
        }
        haptic = tapPublisher.sink { Haptic.selection() }
        return self
    }

    @discardableResult
    func withSelector(_ selector: Selector) -> Self {
        addTarget(nil, action: selector, for: .touchUpInside)
        return self
    }

    @objc private func animateColorIn(view: UIView) {
        UIView.animate(withDuration: 0.15) { view.backgroundColor = self.viewModel.backgroundColor.darker(by: 5) }
    }

    @objc private func animateColorOut(view viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.15) { viewToAnimate.backgroundColor = self.viewModel.backgroundColor }
    }

    private func startColorsAnimatingPressActions() {
        addTarget(self, action: #selector(animateColorIn(view:)), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateColorOut(view:)), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
}
