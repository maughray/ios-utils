//
//  NibLoadingView.swift
//  PROFitness
//
//  Created by Dev on 2/20/20.
//  Copyright © 2020 Victor. All rights reserved.
//

import UIKit

class NibLoadingView: UIView {
    
    @IBOutlet weak var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        nibSetup()
        view?.prepareForInterfaceBuilder()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
        view.anchorAllEdgesToSuperview()
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: String(describing: type(of:self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
}
