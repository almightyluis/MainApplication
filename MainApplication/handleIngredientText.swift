//
//  handleIngredientText.swift
//  MainApplication
//
//  Created by Luis Gonzalez on 1/1/20.
//  Copyright © 2020 Luis Gonzalez. All rights reserved.
//

import Foundation
import UIKit




// new plan, to have common ingredient to not show up on list,
// therefore, we can look up a ingredient that is not common
// new API

// need to figure out how to parse out common ingredients with CommonList.txt


struct Stack {
    private var myArray: [String] = []
    
    mutating func push(_ element: String) {
        myArray.append(element)
    }
    
    mutating func pop() -> String? {
        return myArray.popLast()
    }
    
    func peek() -> String {
        guard let topElement = myArray.last else {return "This stack is empty."}
        return topElement
    }
}

class handleIngredientText {
    
    var ingredients: String;
    var petaStack = [String]();
    final var foodVegan = "Nothing Found!";
    
    init(text: String) {
        self.ingredients = text;
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return text.filter {okayChars.contains($0) }
    }
    
    

    
    public func checkInstances(ingredients: [String], compArray :[String])->Int {
        var instances: Int = 0;
        
        for i in 0..<ingredients.count {
            for j in 0..<compArray.count {
                if(ingredients[i].contains(compArray[j])){
                    instances += 1;
                    break;
                }
            }
        }
        return instances
    }

    
    public func fillVegetarianStack()->[String] {
        var array = [String]();
        let path = Bundle.main.path(forResource: "CommonFoods", ofType: "txt");
        let fileMng = FileManager.default;
        if fileMng.fileExists(atPath: path!){
            do{
                let fullTexr = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8);
                let reading = fullTexr.components(separatedBy: "\n") as [String];
                for index in 0..<reading.count{
                    array.append(reading[index].uppercased());
                }
            }
        }
        return array;
    }
    

    
    public func returnCleanIngredients()->[String] {
        var i_array:[String] = ingredients.components(separatedBy: ";");
        var returnArray = [String]();
        if(i_array.count == 0){
            let ss = "Null";
            i_array[0] = ss;
            return i_array;
        }
        for i in 0..<i_array.count{
            let value = removeSpecialCharsFromString(text: i_array[i]);
            returnArray.append(value.uppercased());
        }
        return returnArray;
    }

    
    public func fillPetaStack()->[String]{
        var array = [String]();
        let path = Bundle.main.path(forResource: "List", ofType: "txt");
        let fileMng = FileManager.default;
        if fileMng.fileExists(atPath: path!) {
            do{
                let fullText = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8);
                let reading = fullText.components(separatedBy: "\n") as [String];
                for index in 0..<reading.count {
                    array.append(reading[index].uppercased());
                }
            }
        }
        else {
            print("Error on func", "fillStackPeta()" );
        }
        return array;
        
    }
  
    
    
    
    
}
