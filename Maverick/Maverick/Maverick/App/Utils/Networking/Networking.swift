//
//  Networking.swift
//  Maverick
//
//  Created by Huy Pham on 4/2/15.
//  Copyright (c) 2015 Huy Pham. All rights reserved.
//

class Networking {
  private let requestManager = AFHTTPSessionManager()
  
  init() {
    let securityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.None)
    securityPolicy.validatesDomainName = false
    self.requestManager.securityPolicy = securityPolicy
    self.requestManager.requestSerializer = AFJSONRequestSerializer()
    self.requestManager.responseSerializer = AFJSONResponseSerializer()
  }
  
  class func setNetworkHeader() {
    let networkHeaders: [String: String] = [
      "Content-Type": "application/json",
      "X-Maverick-Client": Constant.clientId,
      "X-App-Build": "\(Constant.appBuild)",
    ]
    for key in networkHeaders.keys {
      let value = networkHeaders[key]
      Global.networking.requestManager.requestSerializer.setValue(value,
        forHTTPHeaderField: key)
    }
  }
  
  class func handleStatus(status: Int) {
    switch status {
    case 401:
      // Handle login
      break
    case 417:
      // handle update
      break
    default:
      break
    }
  }
  
  func get(url: String, parameters: AnyObject?,
    handler:((responseObject: Result<AnyObject>) -> Void)) -> NSURLSessionDataTask? {
      let task = self.requestManager.GET(url, parameters: parameters, progress: nil, success: { (task, response) -> Void in
        handler(responseObject: Result.Success(response))
        }) { (taskOp, error) -> Void in
          if let task = taskOp, reponse = task.response as? NSHTTPURLResponse {
            Networking.handleStatus(reponse.statusCode)
            handler(responseObject: Result.Failure(reponse.statusCode))
            return
          }
          handler(responseObject: Result.Failure(-1))
      }
      return task
  }
  
  func post(url: String, parameters: AnyObject?,
    handler:((responseObject: Result<AnyObject>) -> Void)) -> NSURLSessionDataTask? {
      let task = self.requestManager.POST(url, parameters: parameters, progress: nil, success: { (task, response) -> Void in
        handler(responseObject: Result.Success(response))
        }) { (taskOp, error) -> Void in
          if let task = taskOp, reponse = task.response as? NSHTTPURLResponse {
            Networking.handleStatus(reponse.statusCode)
            handler(responseObject: Result.Failure(reponse.statusCode))
            return
          }
          handler(responseObject: Result.Failure(-1))
      }
      return task
  }
  
  func put(url: String, parameters: AnyObject?,
    handler:((responseObject: Result<AnyObject>) -> Void)) -> NSURLSessionDataTask? {
      let task = self.requestManager.PUT(url, parameters: parameters, success: { (task, response) -> Void in
        handler(responseObject: Result.Success(response))
        }) { (taskOp, error) -> Void in
          if let task = taskOp, reponse = task.response as? NSHTTPURLResponse {
            Networking.handleStatus(reponse.statusCode)
            handler(responseObject: Result.Failure(reponse.statusCode))
            return
          }
          handler(responseObject: Result.Failure(-1))
      }
      return task
  }
  
  func delete(url: String, parameters: AnyObject?,
    handler:((responseObject: Result<AnyObject>) -> Void)) -> NSURLSessionDataTask? {
      let task = self.requestManager.DELETE(url, parameters: parameters, success: { (task, response) -> Void in
        handler(responseObject: Result.Success(response))
        }) { (taskOp, error) -> Void in
          if let task = taskOp, reponse = task.response as? NSHTTPURLResponse {
            Networking.handleStatus(reponse.statusCode)
            handler(responseObject: Result.Failure(reponse.statusCode))
            return
          }
          handler(responseObject: Result.Failure(-1))
      }
      return task
  }
  
  func upload(data: NSData, parameters: NSDictionary, url: String,
    progress:(UInt, CLongLong, CLongLong) -> Void, completion:(Result<AnyObject>) -> Void) -> NSURLSessionDataTask? {
      let task = self.requestManager.POST(url, parameters: parameters, constructingBodyWithBlock: { (formData) -> Void in
        formData.appendPartWithFileData(data, name: "files",
          fileName: "image.jpg", mimeType: "image/jpeg")
        }, progress: { (progress) -> Void in
        }, success: { (task, reponse) -> Void in
          completion(Result.Success(reponse))
        }) { (taskOp, error) -> Void in
          if let task = taskOp, reponse = task.response as? NSHTTPURLResponse {
            Networking.handleStatus(reponse.statusCode)
            completion(Result.Failure(reponse.statusCode))
            return
          }
          completion(Result.Failure(-1))
      }
      return task
  }
  
  func isTaskExisted(identifier: Int) -> Bool {
    for task in self.requestManager.dataTasks {
      if task.taskIdentifier == identifier {
        return true
      }
    }
    return false
  }
  
  func cancelAllTasks() {
    for task in self.requestManager.dataTasks {
      task.cancel()
    }
  }
  
  func cancelTask(identifier: Int) {
    for task in self.requestManager.dataTasks {
      if task.taskIdentifier == identifier {
        task.cancel()
      }
    }
  }
}
