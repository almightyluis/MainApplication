//
//  newLabel.swift
//  MainApplication
//
//  Created by Luis Gonzalez on 12/31/19.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import Foundation
import UIKit


class newLable: UILabel {
    
    var name: String = "";
    let label = UILabel();
    
    init(name: String, size: Int?) {
        self.name = name;
        super.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    public func returnLable()->UILabel {
        let label = UILabel();
        label.textAlignment = .center;
        label.textColor = UIColor.white;
        label.font = UIFont(name: "Helvetica", size: 12);
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.numberOfLines = 2;
        label.sizeToFit();
        label.text = self.name;
        return label;
    }
    
    
    
}
