//
//  ViewController.swift
//  QRMaker
//
//  Created by finefine on 2019/7/17.
//  Copyright © 2019 finefine. All rights reserved.
//

import Cocoa
import EFQRCode

class ViewController: NSViewController {

    @IBOutlet weak var inputText: NSTextField!
    @IBOutlet weak var outputImage: NSImageView!
    @IBOutlet weak var chooseColorButton: NSButton!
    @IBOutlet weak var destinationView: DestinationImageView!
    
    @IBOutlet weak var testView: NSImageView!
    var foreground = CGColor(red: 0, green: 0, blue: 1, alpha: 1)
    
    var qrImage:NSImage? {
        willSet {
            testView.image =  newValue
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        colorButton.wantsLayer=true
        colorButton.layer?.backgroundColor = foreground
        self.destinationView.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func buildQR(_ sender: NSButton) {
        if let tryImage = generateQR(text: inputText.stringValue){
            outputImage.image = NSImage(cgImage: tryImage, size: outputImage.frame.size)
        }
    }
    @IBOutlet weak var colorButton: NSButton!
    
    @IBAction func saveTo(_ sender: NSButton) {
    }
    @IBAction func test(_ sender: NSButton) {
        let colorPlane = NSColorPanel.shared
        colorPlane.mode = .RGB
        colorPlane.setTarget(self)
        colorPlane.setAction(#selector(changeColor(sender:)))
        colorPlane.makeKeyAndOrderFront(self)
    }
    
    private func generateQR(text:String) -> CGImage? {
        let da = EFQRCode.generateWithGIF(data:(qrImage?.gifData)!, generator: EFQRCodeGenerator(content: text),pathToSave: URL(fileURLWithPath: "/Users/finefine/test.gif"))
        print(da?.description)
        
        if let image = EFQRCode.generate(
            content: text,
            size: EFIntSize(width: 300, height: 300),
            backgroundColor: CGColor.clear,
            foregroundColor: foreground,
            watermark: qrImage?.toCGImage()
            ){
            return image
        }else{
            print("Create QRCode failed")
            return nil
        }
    }
    @objc
    private func changeColor(sender:NSColorPanel){
        let color = sender.color
        chooseColorButton.layer?.backgroundColor = color.cgColor
        self.foreground = color.cgColor
    }
    
    
}

extension ViewController:DestinationViewDelegate{
    func processAction(_ action: String) {
        print(action)
    }
    
    
    func processImage(_ image: NSImage) {
        self.qrImage = image
    }
    
    func processImageURLs(_ urls: [URL]) {
        for (index,url) in urls.enumerated() {
            
            //1.
            if let image = NSImage(contentsOf:url) {
                //3.
                processImage(image)
            }
        }
    }
}

extension NSImage {
    
    var gifData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else {
            return nil
        }
        return bitmapImage.representation(using: .gif, properties: [:])
    }
    func gifWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try gifData?.write(to: url, options: options)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}

