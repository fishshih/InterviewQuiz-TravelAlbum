//
//  ImageLoadingView.swift
//  TravelAlbum
//
//  Created by Fish Shih on 2021/11/27.
//

import UIKit

class ImageLoadingView: UIView {

    // MARK: - Property

    // MARK: - Life cycle

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        start()
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    // MARK: - Private property

    private let gradientLayer = CAGradientLayer()

    private var gradientColorSet: [[CGColor]] {

        let first = UIColor(white: 0.88, alpha: 1).cgColor
        let second = UIColor(white: 0.98, alpha: 1).cgColor
        let third = UIColor(white: 0.88, alpha: 1).cgColor

        return [
            [first, second],
            [second, third],
            [third, first],
        ]
    }

    private var currentGradientIndex = 0
    private var isKeepRunning = false {
        didSet {
            gradientLayer.isHidden = !isKeepRunning
        }
    }
}

// MARK: - UI configure

private extension ImageLoadingView {

    func setupUI() {

        gradientLayer.colors = gradientColorSet[currentGradientIndex]
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = .init(x: 1, y: 1)

        layer.addSublayer(gradientLayer)
    }
}

// MARK: - Public func

extension ImageLoadingView {

    func start() {
        isKeepRunning = true
        startAnimate()
    }

    func stop() {
        isKeepRunning = false
    }
}

// MARK: - Private func

private extension ImageLoadingView {

    func startAnimate() {

        if currentGradientIndex < gradientColorSet.count - 1 {
            currentGradientIndex += 1
        } else {
            currentGradientIndex = 0
        }

        let animation = CABasicAnimation(keyPath: "colors")

        animation.delegate = self
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = 0.6
        animation.toValue = gradientColorSet[currentGradientIndex]

        gradientLayer.add(animation, forKey: "colorChange")
    }
}

extension ImageLoadingView: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

        guard flag, isKeepRunning else { return }

        gradientLayer.colors = gradientColorSet[currentGradientIndex]
        startAnimate()
    }
}
