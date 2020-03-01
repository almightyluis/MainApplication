//
//  edamamApi.swift
//  MainApplication
//
//  Created by Luis Gonzalez on 1/1/20.
//  Copyright © 2020 Luis Gonzalez. All rights reserved.
//

import Foundation
import UIKit


struct dataRoot: Decodable {
    var hints: [hints];
    var text: String?;
}
struct hints: Decodable {
    var food: food;
}

struct food: Decodable {
    var foodId: String?;
    var label: String?;
    var brand: String?;
    var foodContentsLabel: String?;
    var image: URL?;
}



class edamamApi {
    
    public var ingredients = [String]();
    public var barcode: String = "";
    public var productName:String = "";
    public var companyName:String = "";
    public var foodID: String = "";
    public var foodImage: URL?;
    
    private final var key:String = "fd4dbc4472a07df4c7440dcbe06d061a";
    private final var appID: String = "3a595cd5";
    
    private final var startOfLink:String = "https://api.edamam.com/api/food-database/parser?upc=";
    public final var endOfLink: String = "&app_id=3a595cd5&app_key=fd4dbc4472a07df4c7440dcbe06d061a";
    
    init(upc: String) {
        self.barcode = upc;
        
    }
    
    public func attemptRequest() {
        
        let url = URL(string: self.startOfLink+self.barcode+self.endOfLink);
        
        print(self.startOfLink+self.barcode+self.endOfLink);
        let session = URLSession.shared;
        
        session.dataTask(with: url!)
        { (data, response, error) in

            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("response",response);
                return;
            }
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(dataRoot.self, from: data);
                        
                } catch{
                    
                    print("Catch");
                }
                
            }
            if let error = error {
                print("error block",error);
            }
        }.resume();
    }
        
    
}
