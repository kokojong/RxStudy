//
//  Service.swift
//  RxSwift_boxoffice_ex
//
//  Created by kokojong on 2022/05/29.
//

import Foundation
import RxSwift
import Moya
import RxMoya

enum ServiceAPI {
    case getBoxOffice(date: String)
}

let key = "f5eef3421c602c6cb7ea224104795888"

extension ServiceAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json")!
    }
    
    var path: String {
        switch self {
        case .getBoxOffice(let date):
//            return "?key=\(key)&targetDt=\(date)"
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBoxOffice(let date):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getBoxOffice(let date):
            return .requestParameters(parameters: ["key": key, "targetDt": date], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

struct Service {
    static let provider = MoyaProvider<ServiceAPI>()
    
    static func getBoxOffice(date: String) -> Single<BoxOfficeResponse> {
        return provider.rx
            .request(.getBoxOffice(date: date))
            .filterSuccessfulStatusCodes()
            .map(BoxOfficeResponse.self)
    }
    
}
