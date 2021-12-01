//
//  AlbumModel.swift
//  TravelAlbum
//
//  Created by Fish Shih on 2021/11/26.
//

import Foundation

// MARK: - AlbumModel

struct AlbumModel: Codable {

    let infos: AlbumInfosModel

    enum CodingKeys: String, CodingKey {
        case infos = "Infos"
    }
}

// MARK: - AlbumInfosModel

struct AlbumInfosModel: Codable {

    let declaration: AlbumDeclarationModel
    let info: [AlbumInfoModel]

    enum CodingKeys: String, CodingKey {
        case declaration = "Declaration"
        case info = "Info"
    }
}

// MARK: - AlbumDeclarationModel

struct AlbumDeclarationModel: Codable {

    let orgname, siteName, total: String
    let officialWebSite: String
    let updated: String

    enum CodingKeys: String, CodingKey {
        case orgname = "Orgname"
        case siteName = "SiteName"
        case total = "Total"
        case officialWebSite = "Official-WebSite"
        case updated = "Updated"
    }
}

// MARK: - AlbumInfoModel

struct AlbumInfoModel: Codable {

    let id, tyWebsite, name: String
    let images: AlbumImagesModel
    let posted, modified: String

    var date: Date? {
        modified.formatAsDate()
    }

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case tyWebsite = "TYWebsite"
        case name = "Name"
        case images = "Images"
        case posted = "Posted"
        case modified = "Modified"
    }
}

// MARK: - AlbumImagesModel

struct AlbumImagesModel: Codable {

    let image: [AlbumImageDataModel]

    enum CodingKeys: String, CodingKey {
        case image = "Image"
    }
}

// MARK: - AlbumImageDataModel

struct AlbumImageDataModel: Codable {

    let src, subject, ext: String

    enum CodingKeys: String, CodingKey {
        case src = "Src"
        case subject = "Subject"
        case ext = "Ext"
    }
}
