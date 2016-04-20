class Logger {
  
  class func debug(message: String, filename: String = #file,
    function: String = #function, line: Int = #line) {
      #if DEBUG
        let component = filename.componentsSeparatedByString("/")
        if let fileName = component.last {
          print("💜[DEBUG][\(fileName):\(line)] \(function) 👉 \(message)")
        } else {
          print("💜[DEBUG][Unknown File:\(line)] \(function) 👉 \(message)")
        }
      #endif
  }
  
  class func info(message: String, filename: String = #file,
    function: String = #function, line: Int = #line) {
      #if DEBUG
        let component = filename.componentsSeparatedByString("/")
        if let fileName = component.last {
          print("💚[INFO][\(fileName):\(line)] \(function) 👉 \(message)")
        } else {
          print("💚[INFO][Unknown File:\(line)] \(function) 👉 \(message)")
        }
      #endif
  }
  
  class func warning(message: String, filename: String = #file,
    function: String = #function, line: Int = #line) {
      let component = filename.componentsSeparatedByString("/")
      if let fileName = component.last {
        print("💛[WARNING][\(fileName):\(line)] \(function) 👉 \(message)")
      } else {
        print("💛[WARNING][Unknown File:\(line)] \(function) 👉 \(message)")
      }
  }
  
  class func dafug(message: String, filename: String = #file,
    function: String = #function, line: Int = #line) {
      let component = filename.componentsSeparatedByString("/")
      if let fileName = component.last {
        print("❤️[ERROR][\(fileName):\(line)] \(function) 👉 \(message)")
      } else {
        print("❤️[ERROR][Unknown File:\(line)] \(function) 👉 \(message)")
      }
  }
}

class System {
  
  class func isiPhone() -> Bool {
    return (UIDevice.currentDevice().model  == "iPhone") ||
      (UIDevice.currentDevice().model  == "iPhone Simulator")
  }
  
  class func systemVersionEqualTo(version: NSString) -> Bool {
    return UIDevice.currentDevice().systemVersion.compare(version as String,
      options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedSame
  }
  
  class func systemVersionGreaterThan(version: NSString) -> Bool {
    return UIDevice.currentDevice().systemVersion.compare(version as String,
      options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedDescending
  }
  
  class func systemVersionGreaterThanOrEqualTo(version: NSString) -> Bool {
    return UIDevice.currentDevice().systemVersion.compare(version as String,
      options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending
  }
  
  class func systemVersionLessThan(version: NSString) -> Bool {
    return UIDevice.currentDevice().systemVersion.compare(version as String,
      options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedAscending
  }
  
  class func systemVersionLessThanOrEqualTo(version: NSString) -> Bool {
    return UIDevice.currentDevice().systemVersion.compare(version as String,
      options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedDescending
  }
}
