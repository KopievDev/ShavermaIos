//
//  Toast.swift
//  Shaverma
//
//  Created by Иван Копиев on 05.04.2024.
//

import UIKit
import Combine
import SnapKit

enum Toast {

    static func with(viewModel: ViewModel, completion: VoidBlock? = nil) {
        ToastView(viewModel: viewModel, completion: completion).show()
    }
}

// MARK: - ViewModel -
extension Toast {
    class ViewModel {
        public enum State { case success, danger, primary, attention }

        @Published var title: String?
        @Published var state: State
        @Published var image: UIImage? = nil
        var delay: TimeInterval = 2.0
        var haptic: UINotificationFeedbackGenerator.FeedbackType

        public init(
            title: String?,
            state: State,
            image: UIImage? = nil,
            delay: TimeInterval = 2.0,
            haptic: UINotificationFeedbackGenerator.FeedbackType = .success
        ) {
            self.title = title
            self.state = state
            self.image = image
            self.delay = delay
            self.haptic = haptic
        }
    }
}

final class ToastView: Component {

    private let formView = UIView()
        .backgroundColor(.red)
        .cornerRadius(10)

    private let imageView = UIImageView(frame: .zero)
        .backgroundColor(.clear)

    private let titleLabel = UILabel(
        font: .regular(13),
        textColor: .staticWhite,
        lines: 0,
        alignment: .left
    )

    private var completion: VoidBlock?
    private var dissmisFromGesture: Bool = false
    private let viewModel: Toast.ViewModel
    private var subscriptions: Set<AnyCancellable> = []

    init(viewModel: Toast.ViewModel, completion: VoidBlock? = nil) {
        self.viewModel = viewModel
        self.completion = completion
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("Not implement")
    }

   override func setupUI() {
        [formView].addOnParent(view: self)
        [imageView, titleLabel].addOnParent(view: formView)
        formView.snp.makeConstraints { $0.top.left.right.equalToSuperview().inset(16) }
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalTo(titleLabel.snp.leading).inset(-8)
        }
        titleLabel.snp.makeConstraints { $0.top.bottom.trailing.equalToSuperview().inset(16) }
    }

    override func bind() {
        viewModel.$title
            .assign(to: \.text, on: titleLabel)
            .store(in: &subscriptions)

        viewModel.$state
            .sink(weakObject: self) { $0?.render(state: $1) }
            .store(in: &subscriptions)

        viewModel.$image
            .sink(weakObject: self) { view, image in
                view?.imageView.image = image?.withRenderingMode(.alwaysOriginal)
            }
            .store(in: &subscriptions)

        let swipeLeft = gesture(.swipe(.init(direction: .left)))
        let swipeUp = gesture(.swipe(.init(direction: .up)))
        let swipeRight = gesture(.swipe(.init(direction: .right)))

        swipeLeft.merge(with: swipeUp, swipeRight)
            .compactMap { $0.get() as? UISwipeGestureRecognizer }
            .sink(weakObject: self) { $0?.handle(swipe: $1) }
            .store(in: &subscriptions)

        gesture()
            .sink(weakObject: self) { view,_ in view?.dismiss() }
            .store(in: &subscriptions)
    }



    func show() {
        guard let window = UIApplication.shared.windows.first else { return }
        window.addSubview(self)
        window.bringSubviewToFront(self)
        autoresizingMask = [.flexibleWidth]
        let height = titleLabel.requiredHeight + 64
        frame = CGRect(x: 0, y: -height, width: UIScreen.main.bounds.width, height: height)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: .curveEaseIn
        ) { [self] in
            frame = CGRect(
                x: 0,
                y: window.safeAreaInsets.top,
                width: frame.width,
                height: height
            )
        }
        perform(#selector(dismiss), with: nil, afterDelay: viewModel.delay)
        Haptic.notification(viewModel.haptic)
    }
}
// MARK: - Private -
private extension ToastView {

    func render(state: Toast.ViewModel.State) {
        switch state {
        case .success:
            formView.backgroundColor(.green)
        case .danger:
            formView.backgroundColor(.red)
        case .primary:
            formView.backgroundColor(.purple)
        case .attention:
            formView.backgroundColor(.orange)
        }
    }

    @objc func dismiss() {
        if superview != nil {
            UIView.animate(withDuration: 0.3) { [self] in
                alpha = 0
                if !dissmisFromGesture { completion?() }
            } completion: { _ in
                self.removeFromSuperview()
            }
        }
    }

    private func handle(swipe: UISwipeGestureRecognizer) {
        var offsetPoint: CGPoint = CGPoint(x: 0, y: -bounds.height - 30)
        switch  swipe.direction {
        case .left: offsetPoint = CGPoint(x: -frame.width, y: frame.minY)
        case .right: offsetPoint = CGPoint(x: frame.width, y: frame.minY)
        default: break
        }
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: .curveEaseIn
        ) { [self] in
            frame = CGRect(x: offsetPoint.x, y: offsetPoint.y, width: frame.width, height: bounds.height)
            completion?()
        } completion: { [self] _ in
            dissmisFromGesture = true
            removeFromSuperview()
        }
    }
}

fileprivate extension UILabel {
    var requiredHeight: CGFloat {
        let label = UILabel(
            frame: .init(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width * 0.91 - 32,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}
