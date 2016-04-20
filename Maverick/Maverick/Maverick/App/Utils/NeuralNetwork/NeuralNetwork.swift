//
//  NeuralNetwork.swift
//  Maverick
//
//  Created by Huy Pham on 4/19/16.
//  Copyright © 2016 Maverick. All rights reserved.
//

class NeuralNetwork: NSObject {
  
  var inputs = [InputData]()
  private var neurals = [Neural]()
  private var currentInput = 0
  
  func initNetwork() {
    // The first layer
    for index in 0...39 {
      let neural = Neural()
      neural.id = index
      neural.layer = 0
      neural.input = 20
      self.neurals.append(neural)
    }
    
    // The second layer
    for index in 40...79 {
      let neural = Neural()
      neural.id = index
      neural.layer = 1
      neural.input = 40
      self.neurals.append(neural)
      
      // Create links
      for i in 0...39 {
        let n = self.neurals[i]
        n.links.append(neural)
      }
    }
    
    // The third layer
    for index in 80...89 {
      let neural = Neural()
      neural.id = index
      neural.layer = 2
      neural.input = 40
      self.neurals.append(neural)
      
      // Create links
      for i in 40...79 {
        let n = self.neurals[i]
        n.links.append(neural)
      }
    }
    
    // Result neural
    let neural = Neural()
    neural.id = 90
    neural.layer = 3
    neural.input = 10
    self.neurals.append(neural)
    
    for i in 80...89 {
      let n = self.neurals[i]
      n.links.append(neural)
    }
  }
  
  func training() {
    let input = self.inputs[self.currentInput]
    self.trainingNeurals(input)
  }
  
  private func trainingNeurals(input: InputData) {
    // Remove all input value
    for neural in self.neurals {
      neural.vSet.removeAll()
    }
    
    // Pass value for the first layer
    for neural in self.neurals {
      if neural.layer == 0 {
        neural.vSet.removeAll()
        for point in input.points {
          neural.vSet.append(Float64(point.x))
          neural.vSet.append(Float64(point.y))
        }
      }
      neural.summation()
      
      
      // Debug only
      NSLog("\(neural.sum)")
      if neural.id == 1 {
   //    NSLog("herrerere")
      }
    }
    
    if let neural = self.neurals.last {
      let delta = input.out - neural.sum
      if  fabs(delta) > 0.01 {
        // Learning... put some code ui here bro
        NSLog("Learning...")
        self.reconfigNeural(delta)
        self.trainingNeurals(input)
      } else {
        NSLog("Passed next input...")
        self.passNextInput()
      }
    }
  }
  
  private func reconfigNeural(delta: Float64) {
    for neural in self.neurals {
      neural.reconfig(delta)
    }
  }
  
  private func passNextInput() {
    self.currentInput += 1
    if self.currentInput >= self.inputs.count - 1 {
      NSLog("Finished")
      self.currentInput = 0
      return
    }
    let input = self.inputs[self.currentInput]
    self.trainingNeurals(input)
  }
}

class InputData {
  let points: [CGPoint]!
  let out: Float64!
  init(p: [CGPoint], o: Float64) {
    points = p
    out = o
  }
}

