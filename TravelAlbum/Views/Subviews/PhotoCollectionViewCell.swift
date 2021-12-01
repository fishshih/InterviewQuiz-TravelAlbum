// 
//  PhotoCollectionViewCell.swift
//  TravelAlbum
//
//  Created by Fish Shih on 2021/11/27.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class PhotoCollectionViewCell: UICollectionViewCell {

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

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        loadingView.start()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        loadingView.frame = bounds
        imageView.frame = bounds
    }

    // MARK: - Private property

    private let loadingView = ImageLoadingView()

    private let imageView = UIImageView() --> {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let disposeBag = DisposeBag()
}

// MARK: - UI configure

private extension PhotoCollectionViewCell {

    func setupUI() {
        configureLoadingView()
        configureImageView()
    }

    func configureLoadingView() {

        contentView.addSubview(loadingView)

        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configureImageView() {

        contentView.addSubview(imageView)

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Public func

extension PhotoCollectionViewCell {

    func set(imageUrlString: String) {

        guard let url = URL(string: imageUrlString) else { return }

        imageView
            .kf
            .setImage(with: .network(url)) {
                [weak loadingView] _ in
                loadingView?.stop()
            }
    }
}
