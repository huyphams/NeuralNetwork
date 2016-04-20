//
//  DrawerView.swift
//  Maverick
//
//  Created by Huy Pham on 4/18/16.
//  Copyright © 2016 Maverick. All rights reserved.
//

class DrawerView: BaseView {
  private let drawViewImage = UIImageView()
  private let imageViewImage = UIImageView()
  private var mouseSwiped = false
  private var lastPoint = CGPointZero
  private var points = [CGPoint]()
  private let numOfPoint = 10
  
  override func commonInit() {
    super.commonInit()
    self.frame = Constant.mainBounds
    self.backgroundColor = UIColor.whiteColor()
  }
  
  override func initView() {
    super.initView()
    self.drawViewImage.frame = Constant.mainBounds
    self.imageViewImage.frame = Constant.mainBounds
    self.addSubview(self.imageViewImage)
    self.addSubview(self.drawViewImage)
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.mouseSwiped = false
    if let touch = touches.first {
      lastPoint = touch.locationInView(self)
      points.append(lastPoint)
    }
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.mouseSwiped = true
    if let touch = touches.first {
      let currentPoint = touch.locationInView(self)
      points.append(currentPoint)
      UIGraphicsBeginImageContext(self.frame.size)
      self.drawViewImage.image?.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
      CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
      CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y)
      CGContextSetLineCap(UIGraphicsGetCurrentContext(), .Round)
      CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0)
      CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.5, 0.5, 0.5, 1.0)
      CGContextSetBlendMode(UIGraphicsGetCurrentContext(),.Normal)
      CGContextStrokePath(UIGraphicsGetCurrentContext())
      self.drawViewImage.image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext();
      lastPoint = currentPoint;
    }
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.pickPoints(points)
    points.removeAll()
    if !self.mouseSwiped {
      UIGraphicsBeginImageContext(self.frame.size)
      self.drawViewImage.image?.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
      CGContextSetLineCap(UIGraphicsGetCurrentContext(), .Round)
      CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0)
      CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.5, 0.5, 0.5, 1)
      CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
      CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
      CGContextStrokePath(UIGraphicsGetCurrentContext())
      CGContextFlush(UIGraphicsGetCurrentContext())
      self.drawViewImage.image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
    }
    
    UIGraphicsBeginImageContext(self.frame.size)
    self.imageViewImage.image?.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), blendMode: .Normal, alpha: 1.0)
    self.drawViewImage.image?.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), blendMode: .Normal, alpha: 1.0)
    self.imageViewImage.image = UIGraphicsGetImageFromCurrentImageContext()
    self.drawViewImage.image = nil
    UIGraphicsEndImageContext()
  }
  
  func pickPoints(point :[CGPoint]) {
    if points.count < self.numOfPoint {
      return
    }
    var pointPick = [CGPoint]()
    let delta = points.count / self.numOfPoint
    for index in 0...(self.numOfPoint - 1) {
      pointPick.append(points[index*delta])
    }
    NSLog("Training...")
    let input = InputData(p: pointPick, o: 0.1)
    Global.neuralNetworl.inputs.append(input)
    Global.neuralNetworl.training()
  }
}
