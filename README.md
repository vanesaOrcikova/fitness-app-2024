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


![IMG_7294](https://github.com/user-attachments/assets/5882aa09-e227-4393-9952-e39ca41d287b)

![IMG_7295](https://github.com/user-attachments/assets/37d16af7-e9c5-4cde-b477-a48ab89043d4)
![IMG_7296](https://github.com/user-attachments/assets/6f707e6c-8e78-4169-a02b-38ccd3488d7d)

![IMG_7297](https://github.com/user-attachments/assets/95529510-7d4f-4362-af92-b9f3913a49e3)

![IMG_7298](https://github.com/user-attachments/assets/702c31b3-3c88-4fcc-ac29-47a461df5e7b)
![IMG_7299](https://github.com/user-attachments/assets/9423a55f-10d1-45b3-acb0-1db5aa174780)
![IMG_7300](https://github.com/user-attachments/assets/97eeb03a-bc9a-4895-b52f-fa9c06a7807d)
![IMG_7306 (1)](https://github.com/user-attachments/assets/ec957bcf-a9e8-4fd6-bc36-98e16a691fdf)


![IMG_7301](https://github.com/user-attachments/assets/148561b6-b57e-4ba2-ac21-1f93e9ae0f7f)
![IMG_7302](https://github.com/user-attachments/assets/02d7d72c-efcb-4c00-888b-cbcb201c6976)

![IMG_7303](https://github.com/user-attachments/assets/d4e4c88a-c9d2-404a-82cf-f1f533a90639)
![IMG_7305 (1)](https://github.com/user-attachments/assets/337a0fe0-39a6-41fa-a773-0227fa3f05ad)
![IMG_7304](https://github.com/user-attachments/assets/4fcaa28a-5ad0-4da2-8b5f-81c5ca8c63f5)







