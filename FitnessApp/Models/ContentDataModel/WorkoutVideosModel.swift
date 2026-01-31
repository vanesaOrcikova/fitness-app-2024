import Foundation

struct WorkoutVideosModel: Identifiable, Codable {
    let id: Int
    let name: String
    let videopath: String
    let typetag: String
    let focusareatag: String
    let difficultytag: String

    var typeTags: [String] {
        typetag
            .lowercased()
            .components(separatedBy: ";")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var focusAreaTag: String {
        focusareatag.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var difficultyTag: String {
        difficultytag.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
