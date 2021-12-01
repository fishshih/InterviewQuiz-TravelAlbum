// 
//  MainViewController.swift
//  TravelAlbum
//
//  Created by Fish Shih on 2021/11/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    // MARK: - Property

    var viewModel: MainViewModelPrototype?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        guard let viewModel = viewModel else { return }

        bind(viewModel)
    }

    // MARK: - Private property

    private var collectionView: UICollectionView?
    private let flowLayout = PhotoCollectionViewFlowLayout()

    private let refreshControl = UIRefreshControl()

    private var infoModels = [AlbumInfoModel]() {
        didSet {
            stopRefresh()
            collectionView?.setCollectionViewLayout(flowLayout, animated: false)
            collectionView?.reloadData()
        }
    }

    private let disposeBag = DisposeBag()
}

// MARK: - UI configure

private extension MainViewController {

    func setupUI() {
        view.backgroundColor = .white
        configureCollectionView()
        configureRefreshControl()
    }

    func configureCollectionView() {

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        self.collectionView = collectionView

        collectionView.register(PhotoCollectionViewCell.self)
        collectionView.register(
            PhotoCollectionReusableHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "PhotoCollectionReusableHeaderView"
        )

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true

        view.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configureRefreshControl() {
        collectionView?.refreshControl = refreshControl
    }
}

// MARK: - Private func

private extension MainViewController {

    func showErrorAlert(by message: String) {

        let alert = UIAlertController(
            title: "系統通知",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(.init(title: "確定", style: .cancel))

        present(alert, animated: true, completion: nil)
    }

    func stopRefresh() {
        refreshControl.attributedTitle = nil
        refreshControl.endRefreshing()
    }
}

// MARK: - Binding

private extension MainViewController {

    func bind(_ viewModel: MainViewModelPrototype) {

        viewModel
            .output
            .infosModel
            .subscribe(onNext: {
                [weak self] in
                self?.infoModels = $0
            })
            .disposed(by: disposeBag)

        viewModel
            .output
            .title
            .bind(to: rx.title)
            .disposed(by: disposeBag)

        viewModel
            .output
            .showAlert
            .subscribe(onNext: {
                [weak self] in
                self?.showErrorAlert(by: $0)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        infoModels.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        infoModels[safe: section]?.images.image.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = PhotoCollectionViewCell.use(collection: collectionView, for: indexPath)
        let model = infoModels[indexPath.section].images.image[indexPath.item]

        cell.set(imageUrlString: model.src)

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        guard
            let header = collectionView
                .dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: "PhotoCollectionReusableHeaderView",
                    for: indexPath
                ) as? PhotoCollectionReusableHeaderView
        else {
            return .init()
        }

        let model = infoModels[indexPath.section]

        header.set(date: model.date)
        header.set(nameOfPlace: model.name)

        return header
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let height = scrollView.frame.size.height
        let contentOffsetY = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentOffsetY

        guard distanceFromBottom < height else { return }

        viewModel?.input.loadMore()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        guard refreshControl.isRefreshing else { return }

        refreshControl.attributedTitle = .init(string: "重新整理中...")
        viewModel?.input.reload()
    }
}
