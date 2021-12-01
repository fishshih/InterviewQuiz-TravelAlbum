//
//  PhotoCollectionViewConfigure.swift
//  TravelAlbum
//
//  Created by Fish Shih on 2021/11/27.
//

import UIKit

struct PhotoCollectionViewConfigure {

    static let margin = CGFloat(1)
    static let lineSpacing = CGFloat(1)

    static var bigCellSize: CGSize {
        let width = (UIScreen.main.bounds.width - margin) / 2
        return .init(width: width, height: width)
    }

    static var smallCellSize: CGSize {
        let width = (UIScreen.main.bounds.width - (margin * 3)) / 4
        return .init(width: width, height: width)
    }

    static var blockHeight: CGFloat {
        bigCellSize.height + smallCellSize.height * 2 + margin * 3 // + headerHeight
    }

    static func calcBlockIndex(by index: Int) -> Int {
        index / 10
    }

    static func calcItemX(by index: Int) -> CGFloat? {

        let position = index % 10
        let bigWidth = bigCellSize.width
        let smallWidth = smallCellSize.width

        switch position {
        case 0, 5, 8:
            return 0
        case 1, 3, 7:
            return margin + bigWidth
        case 2, 4:
            return margin * 2 + bigWidth + smallWidth
        case 6, 9:
            return margin + smallWidth
        default:
            return nil
        }
    }

    static func calcItemYInBlock(by index: Int) -> CGFloat? {

        let position = index % 10
        let bigHeight = bigCellSize.height
        let smallHeight = smallCellSize.height

        switch position {
        case 0, 1, 2:
            return margin
        case 3, 4:
            return margin * 2 + smallHeight
        case 5, 6, 7:
            return margin * 2 + bigHeight
        case 8, 9:
            return margin * 3 + bigHeight + smallHeight
        default:
            return nil
        }
    }

    static func calcSize(by index: Int) -> CGSize {

        switch index % 10 {
        case 0, 7:
            return bigCellSize
        default:
            return smallCellSize
        }
    }

    static func calcLastYInBlock(by index: Int) -> CGFloat? {

        let bigCellHeight = bigCellSize.height

        switch index % 10 {
        case 0 ... 4:
            return bigCellHeight + margin
        case 5, 6:
            return bigCellHeight + margin + smallCellSize.height
        case 7 ... 9:
            return bigCellHeight * 2 + margin * 2
        default:
            return nil
        }
    }
}
