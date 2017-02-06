//
//  TabView.swift
//  RadiumBrowser
//
//  Created by bslayter on 1/31/17.
//  Copyright © 2017 bslayter. All rights reserved.
//

import UIKit

protocol TabViewDelegate: class {
	func didTap(tab: TabView)
	func close(tab: TabView)
}

class TabView: UIView {
    
    var shapeLayer: CAShapeLayer?
    
    var tabTitle: String? {
        didSet {
            tabTitleLabel?.text = tabTitle
        }
    }
    var tabTitleLabel: UILabel?
    var tabImageView: UIImageView?
	
	weak var delegate: TabViewDelegate?
	
	var webContainer: WebContainer?

	init(parentView: UIView) {
        super.init(frame: .zero)
        
        self.backgroundColor = Colors.radiumGray
		
		let closeBtn = UIButton().then { [unowned self] in
			$0.setImage(UIImage.imageFrom(systemItem: .stop)?.makeThumbnailOfSize(size: CGSize(width: 15, height: 15)), for: .normal)
			$0.addTarget(self, action: #selector(self.close(sender:)), for: .touchUpInside)
			
			self.addSubview($0)
			$0.snp.makeConstraints { (make) in
				make.height.equalTo(self).offset(-25)
				make.width.equalTo(self.snp.height).offset(-25)
				make.right.equalTo(self).offset(-14)
				make.centerY.equalTo(self)
			}
		}
        
        tabImageView = UIImageView().then { [unowned self] in
            $0.image = UIImage(named: "globe")
            $0.contentMode = .scaleAspectFit
            
            self.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.width.equalTo(15)
                make.height.equalTo(15)
                make.left.equalTo(self).offset(13)
                make.centerY.equalTo(self)
            }
        }
		
		tabTitleLabel = UILabel().then { [unowned self] in
			$0.text = "New Tab"
            $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize - 0.5)
			
			self.addSubview($0)
			$0.snp.makeConstraints { (make) in
				make.left.equalTo(self.tabImageView!.snp.right).offset(4)
				make.top.equalTo(self).offset(6)
				make.bottom.equalTo(self).offset(-6)
				make.right.equalTo(closeBtn.snp.left).offset(-4)
			}
		}
		
		let gesture = UITapGestureRecognizer()
		gesture.numberOfTapsRequired = 1
		gesture.addTarget(self, action: #selector(tappedTab))
		self.addGestureRecognizer(gesture)
		self.isUserInteractionEnabled = true
		
		webContainer = WebContainer(parent: parentView)
		webContainer?.tabView = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.blendCorner(corner: .All, shapeLayer: &shapeLayer, length: 10)
    }
	
	func tappedTab(sender: UITapGestureRecognizer) {
		delegate?.didTap(tab: self)
	}
	
	func close(sender: UIButton) {
		delegate?.close(tab: self)
	}
}
