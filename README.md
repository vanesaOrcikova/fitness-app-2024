💡 Idea 

The app was originally created as a project for the Secondary School Professional Activity (SOČ) competition during high school. Since it was one of my first larger applications built in Swift/SwiftUI, the original version had several shortcomings in terms of design, functionality, and code structure.

Later, I decided to rebuild and redesign the app and expand its features. During the refactoring and expansion process, I focused mainly on:

    • improving UI/UX and visual consistency
    • expanding and refining the core functionalities
    • better project organization and module separation
    • more stable data handling and user account management

🔐 Authentication and User Account Management 

The app uses Firebase Authentication with Google Sign-In support, allowing users to log in quickly and easily. Authentication is designed so that users don't lose access to their data when relaunching the app. On startup, a custom launch screen is displayed, after which the user's login state is verified and, depending on the result, either the login flow or the main app interface is shown.

💾 Data Handling 

User data is saved and remains accessible even after the app is closed. Data is processed through a structured model and is linked to a specific user account. A notable highlight of the project is the implementation of a custom JSON loader, which is used to load predefined content (e.g. recipes, tips, or motivational content) from JSON files.

    • JSON files are loaded through a separate loader logic
    • data is mapped to Swift models using Codable
    • this approach allows for easy content expansion without touching the UI layer
    
This system improves the maintainability of the app and simplifies future content expansion.

📱 App Modules and Screens 

The app is divided into several modules, each representing a distinct feature implemented through its own SwiftUI views. Navigation between sections is handled via TabView. Each module includes an overview screen and, where needed, detail screens that open using navigation or sheet presentation.

🏠 Home Screen

I implemented the home screen as the main dashboard in HomeView using a ScrollView, where content is divided into separate SwiftUI components. The layout is built on a card-based design with a custom background and visual elements (RoundedRectangle, LinearGradient, shadow) to keep the UI consistent and clean.

📌 Main Sections of the Home Screen

    • The Header section displays the current date using DateFormatter and serves as the introductory visual element of the app.
    • Weekly Mood Overview (WeeklyMoodOverviewTable) is implemented using LazyVGrid, where the user selects a mood emoji for each day of the week. Mood values are saved to UserDefaults (shared storage) and upon change, WidgetCenter.shared.reloadAllTimelines() is called to automatically update the widget.
    • Random Exercise Challenge (RandomExerciseChallengeView) uses a Picker in segmented style to select a category and randomly generate exercises via a utility function. Challenges are selected dynamically and displayed through an Alert. Data is loaded via ContentLoader.loadJSON.
    • Motivational Quote (MotivationalQuoteView) loads quotes from JSON and displays a "quote of the day" based on the current date, ensuring consistent daily content.
    • Reminders (ReminderView) work similarly — content is loaded from JSON and selected based on the current date, with the display handled through custom row components.
    • Miniblog of the Month (MiniblogOfMonth) displays monthly content that changes based on the current month and adds a longer-term motivational element to the home screen.

🌬️ Breath – Breathing Module

I implemented the Breath module as a standalone SwiftUI screen (BreathView) designed for simple guided breathing exercises. Different breathing modes are defined in BreathType, where the inhale/exhale time intervals are stored, making it easy to extend the module with additional breathing routines.

The breathing flow is controlled using @State variables and a Timer, which handles countdown logic and automatically switches between breathing phases. For a smoother user experience, the module also uses animations (withAnimation) to visually represent inhale and exhale transitions.

🍲 Recipes – Recipe Search & Detail Module

I implemented the Recipes module as a structured content browsing system in RecipesView, where recipes are displayed in a scroll-based layout with a clean UI design. The module supports recipe discovery through an organized list/grid presentation, making navigation user-friendly.

A key feature is the integration of search and filtering logic, allowing users to quickly find specific recipes and sort them based on selected parameters. Recipe items are rendered using reusable UI components such as RecipesViewScrollTemplateElement, ensuring consistent layout and scalable code structure.

Each recipe includes a dedicated detail screen (RecipeDescriptionView), where extended information is displayed, including:

    • description and recipe overview
    • nutrition-related highlights
    • dietary information

Nutrition and dietary data are presented through separate reusable UI components (RecipeInformationNutritionBadge, RecipeInformationDietaryInfo), which improves UI modularity and makes the design easier to maintain and expand.

🏋️ Workout – Workout Module

I implemented the Workout module in WorkoutView as an overview of available workouts, where individual workouts are displayed using the reusable WorkoutElement component. The module also includes a filtering system through FilterSelectionView, which allows users to select workouts by category and simplifies navigation through the content.

Currently, workout videos are stored locally directly within the project, which ensures offline availability. In the future, this system could be improved by hosting the videos on external storage, allowing easier content updates and reducing the overall app size.

🗓️ My Plan

I implemented the My Plan module as a dedicated daily planning section in myPlanView, designed to help users organize their everyday activities and tasks in a structured way. The module is built to provide a clear daily overview, while separating content into multiple reusable screens and SwiftUI components.

📌 Main Features of the Module

    • Daily Overview (myPlanDailyView): the module includes a daily view where items are displayed based on the selected date. Content is loaded dynamically and presented in a clean structured layout, allowing users to quickly see what they need to complete during the day.
    • Item Management (tasks / planning): all planning items are represented through a structured data model (ItemModel) and managed through MyPlanModelsStore, which handles loading, updating, and storing user data. This allows the module to maintain consistent state and structured content organization.
    • Add/Edit Workflow (MyPlanEditorSheet): adding and editing items is implemented using a dedicated sheet-based editor view. The editor allows users to configure multiple item parameters such as title, priority, and additional details. This approach keeps the main UI flow clean while enabling fast data input.
    • Meal Planning (myPlanMealView): the module also includes a meal planning section, where users can organize meals as part of their daily plan. This extends the functionality beyond standard task management and supports more complete daily scheduling.


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







