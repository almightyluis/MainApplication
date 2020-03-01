//
//  ConstructApiCall.swift
//  MainApplication
//
//  Created by Luis Gonzalez on 1/31/20.
//  Copyright © 2020 Luis Gonzalez. All rights reserved.
//

import Foundation
import UIKit


struct rootDataWord: Decodable {
    var definitions: [definitions];
}
struct definitions: Decodable {
    var definition: String?;
}


class ConstructApiCall {
    var urlFront = "https://wordsapiv1.p.rapidapi.com/words/";
    var urlFinal: String;
    var urlEnd = "/definitions";
    var word: String = "";
    public var returnValues = [String]();
    
    init(currentWord: String) {
        self.word = currentWord;
        urlFinal = urlFront+word+urlEnd;
    }
    
    typealias CompletionHandler = (_:Bool) -> Void;
    public func attemptApiCall(completion: @escaping CompletionHandler) {
        
        var finshed = false;
        let cleanURL = urlFinal.replacingOccurrences(of: " ", with: "");
        print(cleanURL);
        let headers = [
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com",
            "x-rapidapi-key": "c2a7d0b731msh97fb3007346a4c8p14462djsn5a0b338d43b5"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: cleanURL)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error)->Void in
            let code = response as? HTTPURLResponse;
            switch (code?.statusCode) {
            case 200:
                print("OK");
            case 404:
                session.invalidateAndCancel();
                print("Error Not found");
                DispatchQueue.main.async {
                    completion(finshed);
                }
                return;
            case 422:
                session.invalidateAndCancel();
                print("Cannot parse");
                DispatchQueue.main.async {
                    completion(finshed);
                }
                return;
            default:
                session.invalidateAndCancel();
                DispatchQueue.main.async {
                    completion(finshed);
                }
                return;
            }
            if let data = data {
                do{
                    print(data);
                    let json = try JSONDecoder().decode(rootDataWord.self, from: data);
                    if (json.definitions.count == 0 || json.definitions.isEmpty ){return ;}
                    for i in 0..<json.definitions.count {
                        let value = json.definitions[i].definition;
                        self.returnValues.append(value!);
                    }
                    if (self.returnValues.count >= 1){
                        finshed = true;
                        completion(finshed);
                    }
                    else if(self.returnValues.count == 0){
                        completion(finshed);
                    }
                    
                }
                catch {
                    print("No Data Catch");
                    DispatchQueue.main.async {
                        completion(finshed);
                    }
                }
            }
            
            if let error = error {
                print("Error Construct API", error);
                DispatchQueue.main.async {
                    completion(finshed);
                }
            }
        })
        dataTask.resume();
    }
    
    
    

}
