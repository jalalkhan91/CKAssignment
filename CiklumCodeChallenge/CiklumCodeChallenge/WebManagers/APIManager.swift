//
//  APIManager.swift
//  CiklumCodeChallenge
//
//  Created by Jalal Khan on 23/11/2019.
//  Copyright © 2019 Jalal Khan. All rights reserved.
//

import Foundation
import Alamofire

final class APIManager
{
    // Can't init is singleton
    private init() { }
    
    // MARK: Shared Instance
    static let shared = APIManager()

    var httpHandler: HttpHandler =  HttpHandler.shared
    
    
    //MARK: -  API's
    
    // Get Movies Data API
    func getMoviesData(_ pageNumber:Int, searchString:String, completion : @escaping (_ isSuccessful: Bool, _ errorMessage : String?, _ arrResults : [MoviesDataResult]?) -> Void) {
        
        let url = URLs.k_BASE_URL+searchString+"&page="+"\(pageNumber)"
        
        let reqParams: requestParameters = requestParameters(url: url, method: .get, parameters: nil, headers: nil)
        print(url)
        httpHandler.AlamoFireRequest(rp: reqParams) { (resJson, error) in
            
            if resJson != nil {
                do {
                    let response = try JSONDecoder().decode(MoviesData.self, from: resJson as! Data)
                    completion(true,nil,response.results)
                } catch {
                    print(error)
                    completion(false,error.localizedDescription, nil)
                }
            }
            else{
                completion(false, error?.localizedDescription, nil)
            }
        }
    }
    
    
}

