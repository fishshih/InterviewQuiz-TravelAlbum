// 
//  MainViewModel.swift
//  TravelAlbum
//
//  Created by Fish Shih on 2021/11/26.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Prototype

protocol MainViewModelInput {
    func reload()
    func loadMore()
}

protocol MainViewModelOutput {
    var title: Observable<String?> { get }
    var infosModel: Observable<[AlbumInfoModel]> { get }
    var showAlert: Observable<String> { get }
}

protocol MainViewModelPrototype {
    var input: MainViewModelInput { get }
    var output: MainViewModelOutput { get }
}

// MARK: - View model

class MainViewModel: MainViewModelPrototype {

    var input: MainViewModelInput { self }
    var output: MainViewModelOutput { self }

    init(api: TravelAlbumAPIPrototype?) {

        self.api = api

        guard let api = self.api else { return }

        bind(api: api)
    }

    private let api: TravelAlbumAPIPrototype?

    private let page = BehaviorRelay<Int>(value: 1)
    private let _title = BehaviorRelay<String?>(value: nil)
    private let models = BehaviorRelay<[AlbumInfoModel]>(value: [])
    private let _showAlert = PublishRelay<String>()

    private var isLoading = true

    private let disposeBag = DisposeBag()
}

// MARK: - Input & Output

extension MainViewModel: MainViewModelInput {

    func reload() {
        page.accept(1)
    }

    func loadMore() {

        guard !isLoading else { return }

        isLoading = true
        page.accept(page.value + 1)
    }
}

extension MainViewModel: MainViewModelOutput {

    var title: Observable<String?> {
        _title.asObservable()
    }

    var infosModel: Observable<[AlbumInfoModel]> {
        models.asObservable()
    }

    var showAlert: Observable<String> {
        _showAlert.asObservable()
    }
}

// MARK: - Private function

private extension MainViewModel {

    func bind(api: TravelAlbumAPIPrototype) {

        api
            .result
            .subscribe(onNext: {
                [weak self] result in

                guard let self = self else { return }

                self.isLoading = false

                switch result {
                case .success(let model):

                    if self._title.value == nil {
                        self._title.accept(model.infos.declaration.siteName)
                    }

                    let infoModels = self.models.value + model.infos.info

                    self.models.accept(infoModels)

                case .failure(let error):
                    self._showAlert.accept(error.message)
                }
            })
            .disposed(by: disposeBag)

        page
            .subscribe(onNext: {
                api.fetch(page: $0)
            })
            .disposed(by: disposeBag)
    }
}
