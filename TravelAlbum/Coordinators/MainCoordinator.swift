// 
//  MainCoordinator.swift
//  TravelAlbum
//
//  Created by Fish Shih on 2021/11/26.
//

import UIKit
import RxSwift
import RxCocoa

class MainCoordinator: Coordinator<Void> {

    // MARK: - Life cycle

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {

        let vc = MainViewController()
        navigationController = UINavigationController(rootViewController: vc)
        let viewModel = MainViewModel(api: TravelAlbumAPI())

        rootViewController = vc
        vc.viewModel = viewModel

        window.rootViewController = navigationController
    }

    // MARK: - Private

    private let window: UIWindow
    private let updateEvent = PublishRelay<Void>()
}
