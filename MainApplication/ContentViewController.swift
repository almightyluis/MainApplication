//
//  contentViewController.swift
//  MainApplication
//
//  Created by Luis Gonzalez on 12/31/19.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import Foundation
import UIKit

class ContentViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    public var width = UIScreen.main.bounds.width;
    public var barcodePassed: String?;
    private var petaStack = [String]();
    private var ingredientStack = [String]();
    public let halfScreen = (UIScreen.main.bounds.width) / 2;
    private var dietTypesStack = UIStackView();
    public var progress = ProgressHUD(text: "Fetching ...");
    
    public var color_1 = "4ECDC4"; //teal
    public var color_2 = "1A535C";// dark teal
    public var color_3 = "F7FFF7"; // white
    public var color_4 = "FF6B6B"; // offset pink
    public var color_5 = "FFE66D";// yellow
    
    
    public var barcode: String = "";
    public var productName:String = "";
    public var companyName:String = "";
    public var foodID: String = "";
    public var foodImage: URL?;
    public var calories: String = "";
    public var protein: String = "";
    public var fat: String = "";
    public var choles: String = "";
    public var fiber: String = "";
    public var myArray: [String] = [""];

    
    private final var key:String = "fd4dbc4472a07df4c7440dcbe06d061a";
    private final var appID: String = "3a595cd5";
    
    
    public final var tryg = "https://api.edamam.com/api/food-database/parser?nutrition-type=logging&upc=860521000169&app_id=3a595cd5&app_key=fd4dbc4472a07df4c7440dcbe06d061a";
    
    private final var startOfLink:String = "https://api.edamam.com/api/food-database/parser?upc=";
    public final var endOfLink: String = "&app_id=3a595cd5&app_key=fd4dbc4472a07df4c7440dcbe06d061a";
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView();
        scrollView.backgroundColor = hexStringToUIColor(hex: self.color_3);
        scrollView.isScrollEnabled = true;
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height);
        return scrollView;
    }()
    
    lazy var productView: UIView = {
        let produce = UIView();
        produce.backgroundColor = UIColor.white
        produce.translatesAutoresizingMaskIntoConstraints = false;
        return produce;
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView();
        stackView.axis = .vertical;
        stackView.alignment = .trailing;
        stackView.spacing = 0.5;
        stackView.distribution = .fillEqually;
        stackView.sizeToFit();
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        return stackView;
    }()
    
    var produceStack: UIStackView = {
        let stackView = UIStackView();
        stackView.axis = .vertical;
        stackView.alignment = .trailing;
        stackView.spacing = 0.5;
        stackView.distribution = .fillEqually;
        stackView.sizeToFit();
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        return stackView;
    }()
    
    lazy var ingredientText: UITextView = {
        let text = UITextView();
        text.isEditable = false;
        text.isScrollEnabled = true;
        text.scrollsToTop = true;
        text.textColor = UIColor.white;
        text.font = UIFont(name: "Helvetica", size: 12);
        text.translatesAutoresizingMaskIntoConstraints = false;
        text.backgroundColor = hexStringToUIColor(hex: self.color_1);
        text.isSelectable = true;
        
        return text;
    }()

    lazy var scrollViewContainer : UIView = {
        let view = UIView();
        view.backgroundColor = hexStringToUIColor(hex: self.color_4);
        view.frame = CGRect(x: 50, y: 0, width: UIScreen.main.bounds.width, height: 200);
        view.layer.cornerRadius = 5;
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view;
    }()
    
    lazy var scrollViewInnerContainer : UIScrollView = {
        let scroll = UIScrollView();
        scroll.translatesAutoresizingMaskIntoConstraints = false;
        scroll.isScrollEnabled = true;
        scroll.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height);
        return scroll;
    }()
    
    lazy var myTableView: UITableView = {
        var myTableView = UITableView();
        myTableView.translatesAutoresizingMaskIntoConstraints = false;
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.backgroundColor = hexStringToUIColor(hex: self.color_3);
        myTableView.rowHeight = UITableView.automaticDimension;
        return myTableView;
    }()
    
    lazy var scrollViewInnerTable: UIScrollView = {
        let view = UIScrollView();
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.isScrollEnabled = true;
        return view;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.addSubview(scrollView);
        scrollView.contentSize = CGSize(width: width, height: 1000);
        scrollViewConstraints();
        scrollView.addSubview(productView);
        productViewConstraints();
        scrollView.addSubview(horizontalLine);
        horizontalLine.anchorView(top: productView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 20, bottom: 0, right: 20) );
        horizontalLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true;
        
        
        productView.addSubview(stackView);
        stackViewConstraints();
        productView.addSubview(productImage);
        imageConstraints();
        scrollView.addSubview(ingredientLabel);
        scrollView.addSubview(ingredientText);
        constraintsIngredients();
        
        scrollView.addSubview(ingredientVerdict);
        problemTextConstraints();
        
        scrollView.addSubview(productResponceView);
        produceResponce();
        
        stackView.addSubview(horizontalLineStack);

        
        horizontalLineStack.anchorView(top: productResponceView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 20, bottom: 0, right: 20), size: .init(width: width, height: 0.5));
        
        scrollView.addSubview(scrollViewContainer);
        c_scrollViewContainer();
        scrollViewContainer.addSubview(scrollViewInnerContainer);
        c_scrollViewInnerContainer();
        scrollViewInnerContainer.addSubview(dietTypesStack);
        dietTypesConstaints();
        productResponceView.addSubview(scrollViewInnerTable);
        scrollViewInnerTableConstraints();
        
        scrollViewInnerTable.addSubview(myTableView);
        scrollView.addSubview(imageViewForCredit);
        imageCreditConstraints();
        myTableViewConstraints();
        attemptRequest();
          
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        view.addSubview(progress);
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)");
        print("Value: \(myArray[indexPath.row])");
    
        let message = UIAlertController(title: "Search", message: "Lets define :" + myArray[indexPath.row], preferredStyle: .alert);
        let action = UIAlertAction(title: "Ok", style: .default, handler: { (_) in self.searchCurrentWord(value: self.myArray[indexPath.row]) });
        message.addAction(action);
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        message.addAction(noAction);
        self.present(message, animated: true, completion: nil);
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath);
        cell.textLabel!.font = UIFont(name: "Helvetica", size: 10);
        cell.textLabel!.textColor = hexStringToUIColor(hex: self.color_2);
        cell.textLabel!.text = "\(myArray[indexPath.row])";
        cell.contentView.backgroundColor = hexStringToUIColor(hex: self.color_3);
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20.0;//Choose your custom row height
    }
    
    public func addtoProduceStack()->Void {
        
    }
    
    var imageViewForCredit: UIImageView = {
       let imageView = UIImageView();
       imageView.image = UIImage(named: "credit");
       imageView.translatesAutoresizingMaskIntoConstraints = false;
       return imageView;
    }()
    
    public func imageCreditConstraints()->Void {
        imageViewForCredit.anchorView(top: scrollViewContainer.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 5, left: 5, bottom: 0, right: 0), size: .init(width: halfScreen, height: 50));
    }
    
    public func searchCurrentWord(value :String)->Void{
        let wordLookup = value.lowercased();
        print(wordLookup);
        if(wordLookup.isEmpty) {
            let alert = UIAlertController(title: "Error", message: "We cannot find the current word selected", preferredStyle: .alert);
            let alertButton = UIAlertAction(title: "Return", style: .cancel, handler: nil);
            alert.addAction(alertButton);
            self.present(alert, animated: true, completion: nil);
        } else{
            self.presentViewWithData(name: wordLookup);
        }
    }
    
    // PresentView
    // @Void Function
    public func presentViewWithData(name: String)->Void{
        DispatchQueue.main.async {
            let viewController = UIStoryboard(name: "Main", bundle: Bundle.main);
            guard let destination = viewController.instantiateViewController(identifier: "infoscreen") as? informationScreen else {
                return;
            }
            
            destination.currentName = name;
            destination.modalPresentationStyle = .pageSheet;
            self.present(destination, animated: true, completion: nil);
        }
    }
    
    // Attempt Request
    // Error will promp message & return user
    public func attemptRequest()->Void {
    guard let url = URL(string: startOfLink+barcodePassed!+endOfLink) else { return print("Error URL");}
        let session = URLSession.shared;
        
        session.dataTask(with: url)
        { (data, response, error) in
            let code = response as? HTTPURLResponse;
            switch (code?.statusCode) {
            case 200:
                print("OK");
            case 404:
                self.returnHome();
                session.invalidateAndCancel();
                print("Error Not found");
                return;
            case 422:
                session.invalidateAndCancel();
                print("Cannot parse");
                return;
            default:
                self.returnHome();
                session.invalidateAndCancel();
                return;
            }
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(dataRoot.self, from: data);
                    self.showData(jsonObject: json);
                        
                } catch{
                    print("Catch");
                    self.returnHome();
                    return;
                }
            }
            if let error = error {
                print("error block",error);
                session.invalidateAndCancel();
                self.returnHome();
            }
        }.resume();
    }
    
    // Using decodable and function attempRequest()->Void we parse values
    // Load Image & Download Image
    private func showData(jsonObject: dataRoot)->Void{
        
        guard let companyName = jsonObject.hints[0].food.label else {return }
        guard let companyTitle = jsonObject.hints[0].food.brand else {return }
        guard let foodID = jsonObject.hints[0].food.brand else {return }
        guard let image = jsonObject.hints[0].food.image else {return }
        guard let ingredientsString = jsonObject.hints[0].food.foodContentsLabel else {return }
        
        if(image.isEmpty || image == ""){
            DispatchQueue.main.async() {
                self.productImage.image = UIImage(named: "noImage");
            }
        }else{
            let url: URL = URL(string: image)!;
            downloadImage(from: url);
        }
        if(String(companyName).isEmpty || String(foodID).isEmpty || String(ingredientsString).isEmpty) {
            let errorMessage = userMessage(title: "Cannot find foodID", message: "Fatal Error");
            self.present(errorMessage, animated: true, completion: nil);
            return;
        }
        
        DispatchQueue.main.async {
            self.barcodeLabel.text = self.barcodePassed;
            self.containerName.text = companyName;
            self.containerCompanyName.text = companyTitle;
            self.ingredientText.text = ingredientsString;
            self.containerSuccess.text = "Success";
            
        }
        showFinalData(str: ingredientsString);
    }
    
    //
    private func showFinalData(str: String)->Void {
        let ingredints = handleIngredientText(text: str);
        let arr = ingredints.returnCleanIngredients();
        DispatchQueue.main.async {
            self.myArray = arr;
            self.myTableView.reloadData();
            self.progress.removeFromSuperview();
        }
    }
    
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // Download Image function, Sets: productImage image
    // @return Void
    private func downloadImage(from url: URL)->Void{
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return  }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.productImage.image = UIImage(data: data);
            }
        }
        
    }
    // Return Home function, Alerts User for error
    //@return Void
    // Please fix to be universal
    private func returnHome()->Void{
            // add action to go home here
        let error = UIAlertController(title: "Error", message: "Barcode Does not exist on database", preferredStyle: .alert);
            let action = UIAlertAction(title: "Return", style: .cancel, handler: { (_) in
                self.navigationController?.popViewController(animated: true) });
        error.addAction(action);
        self.present(error, animated: true, completion: nil);
    }
    
    private func userMessage(title: String, message: String)->UIAlertController {
        let alertController = UIAlertController(title: title
            , message: message, preferredStyle: .alert);
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
        self.navigationController?.popViewController(animated: true) });
        alertController.addAction(action);
        return alertController;
    }
    
    
    public var productResponceView: UIView = {
        let responceView = UIView();
        responceView.backgroundColor = UIColor.red;
        responceView.translatesAutoresizingMaskIntoConstraints = false;
        return responceView;
    }()
   
    public var productImage: UIImageView = {
        let imageView = UIImageView();
        imageView.contentMode = .scaleAspectFit;
        imageView.backgroundColor = UIColor.clear;
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        return imageView;
    }()
    
    public var productStatus: UIImageView = {
        let imageView = UIImageView();
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.backgroundColor = UIColor.blue;
        return imageView;
    }()
    
    public lazy var ingredientLabel : UILabel = {
        var label = UILabel();
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 40);
        label.text = "Ingredients";
        label.textColor = hexStringToUIColor(hex: self.color_4);
        label.font = UIFont(name: "Courier", size: 14);
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label;
    }()
    
    public lazy var ingredientVerdict : UILabel = {
        var label = UILabel();
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 40);
        label.text = "Look up items here";
        label.numberOfLines = 2;
        label.textColor = hexStringToUIColor(hex: self.color_4);
        label.font = UIFont(name: "Courier", size: 14);
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label;
    }()
    
    public var containerName : UILabel = {
        var label = UILabel();
        label.textAlignment = .left;
        label.textColor = UIColor.gray;
        label.font = UIFont(name: "Helvetica", size: 11);
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.numberOfLines = 1;
        label.sizeToFit();
        label.text = "Product name";
        return label;
    }()
    public var containerCompanyName : UILabel = {
        var label = UILabel();
        label.text = "Company name";
        label.numberOfLines = 1;
        label.textColor = UIColor.gray;
        label.font = UIFont(name: "Helvetica", size: 11);
        label.textAlignment = .right;
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label;
    }()
    
    public var containerSuccess : UILabel = {
        var label = UILabel();
        label.numberOfLines = 1;
        label.textColor = UIColor.gray;
        label.text = "Fail or Success";
        label.font = UIFont(name: "Helvetica", size: 11);
        label.textAlignment = .right;
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label;
    }()
    
    public var barcodeLabel : UILabel = {
        var label = UILabel();
        label.text = "Barcode";
        label.numberOfLines = 1;
        label.textColor = UIColor.gray;
        label.font = UIFont(name: "Helvetica" , size: 11);
        label.textAlignment = .right;
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label;
    }()

    
    lazy var horizontalLine : UIView = {
        let line = UIView();
        line.translatesAutoresizingMaskIntoConstraints = false;
        line.backgroundColor = hexStringToUIColor(hex: self.color_4);
        return line;
    }()
    
    lazy var horizontalLineIngred : UIView = {
        let line = UIView();
        line.translatesAutoresizingMaskIntoConstraints = false;
        line.backgroundColor = hexStringToUIColor(hex: self.color_4);
        return line;
    }()
    
    lazy var horizontalLineStack:  UIView = {
           let line = UIView();
           line.translatesAutoresizingMaskIntoConstraints = false;
        line.backgroundColor = hexStringToUIColor(hex: self.color_4);
           return line;
       }()

    
    func dietTypesConstaints(){
         let vegan = horizontalViews(name: "Vegan", description: "A person who does not eat or use animal products and or byproducts, including bees and insects.", imagePath: "vegan", frame: .init(x: 0, y: 0, width: 150, height: 160));
         let vegetarian = horizontalViews(name: "Vegetarian", description: "A person who does not eat meat, and sometimes other animal products, especially for moral, religious, or health reasons. This includes but not limited to milk cheese etc.", imagePath: "vegetarian", frame: .init(x: 0, y: 0, width: 150, height: 160));
         let pescetarian = horizontalViews(name: "Pescetarian", description: "A person who does not eat meat but does eat fish.", imagePath: "fish", frame: .init(x: 0, y: 0, width: 150, height: 160));
         let meat = horizontalViews(name: "Meat Eater", description: "An animal that feeds on another animal.", imagePath: "meat", frame: .init(x: 0, y: 0, width: 150, height: 160));
         let help = horizontalViews(name: "Help Us Improve", description: "Hi there, thanks for using my app. To help this application improve email us any bugs you encounter. Please and Thank You!", imagePath: "help", frame: .init(x: 0, y: 0, width: 150, height: 160));
         let sumOfViews = (vegetarian.frame.size.width) + (vegan.frame.size.width) + (pescetarian.frame.size.width) + (meat.frame.size.width) + (help.frame.size.width) + 300;
         
         scrollViewInnerContainer.contentSize = CGSize(width: sumOfViews, height: 170);
         print("the sum is", sumOfViews);
         
         dietTypesStack.translatesAutoresizingMaskIntoConstraints = false;
         dietTypesStack.axis  = NSLayoutConstraint.Axis.horizontal;
         dietTypesStack.distribution  = UIStackView.Distribution.equalSpacing;
         dietTypesStack.alignment = UIStackView.Alignment.leading
         dietTypesStack.spacing   = 8.0;
         dietTypesStack.addArrangedSubview(vegan);
         dietTypesStack.addArrangedSubview(vegetarian);
         dietTypesStack.addArrangedSubview(pescetarian);
         dietTypesStack.addArrangedSubview(meat);
         dietTypesStack.addArrangedSubview(help);
         dietTypesStack.topAnchor.constraint(equalTo: scrollViewInnerContainer.topAnchor, constant: 5).isActive = true;
     }
    
    func myTableViewConstraints() {
        myTableView.anchorView(top: productResponceView
            .topAnchor, leading: productResponceView.leadingAnchor, bottom: productResponceView.bottomAnchor, trailing: productResponceView.trailingAnchor, size: .init(width: productResponceView.bounds.width, height: productResponceView.bounds.height));
        let height: CGFloat = 10.0;
        let sumOfHeights = height * CGFloat(myArray.count);
        scrollViewInnerTable.contentSize = CGSize(width: productResponceView.bounds.width, height: sumOfHeights);
    }
    
    func scrollViewInnerTableConstraints() {
        scrollViewInnerTable.anchorView(top: productResponceView.topAnchor
        , leading: productResponceView.leadingAnchor
        , bottom: productResponceView.bottomAnchor, trailing: productResponceView.trailingAnchor, size: .init(width: halfScreen, height: productResponceView.bounds.height));
    }
    func produceResponce(){
        productResponceView.anchorView(top: ingredientVerdict.bottomAnchor
            , leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 3, bottom: 0, right: 3), size: .init(width: width, height: 200));
    }
    
    func imageConstraints(){
        productImage.anchorView(top: productView.topAnchor, leading: nil, bottom: productView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 50, right: 0), size: .init(width: 200, height: 100));
        productImage.centerXAnchor.constraint(equalTo: productView.centerXAnchor).isActive = true;
    }
    
    func c_scrollViewInnerContainer() {
        scrollViewInnerContainer.backgroundColor = hexStringToUIColor(hex: color_3);
        scrollViewInnerContainer.topAnchor.constraint(equalTo: scrollViewContainer.topAnchor, constant: 0).isActive = true;
        scrollViewInnerContainer.bottomAnchor.constraint(equalTo: scrollViewContainer.bottomAnchor, constant: 0).isActive = true;
        scrollViewInnerContainer.leadingAnchor.constraint(equalTo: scrollViewContainer.leadingAnchor, constant: 0).isActive = true;
        scrollViewInnerContainer.trailingAnchor.constraint(equalTo: scrollViewContainer.trailingAnchor, constant: 0).isActive = true;
    }
    
    func c_scrollViewContainer() {
        scrollViewContainer.topAnchor.constraint(equalTo: horizontalLineStack.bottomAnchor, constant: 20).isActive = true;
        scrollViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true;
        scrollViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true;
        scrollViewContainer.heightAnchor.constraint(equalToConstant: 170).isActive = true;
    }
    
    private func problemTextConstraints() {
        ingredientVerdict.anchorView(top: ingredientText.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 15, left: 10, bottom: 0, right: 5));
    }
    
    private func constraintsIngredients() {
        ingredientLabel.anchorView(top: horizontalLine.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 10, bottom: 0, right: 5));
        ingredientText.anchorView(top: ingredientLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 2, left: 10, bottom: 0, right: 10), size: .init(width: width, height: 150));
    }

    private func stackViewConstraints() {
        stackView.anchorView(top: nil, leading: productView.safeAreaLayoutGuide.leadingAnchor, bottom: productView.bottomAnchor, trailing: productView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 1, right: 3), size: .init(width: halfScreen, height: productView.bounds.height));
        stackView.addArrangedSubview(barcodeLabel);
        stackView.addArrangedSubview(containerSuccess);
        stackView.addArrangedSubview(containerCompanyName);
        stackView.addArrangedSubview(containerName);
    }
    
    private func productViewConstraints(){
        productView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true;
        productView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true;
        productView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true;
        productView.heightAnchor.constraint(equalToConstant: 235).isActive = true;
        productView.widthAnchor.constraint(equalToConstant: width).isActive = true;
    }
    
    private func scrollViewConstraints() {
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true;
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true;
    }
    // @Param string hex
    // @ Return UIColor
    public func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

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
    var image: String?;
}





