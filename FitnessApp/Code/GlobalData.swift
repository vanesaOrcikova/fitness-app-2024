import Foundation

struct GlobalData {
    static let daysOfWeek = ["Mon", "Thu", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    static let emoji = ["😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "😊", "😇", "😍", "🥰", "😎", "🤩", "😋", "😜", "🫠", "🙄", "😏", "😒", "😌", "😔", "😢", "😭", "😴", "😤", "😠", "😡", "🤯", "🤒", "😳", "😱", "😨", "😰", "🥳", "🫶", "❤️", "🩷", "🩵", "❤️‍🩹", "☀️", "⚡️", "🌈"]
    
    static let exerciseCategory = ["Abs", "Back", "Arms", "Legs", "Booty"]
    static let recipeCategory = ["Ingredients", "Nutrition", "Dietary Info"]
    
    static func getCurrentDayIndex() -> Int {
        let calendar = Calendar.current
        //Note: Sunday is 1, so subtracting 1 to align with your array
        let currentDayIndex = calendar.component(.weekday, from: Date()) - 1
        return currentDayIndex
    }
    
    static func getCurrentMonthIndex() -> Int {
        let calendar = Calendar.current
        // Note: January is 1, so subtracting 1 to get a 0-based index
        let currentMonthIndex = calendar.component(.month, from: Date()) - 1
        return currentMonthIndex
    }
}
