class BaseController: UIViewController {
  
  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName: String?, bundle: NSBundle?) {
    super.init(nibName: nibName, bundle: bundle)
    self.commonInit()
  }
  
  override func didReceiveMemoryWarning() {
    Logger.info("Got memory warning")
  }
  
  func commonInit() {
    self.automaticallyAdjustsScrollViewInsets = false
    self.view.backgroundColor = UIColor(hex: 0x000000)
  }
}
