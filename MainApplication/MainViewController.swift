//
//  ViewController.swift
//  MainApplication
//
//  Created by Luis Gonzalez on 12/31/19.
//  Copyright © 2019 Luis Gonzalez. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var video = AVCaptureVideoPreviewLayer();
    var session = AVCaptureSession();
    var output = AVCaptureMetadataOutput();
    var screenWidth = UIScreen.main.bounds.width;
    var scanner:String? = nil;
    var scannerManual:String? = nil;
    var scannerArray = [String]();
    public final var imageCount: Int = 16;
    
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView();
        imageView.backgroundColor = UIColor.clear;
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.contentMode = .scaleAspectFit;
        return imageView;
    }()
    
    lazy var cannotScanButton: UIButton = {
        let button = UIButton();
        button.backgroundColor = UIColor.red;
        button.setTitle("Manual input", for: .normal);
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside);
        return button;
    }()
    
    lazy var doubleTapGesture: UITapGestureRecognizer = {
      var gesture = UITapGestureRecognizer(target: self, action: #selector(toggleFlash));
      gesture.numberOfTapsRequired = 2;
      return gesture;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        navigationItem.rightBarButtonItem = settingsButton();
        view.addSubview(cannotScanButton);
        buttonConstraints();
        startVideoSession();
        self.view.addSubview(imageView);
        setCenterImage();
        setToolBar();
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        setToolBar();
        startVideoSession();
        setCenterImage();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        animate();
    }

    private func animate() {
        guard let coordinator = self.transitionCoordinator else {
            return
        }

        coordinator.animate(alongsideTransition: {
            [weak self] context in
            self?.setColors()
        }, completion: nil)
    }

    private func setColors() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .red;
    }
    
    public func setToolBar()->Void {
        self.navigationController?.navigationBar.barTintColor = UIColor.red;
    }
    // Iterate through the folder to make this clener
    public func imageArrayItems()->[UIImage] {
        var someFile = [UIImage]();
        for i in 1..<imageCount{
            let currentImageName: String = "image_\(i)";
            let currentImage = UIImage(named: currentImageName);
            someFile.append(currentImage!);
        }
        return someFile;
    }
    
    public func setCenterImage()->Void {
        //imageView.image = UIImage(named: "updateBarcode");
        //let imageViewArray:[UIImage] = [UIImage(named: "updateBarcode")!, UIImage(named: "barcodeScanner")!, UIImage(named: "square")!]
        imageView.animationDuration = 1.0;
        imageView.image = UIImage(named: "updateBarcode");
        imageView.anchorView(top: view.centerYAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20), size: .init(width: 140, height: 150));
        imageView.startAnimating();
        
    }
    
    
    public func settingsButton()->UIBarButtonItem {
        let image = UIImage(named: "settings");
        let button = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(launchSettings));
        return button;
    }
    
    @objc private func onButtonClick() {
        
        let dialog = UIAlertController(title: "Enter Barcode Manually", message: "Enter : ", preferredStyle: .alert);
        dialog.addTextField(configurationHandler: { (textField)
            in textField.text = "";
            textField.keyboardType = .numberPad;
        })
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak dialog] (_) in
            let textField = dialog?.textFields![0];// Force unwrapping because we know it exists.
            if((textField?.text!.isEmpty)!)
            {
                self.showErrorMessage(message: "Text field is empty!");
                return;
            }
            else
            {
                // if nill abort newScreen
                self.scannerManual = textField?.text;
                self.launchViewManual(str: self.scannerManual!);
                print("Text field: \(String(describing: textField?.text))")}
            }
        ));
        // Cancel button
        dialog.addAction( UIAlertAction(title: "Cancel", style: .cancel, handler: nil));
        self.present(dialog, animated: true, completion: nil);
        turnOffTorch();
    }
    
    internal func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if (metadataObjects != nil && metadataObjects.count != nil) {
            if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                if (object.type == .ean8 || object.type == .pdf417 || object.type == .upce) {
                    gatherInformation(strBarcode: object.stringValue!);
                }
                else if(object.type == .ean13 ) {
                    let dropExtraStr = object.stringValue!.dropFirst();
                    gatherInformation(strBarcode: String(dropExtraStr));
                   
                }
                else if(object.type == .qr) {
                    let error = UIAlertController(title: "Sorry we dont support QR codes yet :(", message: "Try later once we update this app.", preferredStyle: .alert);
                    let action = UIAlertAction(title: "Close", style: .cancel, handler: nil);
                    error.addAction(action);
                }
                else {
                    let errorAlert = UIAlertController(title: "We could not recognize that barcode", message: "Try again later", preferredStyle: .alert);
                    errorAlert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil));
                    self.present(errorAlert, animated: true, completion: nil);
                }
            }
        }
        
    }
    
    public func launchViewManual(str: String) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "contentView") as? ContentViewController;
        vc?.barcodePassed = str;
        self.navigationController?.pushViewController(vc!, animated: true);
        print("Manual Launch");
        turnOffTorch();
        return;
    }
    
    @objc public func launchSettings() {
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "settingsContent") as? SettingsViewController;
        self.navigationController?.pushViewController(viewController!, animated: true);
        print("Launched Settings");
        return;
    }
    
    private func showErrorMessage(message: String) {
        let errorDialog = UIAlertController(title: "Something went wrong!", message: message, preferredStyle: .alert);
        errorDialog.addAction(UIAlertAction(title: "Retry", style: .default, handler: nil))
        self.present(errorDialog, animated: true, completion: nil);
    }
    
    private func gatherInformation(strBarcode: String) {
        scanner = strBarcode;
        session.stopRunning();
    }
    
    private func startVideoSession() {
        guard let capture = AVCaptureDevice.default(for: .video ) else {
            print("No Media")
            return;
        }
        do {
            guard let input = try? AVCaptureDeviceInput(device: capture) else {
                print("Error");
                return;
            }
            session.addInput(input);
        }
        
        session.addOutput(output);
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main);
        output.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417];
        video = AVCaptureVideoPreviewLayer(session: session);
        video.frame = view.layer.bounds
        video.shadowColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(video);
        self.view.bringSubviewToFront(cannotScanButton);
        session.startRunning();
    }
    
    private func buttonConstraints() {
        cannotScanButton.anchorView(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: screenWidth, height: 40));
    }
    
    @objc func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {return }
        guard device.hasTorch else {return }
        do{
            try device.lockForConfiguration()
            if(device.torchMode == AVCaptureDevice.TorchMode.on)
            {
                device.torchMode = AVCaptureDevice.TorchMode.off;
            }
            else
            {
                do{
                    try device.setTorchModeOn(level: 1.0)
                }
                catch{
                    print("Error on torch mode");
                }
            }
            device.unlockForConfiguration()
        }catch{
            print(error, "Last loop");
        }
    }
    
    private func turnOffTorch() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {return }
        guard device.hasTorch else {return }
        do{
            try device.lockForConfiguration()
            if(device.torchMode == AVCaptureDevice.TorchMode.on)
            {
                device.torchMode = AVCaptureDevice.TorchMode.off;
            }
            device.unlockForConfiguration()
        }catch{
            print(error, "Last loop");
        }
    }
    
}

extension UIView{
    
    func anchorView(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}


enum LINE_POSITION {
    case LINE_POSITION_TOP
    case LINE_POSITION_BOTTOM
}

extension UIView {
    func addLine(position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .LINE_POSITION_TOP:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
}

