//
//  TravelAlbumAPI.swift
//  TravelAlbum
//
//  Created by Fish Shih on 2021/11/26.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

private struct RequestTargetType: TATargetType {

    typealias ResponseType = AlbumModel

    // Parameters
    let page: Int

    var path: String {
        "Media/Album"
    }

    var method: Moya.Method {
        .get
    }

    var task: Task {
        .requestParameters(
            parameters: ["": page],
            encoding: URLEncoding.default
        )
    }
}

protocol TravelAlbumAPIPrototype {

    var result: Observable<Result<AlbumModel, ResponseError>> { get }

    func fetch(page: Int)
}

struct TravelAlbumAPI: TravelAlbumAPIPrototype {

    var result: Observable<Result<AlbumModel, ResponseError>> { _result.asObservable() }

    func fetch(page: Int) {
        MoyaProvider<RequestTargetType>().send(
            request: RequestTargetType(page: page)
        ) {
            switch $0 {
            case .success(let model):
                self._result.accept(.success(model))
            case .failure(let error):
                print("🛠 \(#fileID) API Error: ", error)
                let error = error as? ResponseError ?? .unknownError(error: error)
                self._result.accept(.failure(error))
            }
        }
    }

    private let _result = PublishRelay<Result<AlbumModel, ResponseError>>()
}
