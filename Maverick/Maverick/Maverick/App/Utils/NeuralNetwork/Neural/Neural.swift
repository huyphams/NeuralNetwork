//
//  Neural.swift
//  Maverick
//
//  Created by Huy Pham on 4/19/16.
//  Copyright © 2016 Maverick. All rights reserved.
//

class Neural: NSObject {
  var layer: Int = -1
  var id: Int = -1
  var input: Int = 0 {
    didSet {
      self.initW()
    }
  }
  var vSet = [Float64]()
  var links = [Neural]()
  var sum: Float64 = 0.0
  
  private let lerningRate: Float64 = 0.01
  private var wSet = [Float64]()
  
  private func initW() {
    self.wSet.removeAll()
    for _ in 1...self.input {
      self.wSet.append(0.1)
    }
  }
  
  // Transfer value
  private func sigmoid() {
    self.sum = 1.0/(1.0 + pow(M_E, -self.sum))
  }
  
  private func transferValue() {
    for neural in self.links {
      neural.vSet.append(self.sum)
    }
  }
  
  // Calculate value
  func summation() {
    self.sum = 0.0
    for index in 0...(self.input-1) {
      self.sum = self.sum + self.wSet[index]*self.vSet[index]
    }
    self.sigmoid()
    self.transferValue()
  }
  
  func reconfig(delta: Float64) {
    let currentW = self.wSet
    self.wSet.removeAll()
    for index in 0...(currentW.count-1) {
      let w = currentW[index]
      let v = self.vSet[index]
      self.wSet.append(w + delta*self.lerningRate*v)
    }
  }
}
