// 
//  PhotoCollectionReusableHeaderView.swift
//  TravelAlbum
//
//  Created by Fish Shih on 2021/11/28.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoCollectionReusableHeaderView: UICollectionReusableView {

    // MARK: - Property

    // MARK: - Life cycle

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)

        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        coverLayer.frame = bounds
    }

    // MARK: - Private property

    private let coverLayer = CAGradientLayer() --> {

        $0.colors = [
            UIColor.black.withAlphaComponent(0.4),
            UIColor.black.withAlphaComponent(0.4),
            UIColor.black.withAlphaComponent(0)
        ].map { $0.cgColor }

        $0.locations = [0, 0.4, 1]
        $0.startPoint = .init(x: 0.5, y: 0)
        $0.endPoint = .init(x: 0.5, y: 1)
    }

    private let titleStack = UIStackView() --> {
        $0.axis = .vertical
        $0.spacing = 4
    }

    private let dateLabel = UILabel() --> {
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.textColor = .white
    }

    private let nameOfPlaceLabel = UILabel() --> {
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.textColor = .white
    }

    private let disposeBag = DisposeBag()
}

// MARK: - UI configure

private extension PhotoCollectionReusableHeaderView {

    func setupUI() {
        configureCoverlayer()
        configureTitleStack()
        configureDateLabel()
        configureNameOfPlaceLabel()
    }

    func configureCoverlayer() {
        layer.addSublayer(coverLayer)
    }

    func configureTitleStack() {

        addSubview(titleStack)

        titleStack.snp.makeConstraints {
            $0.top.leading.equalTo(20)
            $0.trailing.lessThanOrEqualTo(-20)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }

    func configureDateLabel() {
        titleStack.addArrangedSubview(dateLabel)
    }

    func configureNameOfPlaceLabel() {
        titleStack.addArrangedSubview(nameOfPlaceLabel)
    }
}

// MARK: - Private func

private extension PhotoCollectionReusableHeaderView { }

// MARK: - Public func

extension PhotoCollectionReusableHeaderView {

    func set(date: Date?) {
        dateLabel.text = date?.formatAsDefaultString()
    }

    func set(nameOfPlace name: String?) {
        nameOfPlaceLabel.text = name
    }
}
