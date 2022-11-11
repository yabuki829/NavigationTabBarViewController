import UIKit

public struct TabColor {
    public var textColor:UIColor
    public var backgroundColor :UIColor
}

public struct TabContent{
    let view:UIView
    let height:CGFloat
    
    public init(view:UIView,height:CGFloat){
        self.view = view
        self.height = height
    }
}

open class UINavigationTabBarViewController:UIViewController, reloadDelegate{
    
    
    private var childrenViewController = [UIViewController]()
    public var titleList = [String]()
    private let buttonCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    var contentCollectionViewCell = ContentCollectionViewCell()
    private let contentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    open override func viewDidLoad() {
        configureCollectionView()
    }
    open func viewControllers() -> [UIViewController] {
        return [UIViewController]()
    }
    
    open func tabHeight() -> CGFloat {
        return 30
    }
  
    func configureCollectionView(){
        buttonCollectionView.delegate = self
        buttonCollectionView.dataSource = self
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        
        view.addSubview(buttonCollectionView)
        view.addSubview(contentCollectionView)
        if #available(iOS 11.0, *) {
            buttonCollectionView.constraints(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                                             left: view.leftAnchor, paddingLeft: 0,
                                             right: view.rightAnchor, paddingRight: 0, height: tabHeight())
        } else {
            // Fallback on earlier versions
            buttonCollectionView.constraints(top: view.topAnchor, paddingTop: 0,
                                             left: view.leftAnchor, paddingLeft: 0,
                                             right: view.rightAnchor, paddingRight: 0, height: tabHeight())
        }
        
        if #available(iOS 11.0, *) {
            contentCollectionView.constraints(top: buttonCollectionView.bottomAnchor, paddingTop: 0,
                                              left: view.leftAnchor, paddingLeft: 0,
                                              right: view.rightAnchor, paddingRight: 0,
                                              bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
        } else {
            // Fallback on earlier versions
            contentCollectionView.constraints(top: buttonCollectionView.bottomAnchor, paddingTop: 0,
                                              left: view.leftAnchor, paddingLeft: 0,
                                              right: view.rightAnchor, paddingRight: 0,
                                              bottom: view.bottomAnchor, paddingBottom: 0)
        }
        
        buttonCollectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: ButtonCollectionViewCell.identifier)
        contentCollectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: ContentCollectionViewCell.identifier)
        
        
    }
    func reload(indexPath: IndexPath) {
        //リロードする
        print("Reload")
        contentCollectionViewCell.collectionView.scrollToItem(at:indexPath , at: .centeredHorizontally, animated: true)
    }
}


extension UINavigationTabBarViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if collectionView == self.buttonCollectionView {
            //ボタンのリストを表示する
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath) as! ButtonCollectionViewCell
            cell.configure(titleList: self.titleList)
            cell.height = tabHeight()
            cell.delegate = self
            return cell
        }
        else  {
            
            contentCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCollectionViewCell.identifier, for: indexPath) as! ContentCollectionViewCell
            contentCollectionViewCell.height = tabHeight()
            contentCollectionViewCell.configure(controllers: viewControllers())
            return contentCollectionViewCell
        }
       
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.buttonCollectionView {
           
            return CGSize(width:view.frame.width, height: tabHeight())
        }
        if #available(iOS 13.0, *) {
            let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            let tabbarHeight = tabBarController?.tabBar.frame.size.height ?? 0
            
            return CGSize(width:view.frame.width, height: view.frame.height - tabHeight()*2 - statusHeight - navigationBarHeight - tabbarHeight)
        } else {
            // Fallback on earlier versions
            
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            let tabbarHeight = tabBarController?.tabBar.frame.size.height ?? 0
            
            return CGSize(width:view.frame.width, height: view.frame.height - tabHeight()*2 - navigationBarHeight - tabbarHeight)
        }
       
    }
    
    
}
extension UIView{
    public func constraints(top: NSLayoutYAxisAnchor? = nil,paddingTop: CGFloat = 0,
                left: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0,
                right: NSLayoutXAxisAnchor? = nil,paddingRight: CGFloat = 0,
                bottom: NSLayoutYAxisAnchor? = nil,paddingBottom: CGFloat = 0,
                height: CGFloat? = nil,width: CGFloat? = nil) {
    
        self.translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }

        if let height = height{
            sizing(height: height)
        }
        if let width = width {
            sizing(width:width)
        }
       
    }
    public func sizing(height: CGFloat? = nil,width: CGFloat? = nil){
        self.translatesAutoresizingMaskIntoConstraints = false
        if let height = height{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        
    }
    public func center(inView view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    public func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        if let topAnchor = topAnchor, let padding = paddingTop  {
            self.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        }
    }

    public func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingleft: CGFloat? = nil, constant: CGFloat? = 0) {
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true

        if let leftAnchor = leftAnchor, let padding = paddingleft {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }
    
    public func removeConstraint(){
        removeConstraints(constraints)
    }
}





