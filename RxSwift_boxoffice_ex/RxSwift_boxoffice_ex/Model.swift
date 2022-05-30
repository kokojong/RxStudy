//
//  Model.swift
//  RxSwift_boxoffice_ex
//
//  Created by kokojong on 2022/05/28.
//

import Foundation

struct BoxOfficeResponse: Codable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Codable {
    let boxofficeType: String
    let showRange: String
    let dailyBoxOfficeList: [DailyBoxOffice]
}

struct DailyBoxOffice: Codable {
    let rank: String
    let movieNm: String
    let openDt: String
    let audiAcc: String
    
    enum CodingKeys: String, CodingKey {
        case rank
        case movieNm
        case openDt
        case audiAcc
    }
}
