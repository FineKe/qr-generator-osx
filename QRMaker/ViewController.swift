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
    
    var foreground = CGColor(red: 0, green: 0, blue: 1, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        colorButton.wantsLayer=true
        colorButton.layer?.backgroundColor = foreground
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
        
        if let image = EFQRCode.generate(
            content: text,
            size: EFIntSize(width: 300, height: 300),
            backgroundColor: CGColor.clear,
            foregroundColor: foreground,
            watermark: nil
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

