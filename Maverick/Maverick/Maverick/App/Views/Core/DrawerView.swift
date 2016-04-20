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
  private let numOfPoint = 40
  private var mode: Float64 = 0.1
  private let label = UILabel()
  private let play = UIButton()
  
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
    
    let buttonWidth = (Constant.mainBounds.width - 20) / 10
    for i in 1...10 {
      let button = UIButton(frame: CGRectMake(15 + CGFloat(i - 1)*buttonWidth, 40, buttonWidth - 10, 30))
      button.titleLabel?.font = UIFont(name: Constant.fontNameRegular, size: 11)
      button.setTitle("\(i)", forState: UIControlState.Normal)
      button.titleLabel?.textColor = UIColor.whiteColor()
      button.tag = i
      button.backgroundColor = UIColor.purpleColor()
      button.addTarget(self, action: #selector(DrawerView.setMode(_:)), forControlEvents: UIControlEvents.TouchUpInside)
      self.addSubview(button)
    }
    
    self.label.frame = CGRectMake(10, 80, Constant.mainBounds.width/2 - 5, 30)
    self.label.textAlignment = NSTextAlignment.Center
    self.label.textColor = UIColor.blackColor()
    self.label.text = "1"
    
    self.play.frame = CGRectMake(Constant.mainBounds.width/2 + 5, 80, Constant.mainBounds.width/2 - 10, 30)
    self.play.titleLabel?.font = UIFont(name: Constant.fontNameRegular, size: 11)
    self.play.setTitle("Play", forState: UIControlState.Normal)
    self.play.titleLabel?.textColor = UIColor.whiteColor()
    self.play.backgroundColor = UIColor.purpleColor()
    self.play.addTarget(self, action: #selector(DrawerView.setMode(_:)), forControlEvents: UIControlEvents.TouchUpInside)

    self.addSubview(self.label)
    self.addSubview(self.play)
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
  
  func setMode(button: UIButton) {
    self.mode = Float64(button.tag)/10
    self.label.text = "\(button.tag)"
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
    let input = InputData(p: pointPick, o: self.mode)
    
    if self.mode - 0.0 < 0.1 {
      NSLog("Play :)")
      NSLog("\(Global.neuralNetworl.summation(input))")
    } else {
      Global.neuralNetworl.inputs.append(input)
      Global.neuralNetworl.trainingNeurals()
    }
  }
}
