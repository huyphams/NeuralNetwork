//
//  BaseView.swift
//  Maverick
//
//  Created by Huy Pham on 4/18/16.
//  Copyright © 2016 Maverick. All rights reserved.
//

class BaseView: UIView {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init() {
    super.init(frame: CGRect.zero)
    self.commonInit()
    self.initView()
  }
  
  func commonInit() {
  }
  
  func initView() {
  }
}
