//
//  PhotoCollectionViewFlowLayout.swift
//  TravelAlbum
//
//  Created by Fish Shih on 2021/11/27.
//

import UIKit

class PhotoCollectionViewFlowLayout: UICollectionViewFlowLayout {

    enum CellStyle {
        case big
        case small
    }

    var attributesArray = [UICollectionViewLayoutAttributes]()

    override var collectionViewContentSize: CGSize {
        .init(width: UIScreen.main.bounds.width, height: lastSectionMaxY + 60)
    }

    override func prepare() {

        guard let collectionView = collectionView else { return }

        lastSectionMaxY = 0
        attributesArray.removeAll()

        scrollDirection = .horizontal

        let sections = collectionView.numberOfSections

        for section in 0 ..< sections {

            let itemCount = collectionView.numberOfItems(inSection: section)

            if let attributes = makeHeaderLayoutAttributes(by: .init(item: 0, section: section)) {
                attributesArray.append(attributes)
            }

            for item in 0 ..< itemCount {

                let indexPath = IndexPath(item: item, section: section)

                guard let attributes = makeLayoutAttributes(by: indexPath) else { continue }

                attributesArray.append(attributes)
            }
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        attributesArray.first { $0.indexPath == indexPath }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        attributesArray.filter {
            $0.frame.intersects(rect)
        }
    }

    // MARK: - Private

    private var lastSectionMaxY = CGFloat(0)
}

private extension PhotoCollectionViewFlowLayout {

    func makeLayoutAttributes(by indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        guard
            let collectionView = collectionView,
            let x = PhotoCollectionViewConfigure.calcItemX(by: indexPath.item),
            let yInBlock = PhotoCollectionViewConfigure.calcItemYInBlock(by: indexPath.item)
        else {
            return nil
        }

        let blockIndex = PhotoCollectionViewConfigure.calcBlockIndex(by: indexPath.item)
        let blockBaseY = PhotoCollectionViewConfigure.blockHeight * CGFloat(blockIndex)
        let y = yInBlock + blockBaseY + lastSectionMaxY
        let size = PhotoCollectionViewConfigure.calcSize(by: indexPath.item)
        let frame = CGRect(origin: .init(x: x, y: y), size: size)

        if indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1 {

            guard
                let lastYInBlock = PhotoCollectionViewConfigure
                    .calcLastYInBlock(
                        by: indexPath.item
                    )
            else {
                return nil
            }

            lastSectionMaxY += lastYInBlock + blockBaseY
        }

        return .init(forCellWith: indexPath) --> {
            $0.frame = frame
        }
    }

    func makeHeaderLayoutAttributes(by indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        UICollectionViewLayoutAttributes(
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            with: indexPath
        ) --> {
            $0.frame = .init(
                x: 0,
                y: lastSectionMaxY + PhotoCollectionViewConfigure.margin,
                width: UIScreen.main.bounds.width,
                height: PhotoCollectionViewConfigure.smallCellSize.height
            )
        }
    }
}
