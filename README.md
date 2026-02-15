💡 Idea

The application was originally created as a project for Stredoškolská odborná činnosť (SOČ) during high school. Since it was one of my first larger applications built in Swift/SwiftUI, the project contained several imperfections in terms of design, functionality, and code structure.
Later, I decided to improve and expand the application in order to practically develop my iOS development skills. My main focus was on:

    •	improving the overall UI/UX
    •	updating and extending the core features
    •	improving project organization and architecture
    •	making data handling and user account management more stable
The project is focused on productivity, fitness, and well-being, combining multiple modules into one application that can be used in everyday life.

🏗️ Architecture & Structure

The application is developed using SwiftUI and follows the MVVM (Model–View–ViewModel) architecture. The main focus is placed on clean state management, a modular structure, and consistent UI design across all screens. Navigation is implemented using TabView, which divides the application into separate modules.


🔐 Authentication & Data Persistence

The app uses Firebase Authentication with Google Sign-In support. User data is stored persistently and remains available even after the app is closed. A custom launch screen is displayed when the application starts.

📱 Screens / Modules

    •	Home – daily overview, mood tracker, motivational content, reminders, and tips
    •	Breath – simple breathing module focused on mental well-being
    •	Recipes – recipe search, filter/sort system, and recipe detail view
    •	Workout – workout overview with search and filtering options
    •	My Plan – daily planning and simple task management
    •	Add Item Sheet – adding tasks with priority and optional time settings
    •	Logout – user logout management

    
⚙️ Technologies Used

    •	SwiftUI
    •	MVVM Architecture
    •	Firebase Authentication
    •	Google Sign-In
    •	TabView Navigation
    •	SwiftUI State Management
    •	Persistent Data Storage
    •	Custom Launch Screen

 🔄 App Flow Overview
 
    •	app launches and displays a custom launch screen
    •	the system checks the user session via Firebase Authentication
    •	if the user is not logged in, authentication is handled through Google Sign-In
    •	after login, saved user data is loaded
    •	the app displays the main TabView interface
    •	navigation between modules is available (Home, Breath, Recipes, Workout, My Plan)
    •   items can be added or edited using sheet-based views
    •	changes are saved continuously and remain available even after the app is closed




