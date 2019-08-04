//
//  DestinationImageView.swift
//  QRMaker
//
//  Created by finefine on 2019/8/4.
//  Copyright © 2019 finefine. All rights reserved.
//

import Cocoa

protocol DestinationViewDelegate {
    func processImageURLs(_ urls: [URL])
    func processImage(_ image: NSImage)
    func processAction(_ action: String)
}

class DestinationImageView: NSImageView {
    
   let filteringOptions = [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes:NSImage.imageTypes]
    var isRecevingDrag = false {
        didSet {
            needsDisplay = true
        }
    }
    var delegate: DestinationViewDelegate?
    enum Appearance {
        static let lineWidth: CGFloat = 10.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        if isRecevingDrag {
            NSColor.selectedControlColor.set()
            
            let path = NSBezierPath(rect:bounds)
            path.lineWidth = Appearance.lineWidth
            path.stroke()
        }
    }
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let allow = showAllowDrag(sender)
        isRecevingDrag = allow
        return allow ? .copy:NSDragOperation()
    }
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isRecevingDrag = false
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return showAllowDrag(sender)
    }
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        //1.
        isRecevingDrag = false
        let pasteBoard = sender.draggingPasteboard
        
        //3.
        if let image = NSImage(pasteboard: pasteBoard) {
            delegate?.processImage(image)
            print("performDragOperation true")
            return true
        }else if let urls = pasteBoard.readObjects(forClasses: [NSURL.self], options:filteringOptions) as? [URL], urls.count > 0 {
            delegate?.processImageURLs(urls)
            print("performDragOperation true")
            return true
        }
        print(false)
        return false
    
    }

    func showAllowDrag(_ draggingInfo:NSDraggingInfo)->Bool{
        var canAccept = false
        let pasteBoard = draggingInfo.draggingPasteboard
        if pasteBoard.canReadObject(forClasses: [NSURL.self], options: filteringOptions){
            canAccept = true
        }
        return canAccept
    }
    
   
}



