//
//  DrawerView.swift
//  Maverick
//
//  Created by Huy Pham on 4/18/16.
//  Copyright © 2016 Maverick. All rights reserved.
//

class DrawerView: BaseView {
  private let drawImage = UIImageView()
  private let bachgroudImage = UIImageView()
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
    self.drawImage.frame = Constant.mainBounds
    self.bachgroudImage.frame = Constant.mainBounds
    self.addSubview(self.bachgroudImage)
    self.addSubview(self.drawImage)
    
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
      if let nearestPoint = self.points.last {
        let deltaX = nearestPoint.x - currentPoint.x
        let deltaY = nearestPoint.y - currentPoint.y
        let delta = deltaX*deltaX + deltaY*deltaY
        if delta > 20 {
          points.append(currentPoint)
        }
      }
      UIGraphicsBeginImageContext(self.frame.size)
      self.drawImage.image?.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
      CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
      CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y)
      CGContextSetLineCap(UIGraphicsGetCurrentContext(), .Round)
      CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0)
      CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.5, 0.5, 0.5, 1.0)
      CGContextSetBlendMode(UIGraphicsGetCurrentContext(),.Normal)
      CGContextStrokePath(UIGraphicsGetCurrentContext())
      self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext();
      lastPoint = currentPoint;
    }
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.pickPoints(points)
    points.removeAll()
    if !self.mouseSwiped {
      UIGraphicsBeginImageContext(self.frame.size)
      self.drawImage.image?.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
      CGContextSetLineCap(UIGraphicsGetCurrentContext(), .Round)
      CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0)
      CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.5, 0.5, 0.5, 1)
      CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
      CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
      CGContextStrokePath(UIGraphicsGetCurrentContext())
      CGContextFlush(UIGraphicsGetCurrentContext())
      self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
    }
    
    UIGraphicsBeginImageContext(self.frame.size)
    self.bachgroudImage.image?.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), blendMode: .Normal, alpha: 1.0)
    self.drawImage.image?.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), blendMode: .Normal, alpha: 1.0)
    self.bachgroudImage.image = UIGraphicsGetImageFromCurrentImageContext()
    self.drawImage.image = nil
    UIGraphicsEndImageContext()
    UIView.animateWithDuration(2, animations: {
      self.bachgroudImage.alpha = 0.0
    }) { (finished) in
      self.bachgroudImage.image = nil
      self.bachgroudImage.alpha = 1.0
    }
  }
  
  func setMode(button: UIButton) {
    self.mode = Float64(button.tag)/10
    self.label.text = "\(button.tag)"
  }
  
  func pickPoints(point :[CGPoint]) {
    if points.count < self.numOfPoint {
      self.label.text = "Redraw :("
      return
    }
    var pointPick = [CGPoint]()
    let delta = CGFloat(points.count) / CGFloat(self.numOfPoint)

    var minX = Constant.mainBounds.width
    var minY = Constant.mainBounds.height
    for index in 0...(self.numOfPoint - 1) {
      let point = points[Int(CGFloat(index)*delta)]
      if point.x < minX {
        minX = point.x
      }
      if point.y < minY {
        minY = point.y
      }
      pointPick.append(point)
    }
    
    var normalizePoint = [CGPoint]()
    for p in pointPick {
      let point = CGPoint(x: p.x - minX, y: p.y - minY)
      normalizePoint.append(point)
    }
    
    let input = InputData(p: normalizePoint, o: self.mode)
    if self.mode < 0.1 {
      self.label.text = "\(Int(Global.neuralNetworl.summation(input)/0.1))"
    } else {
      NSLog("Training...")
      Global.neuralNetworl.inputs.append(input)
      Global.neuralNetworl.trainingNeurals()
    }
  }
  
  func drawPoint(points: [CGPoint]) {
    for p in points {
      let view = UIView(frame: CGRectMake(0, 0, 5, 5))
      view.center = p
      view.backgroundColor = UIColor.greenColor()
      self.addSubview(view)
    }
  }
}
