//
//  TargetType.swift
//  TravelAlbum
//
//  Created by Fish Shih on 2021/11/26.
//

import Foundation
import Moya

protocol DecodableResponseTargetType: TargetType {

  associatedtype ResponseType: Codable
}

protocol TATargetType: DecodableResponseTargetType {

    var decisions: [Decision] { get }
}

extension TATargetType {

    var baseURL: URL {
        guard let url = URL(string: "https://travel.tycg.gov.tw/open-api/zh-tw/") else {
            assert(false)
        }
        return url
    }

    var headers: [String: String]? {
        ["accept": "application/json"]
    }

    var decisions: [Decision] {
        [
            ResponseStatusCodeDecision(),
            ParseResultDecision(),
        ]
    }
}
