import UIKit
import SwiftUI

final class RMmyPlanViewController: UIViewController {
    
    private var hostingController : UIHostingController<myPlanView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = .systemBackground
        //title = "My plan"
        
        let myPlanView = myPlanView()
        
        let hostingController = UIHostingController(rootView: myPlanView)
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
