import UIKit

final class RMTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
    }
    
    private func setUpTabs() {
        let homeVC = RMHomeViewController()
        let breathVC = RMBreathViewController()
        let recipeVC = RMRecipesViewController()
        let workoutVC = RMWorkoutViewController()
        let myPlanVC = RMmyPlanViewController()
        //let settingVC = RMSettingViewController()
        
        homeVC.navigationItem.largeTitleDisplayMode = .automatic
        breathVC.navigationItem.largeTitleDisplayMode = .automatic
        recipeVC.navigationItem.largeTitleDisplayMode = .automatic
        workoutVC.navigationItem.largeTitleDisplayMode = .automatic
        myPlanVC.navigationItem.largeTitleDisplayMode = .automatic
        //settingVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: homeVC)
        let nav2 = UINavigationController(rootViewController: breathVC)
        let nav3 = UINavigationController(rootViewController: recipeVC)
        let nav4 = UINavigationController(rootViewController: workoutVC)
        let nav5 = UINavigationController(rootViewController: myPlanVC)
        //let nav6 = UINavigationController(rootViewController: settingVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Breath", image: UIImage(systemName: "figure.yoga"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Recipes", image: UIImage(systemName: "cooktop"), tag: 1)
        nav4.tabBarItem = UITabBarItem(title: "Workout", image: UIImage(systemName: "dumbbell"), tag: 1)
        nav5.tabBarItem = UITabBarItem(title: "My plan", image: UIImage(systemName: "person"), tag: 1)
        //nav6.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "lock.open"), tag: 1)
        
        for nav in [nav1, nav2, nav3, nav4, nav5] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(
            [nav1, nav2, nav3, nav4, nav5],
            animated: true
        )
    }
}



