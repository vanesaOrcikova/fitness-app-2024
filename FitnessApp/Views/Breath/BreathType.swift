import SwiftUI

struct BreatheType: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var color: Color
}

let lightPinkColor = Color.pink.opacity(0.7)
let lightPurpleColor = Color.purple.opacity(0.7)
let lightBlueColor = Color.blue.opacity(0.7)

let sampleTypes: [BreatheType] = [
    .init(title: "Happy", color: lightPinkColor),
    .init(title: "Saddness", color: lightPurpleColor),
    .init(title: "Angry", color: lightBlueColor)
]

