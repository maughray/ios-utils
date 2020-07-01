//
//  ExercisesService.swift
//  PROFitness
//
//  Created by Victor on 12/10/18.
//  Copyright © 2018 Victor. All rights reserved.
//
import Foundation
import Alamofire
import ObjectMapper

struct RequestService<T: BaseMappable>
{
    typealias RequestServiceResult = (([T]?) -> Void)?
    private typealias HeadersParsingCompletion = (([String : String]) -> Void)?
    
    static func retrieveData(type: T.Type, url: String, completion: RequestServiceResult)
    {
        retrieveRequestHeaders { headers in
            
            request(url,
                method: .get,
                parameters: nil,
                encoding: URLEncoding(destination: .httpBody),
                headers: headers)
            .validate()
            .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                
                if response.response?.statusCode == StatusCode.unathorized
                {
                    UserAuth.shared.refreshAccessToken {
                        self.retrieveData(type: type, url: url, completion: completion)
                    }
                }
                else {
                    processRequestResponse(response, completion: completion)
                }
            })
        }
    }
    
    private static func processRequestResponse(_ response: DataResponse<Any>, completion: RequestServiceResult)
    {
        switch response.result
        {
        case .success(let json):
            if let result = Mapper<T>().mapArray(JSONObject: json) {
                completion?(result)
            } else if let result = Mapper<T>().map(JSONObject: json) {
                completion?([result])
            }
        default:
            completion?(nil)
        }
    }
    
    private static func retrieveRequestHeaders(completion: HeadersParsingCompletion)
    {
        UserAuth.shared.retrieveToken(completion: { token in
            
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            completion?(headers)
        })
    }
}
