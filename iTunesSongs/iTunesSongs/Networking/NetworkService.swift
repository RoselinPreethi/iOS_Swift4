//
//  NetworkService.swift
//  iTunesSongs
//
//  Created by Malini on 02/04/18.
//  Copyright © 2018 Roselin. All rights reserved.
//

import Foundation

typealias completionHandler = ([Track]?, String?) -> ()
typealias jsonResponse = [String:Any]

// start with a protocol

protocol NetworkServiceProtocol {
    func get(baseUrl:String, path:String, parameters:String, completion:@escaping completionHandler)
}


class NetworkService: NetworkServiceProtocol{
    
    var urlSession:URLSession!
    
    var urlSessionDataTask:URLSessionDataTask?
    
    var error:String?
    
    var tracks:[Track] = []
    
    func get(baseUrl: String, path: String, parameters: String, completion:@escaping completionHandler) {
        
       urlSessionDataTask?.cancel()
  
        
        if let urlComponents = NSURLComponents (string: baseUrl + path){
            
            urlComponents.query = parameters
            
            guard let url = urlComponents.url else {
                DispatchQueue.main.async {
                    completion(nil,"URL is nil")
                }
                return
            }
            
        //create URLSession class
            
        urlSession = URLSession(configuration: .default)
            
       urlSessionDataTask = urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let _error = error{
                self.error = "Webserivce failed with error \(_error.localizedDescription)"
            }
            else if let _data = data, let _response = response as? HTTPURLResponse, _response.statusCode == 200{
                self.parse(data: _data)
                DispatchQueue.main.async {
                    completion(self.tracks, self.error)
                }
            }
            else{
                self.error = "Webserivce failed with null data"
            }
            
            })
            
            urlSessionDataTask?.resume()
        }
        
    }
    
fileprivate func parse(data:Data){
    
    self.tracks.removeAll()
    self.error = nil
    
        var parseData:jsonResponse?
    
        do{
            parseData = try JSONSerialization.jsonObject(with:data, options: .allowFragments) as! jsonResponse
        }
        catch{
          self.error = "Parsing failed \(error.localizedDescription)"
        }
    if let _parsedData = parseData {
        
        if  let resultsArray = _parsedData["results"] as? [jsonResponse], resultsArray.count > 0 {
            
            for resultDic in resultsArray {
                let artistName = resultDic["artistName"] as? String
                let trackName = resultDic["trackName"] as? String
                let track = Track(artistName:artistName,trackName:trackName)
                self.tracks.append(track)
            }
       }
        else{
            self.error = "No Result found for searched keyword"
        }
}
}
}
