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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func buildQR(_ sender: NSButton) {
        if let image = generateQR(text: inputText.stringValue){
            outputImage.image = NSImage(cgImage: image, size: outputImage.frame.size)
        }
    }
    
    @IBAction func saveTo(_ sender: NSButton) {
    }
    
    private func generateQR(text:String) -> CGImage? {
        
        if let tryImage = EFQRCode.generate(content: text){
            print("Create QRCode success:\(tryImage)")
            return tryImage
        }else{
            print("Create QRCode failed")
            return nil
        }
    }
}

