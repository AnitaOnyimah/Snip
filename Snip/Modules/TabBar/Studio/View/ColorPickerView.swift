//
//  ColorPickerView.swift
//  LiteNoteApp
//
//  Created by MTech on 25/07/19.
//  Copyright © 2019 MTech. All rights reserved.
//

import UIKit
import ChromaColorPicker

class ColorPickerView: UIView, ChromaColorPickerDelegate {
    
    func colorPickerHandleDidChange(_ colorPicker: ChromaColorPicker, handle: ChromaColorHandle, to color: UIColor) {
        didSelectColor?(color)
    }
    
    @IBOutlet weak var brightnessHandler: ChromaBrightnessSlider!
    @IBOutlet weak var colorPicker: ChromaColorPicker!
    
    public var didSelectColor : ((_ color: UIColor)->())?
    public var didClose : (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ColorPickerView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        colorPicker.delegate = self
        
        colorPicker.connect(brightnessHandler)
        
        let peachColor = UIColor.white
        colorPicker.addHandle(at: peachColor)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        didClose?()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
