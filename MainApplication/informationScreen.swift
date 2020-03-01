//
//  informationScreen.swift
//  MainApplication
//
//  Created by Luis Gonzalez on 1/31/20.
//  Copyright © 2020 Luis Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import WebKit


class informationScreen: UIViewController, UIGestureRecognizerDelegate, WKUIDelegate {

    var currentName: String = "";
    var definitionsArray = [String]();
    var webView: WKWebView!;
    var progressView = ProgressHUD(text: "Loading..");
    
    lazy var productView: UIView = {
           let produce = UIView();
           produce.backgroundColor = UIColor.white;
           produce.translatesAutoresizingMaskIntoConstraints = false;
           return produce;
    }()
    
    lazy var horizontalLine : UIView = {
        let line = UIView();
        line.translatesAutoresizingMaskIntoConstraints = false;
        line.backgroundColor = UIColor.black;
        return line;
    }()
    lazy var wordLabel: UILabel = {
        let label = UILabel();
        label.font = UIFont(name: "Helvetica", size: 16);
        label.backgroundColor = UIColor.lightGray;
        label.textColor = UIColor.black;
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label;
    }()
    
    var tap: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad();
        let myURL = URL(string: prepSearch(word: currentName));
        let myRequest = URLRequest(url: myURL!);
        webView.load(myRequest)
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self;
        view = webView
        switch webView.isLoading {
        case true:
            progressView.show();
            break;
        case false:
            progressView.hide();
            break;
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tap = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.cancelsTouchesInView = false
        tap.delegate = self
        self.view.window?.addGestureRecognizer(tap)
        view.addSubview(progressView);
    }
    var textBox: UITextView = {
        let textBox = UITextView();
        textBox.backgroundColor = UIColor.lightGray;
        textBox.textColor = UIColor.black;
        return textBox;
    }()
    

    // As of now we assume user is in 'en'
    public func prepSearch(word: String)->String{
        let directory = "https://en.wikipedia.org/wiki/";
        let searchWord = word.replacingOccurrences(of: " ", with: "_");
        print(directory+searchWord);
        return directory+searchWord;
    }
    
    
    public func setText() {
        var stringBuilder = "";
        for i in 0..<definitionsArray.count {
            stringBuilder += "\(definitionsArray[i])"
        }
        textBox.text = stringBuilder;
        
    }
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: self.view)

        if self.view.point(inside: location, with: nil) {
            return false
        }
        else {
            return true
        }
    }

    @objc private func onTap(sender: UITapGestureRecognizer) {

        self.view.window?.removeGestureRecognizer(sender)
        self.dismiss(animated: true, completion: nil)
    }
    
}
