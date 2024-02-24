import UIKit
import SwiftUI

final class RMHomeViewController: UIViewController {
    
    private var hostingController : UIHostingController<HomeView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = .systemBackground
        //title = "Home"
        
        let homeView = HomeView()
        
        let hostingController = UIHostingController(rootView: homeView)
        self.hostingController = hostingController
        
        addChild(hostingController)
        
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
              hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
              hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
          ])
        
        hostingController.didMove(toParent: self)
    }
}
