//
//  GetWikiData.swift
//  WhatFlower
//
//  Created by Sai Naveen Katla on 26/09/20.
//

import Foundation
import Alamofire
import SwiftyJSON

struct GetWikiData {
    let baseURL = "https://en.wikipedia.org/w/api.php"
    
    func getDetails(for name: String) -> String {
        let parameters : [String:String] = [
          "format" : "json",
          "action" : "query",
          "prop" : "extracts",
          "exintro" : "",
          "explaintext" : "",
          "titles" : name,
          "indexpageids" : "",
          "redirects" : "1",
          ]
        var ans = "error"
        Alamofire.request(baseURL, method: .get, parameters: parameters).response { (response) in
            
            if (response.request != nil) {
                print("here3")
                let flowerJson: JSON = JSON(response.request!.value)
                let pageid = flowerJson["query"]["pageids"][0].stringValue
                
                let extract = flowerJson["query"]["ages"][pageid]["extract"].stringValue
                ans = extract
//                let responses = response as! Data
//                print(String(data: responses, encoding: .utf8))
                print("here4")
            }
            
        }
        
        
        
////        print(baseURL+name)
//        if let Url = URL(string: baseURL) {
//            print(Url)
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: Url) { (data, response, error) in
//                if error == nil {
//                    if let safedata = data {
//                        print(safedata)
////                        ParseData(data: safedata)
//                    }
//                }
//                else {
//                    print(error)
//                    print("here2")
//                }
//            }
//            task.resume()
//        }
        
        return ans
    }
    
    func ParseData(data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Model.self, from: data)
            let pageid = decodedData.query.pageids[0]
            print(pageid)
            let extract = decodedData.query.pages.ids.extract
            print(extract)
        }
        catch {
            print(error)
        }
    }
    
}
