//
//  CardCollectionView.swift
//  WBPayClient
//
//  Created by Иван Копиев on 01.03.2024.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

final class CardCollectionView: Component {
    @Published
    var cards: [UIImage] = []
    private lazy var collectionView: UICollectionView = {
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
        $0.clipsToBounds = false
        $0.register(CardImageCellView.self)
        $0.backgroundColor(.clear)
        return $0
    }(UICollectionView(layout: UPCarouselFlowLayout(with: .init(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.width*0.45))))

    private var index = 0
    private var subscriptions: Set<AnyCancellable> = []

   override func setupUI() {
        snp.makeConstraints { $0.height.equalTo(UIScreen.main.bounds.width*0.5) }
        backgroundColor(.clear)
        [collectionView].addOnParent(view: self)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        clipsToBounds = false
    }

    override func bind() {
        collectionView.bind($cards, cellType: CardImageCellView.self) { index, model, cell in
            cell.render(viewModel: model)
        }.store(in: &subscriptions)
    }

    func scrollTo(index: Int, animated: Bool = false) {
        collectionView.scrollRectToVisible(
            .init(
                x: 168 * CGFloat(index),
                y: 0,
                width: collectionView.frame.width,
                height: collectionView.frame.height
            ),
            animated: animated
        )
    }
}


extension CardCollectionView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let locationFirst = CGPoint(
            x: collectionView.center.x + scrollView.contentOffset.x,
            y: collectionView.center.y + scrollView.contentOffset.y
        )
        let locationSecond = CGPoint(
            x: collectionView.center.x + scrollView.contentOffset.x + 20,
            y: collectionView.center.y + scrollView.contentOffset.y
        )
        let locationThird = CGPoint(
            x: collectionView.center.x + scrollView.contentOffset.x - 20,
            y: collectionView.center.y + scrollView.contentOffset.y
        )
        if let indexPathFirst = collectionView.indexPathForItem(at: locationFirst),
           let indexPathSecond = collectionView.indexPathForItem(at: locationSecond),
            let indexPathThird = collectionView.indexPathForItem(at: locationThird),
            indexPathFirst.row == indexPathSecond.row &&
            indexPathSecond.row == indexPathThird.row &&
            indexPathFirst.row != index  {
            index = indexPathFirst.row
            Haptic.selection()
        }
    }
}

private final class CardImageCellView: BaseCollectionCell<UIImage> {

    let imgView = UIImageView()
        .contentMode(.scaleAspectFill)
        .clipsToBounds(true)
        .cornerRadius(16)
    override func commonInit() {
        [imgView].addOnParent(view: contentView)
        contentView.backgroundColor(.clear)
        imgView.snp.makeConstraints { $0.edges.equalToSuperview() }

    }
    override func render(viewModel: UIImage) {
        imgView.image = viewModel
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0.0, height: 10)
        clipsToBounds = false
    }
}

public enum UPCarouselFlowLayoutSpacingMode {
    case fixed(spacing: CGFloat)
    case overlap(visibleOffset: CGFloat)
}


open class UPCarouselFlowLayout: UICollectionViewFlowLayout {

    fileprivate struct LayoutState {
        var size: CGSize
        var direction: UICollectionView.ScrollDirection
        func isEqual(_ otherState: LayoutState) -> Bool {
            return self.size.equalTo(otherState.size) && self.direction == otherState.direction
        }
    }

    @IBInspectable open var sideItemScale: CGFloat = 0.6
    @IBInspectable open var sideItemAlpha: CGFloat = 0.6
    @IBInspectable open var sideItemShift: CGFloat = 0.0
    open var spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 40)

    fileprivate var state = LayoutState(size: CGSize.zero, direction: .horizontal)

    public init(with itemSize: CGSize) {
        super.init()
        self.scrollDirection = .horizontal
        self.itemSize = itemSize
        self.minimumLineSpacing = 8
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func prepare() {
        super.prepare()
        let currentState = LayoutState(size: self.collectionView!.bounds.size, direction: self.scrollDirection)

        if !self.state.isEqual(currentState) {
            self.setupCollectionView()
            self.updateLayout()
            self.state = currentState
        }
    }

    fileprivate func setupCollectionView() {
        guard let collectionView = self.collectionView else { return }
        if collectionView.decelerationRate != UIScrollView.DecelerationRate.fast {
            collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        }
    }

    fileprivate func updateLayout() {
        guard let collectionView = self.collectionView else { return }

        let collectionSize = collectionView.bounds.size
        let isHorizontal = (self.scrollDirection == .horizontal)

        let yInset = (collectionSize.height - self.itemSize.height) / 2
        let xInset = (collectionSize.width - self.itemSize.width) / 2
        self.sectionInset = UIEdgeInsets.init(top: yInset, left: xInset, bottom: yInset, right: xInset)

        let side = isHorizontal ? self.itemSize.width : self.itemSize.height
        let scaledItemOffset =  (side - side*self.sideItemScale) / 2
        switch self.spacingMode {
        case .fixed(let spacing):
            self.minimumLineSpacing = spacing - scaledItemOffset
        case .overlap(let visibleOffset):
            let fullSizeSideItemOverlap = visibleOffset + scaledItemOffset
            let inset = isHorizontal ? xInset : yInset
            self.minimumLineSpacing = inset - fullSizeSideItemOverlap
        }
    }

    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        return attributes.map({ self.transformLayoutAttributes($0) })
    }

    fileprivate func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }
        let isHorizontal = (self.scrollDirection == .horizontal)

        let collectionCenter = isHorizontal ? collectionView.frame.size.width/2 : collectionView.frame.size.height/2
        let offset = isHorizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        let normalizedCenter = (isHorizontal ? attributes.center.x : attributes.center.y) - offset

        let maxDistance = (isHorizontal ? self.itemSize.width : self.itemSize.height) + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance)/maxDistance

        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        let shift = (1 - ratio) * self.sideItemShift
        attributes.alpha = alpha
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.zIndex = Int(alpha * 10)

        if isHorizontal {
            attributes.center.y = attributes.center.y + shift
        } else {
            attributes.center.x = attributes.center.x + shift
        }

        return attributes
    }

    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView , !collectionView.isPagingEnabled,
            let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
            else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }

        let isHorizontal = (self.scrollDirection == .horizontal)

        let midSide = (isHorizontal ? collectionView.bounds.size.width : collectionView.bounds.size.height) / 2
        let proposedContentOffsetCenterOrigin = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + midSide

        var targetContentOffset: CGPoint
        if isHorizontal {
            let closest = layoutAttributes.sorted { abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: floor(closest.center.x - midSide), y: proposedContentOffset.y)
        }
        else {
            let closest = layoutAttributes.sorted { abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - midSide))
        }

        return targetContentOffset
    }
}
