//import SwiftUI
//
/////
////struct Diar: View {
////    @State private var selectedCategory: String?
////    @State private var isNoteEditorActive = false
////    @State private var NoteEditorActive = false
////    @State private var currentDate = Date()
////
////    @State private var noteTitle = ""
////    @State private var noteText = ""
////    @State private var notes = [String: (title: String, text: String)]()
////
////    private let dateFormatter: DateFormatter = {
////        let formatter = DateFormatter()
////        formatter.dateFormat = "dd MMMM yyyy"
////        return formatter
////    }()
////
////    var body: some View {
////        NavigationView {
////            ScrollView{
////                VStack(spacing: 10) {
////                    HStack {
////                        Button(action: {
////                            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? Date()
////                        }) {
////                            Image(systemName: "chevron.left")
////                        }
////                        
////                        Text(dateFormatter.string(from: currentDate))
////                            .font(.headline)
////                            .padding()
////                        
////                        Button(action: {
////                            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? Date()
////                        }) {
////                            Image(systemName: "chevron.right")
////                        }
////                    } .padding(.top, -48)
////
////                    ExtractedNoteView(icon: "case", text: "work", color: .yellow.opacity(0.5)) {
////                        selectedCategory = "work"
////                        isNoteEditorActive = true
////                    }
////                    
////                    ExtractedNoteView(icon: "person", text: "personal", color: .green.opacity(0.5)) {
////                        selectedCategory = "personal"
////                        isNoteEditorActive = true
////                    }
////                    
////                    ExtractedNoteView(icon: "book.closed", text: "reading", color: .red.opacity(0.5)) {
////                        selectedCategory = "reading"
////                        isNoteEditorActive = true
////                    }
////                    
////                    ExtractedNoteView(icon: "moon", text: "sleep", color: .blue.opacity(0.5)) {
////                        selectedCategory = "sleep"
////                        isNoteEditorActive = true
////                    }
////                    
////                    ExtractedNoteView(icon: "pencil", text: "my notes", color: .brown.opacity(0.5)) {
////                        selectedCategory = "my notes"
////                        NoteEditorActive = true
////                    }.sheet(isPresented: $NoteEditorActive) {
////                        MyNotesView(selectedCategory: $selectedCategory, notes: $notes, backgroundColor: .gray)
//////                        MyNotesView(selectedCategory: $selectedCategory, notes: $notes, backgroundColor: .yellow, categoryName: "Work")
//////                        MyNotesView(selectedCategory: $selectedCategory, notes: $notes, backgroundColor: .green, categoryName: "Personal")
//////                        MyNotesView(selectedCategory: $selectedCategory, notes: $notes, backgroundColor: .red, categoryName: "Reading")
//////                        MyNotesView(selectedCategory: $selectedCategory, notes: $notes, backgroundColor: .blue, categoryName: "Sleep")
////                    }
////                }
////                
////                .padding(25)
////                .navigationBarTitleDisplayMode(.inline)
////                .sheet(isPresented: $isNoteEditorActive) {
////                    NoteEditorView(noteTitle: $noteTitle, noteText: $noteText, notes: $notes)
////                }
////                .onAppear {
////                    selectedCategory = nil
////                }
////            }
////        }
////    }
////}
////
////struct ExtractedNoteView: View {
////    var icon: String
////    var text: String
////    var color: Color
////    var onTap: () -> Void
////
////    var body: some View {
////        VStack(alignment: .leading, spacing: 10) {
////            HStack {
////                Image(systemName: icon)
////                    .padding()
////                    .background(color.opacity(0.3))
////                    .clipShape(RoundedRectangle(cornerRadius: 10))
////                Spacer()
////            }
////            Spacer()
////            Text(text)
////                .font(.title)
////        }
////        .padding()
////        .frame(maxWidth: .infinity, maxHeight: .infinity)
////        .background(color.opacity(0.2))
////        .cornerRadius(15)
////        .onTapGesture {
////            onTap()
////        }
////    }
////}
////
////struct NoteEditorView: View {
////    @Binding var noteTitle: String
////    @Binding var noteText: String
////    @Binding var notes: [String: (title: String, text: String)]
////    @Environment(\.presentationMode) var presentationMode
////
////    var body: some View {
////        VStack {
////            TextField("Enter title", text: $noteTitle)
////                .padding()
////                .background(Color.gray.opacity(0.1))
////                .cornerRadius(10)
////                .padding(.horizontal)
////                .padding(.top)
////                .disableAutocorrection(true)
////
////            TextEditor(text: $noteText)
////                .frame(maxWidth: .infinity, maxHeight: .infinity)
////                .padding()
////                .background(Color.gray.opacity(0.1))
////                .cornerRadius(10)
////                .padding(.horizontal)
////                .disableAutocorrection(true)
////            
////            Spacer()
////            
////            Button(action: {
////                saveNote()
////            }) {
////                Text("Save")
////                    .padding()
////                    .foregroundColor(.white)
////                    .background(Color.blue)
////                    .cornerRadius(10)
////            }
////            .padding()
////        }
////    }
////    
////    func saveNote() {
////        if !noteTitle.isEmpty && !noteText.isEmpty {
////            notes[noteTitle] = (title: noteTitle, text: noteText)
////            // Vymažeme text po uložení poznámky
////            noteText = ""
////            noteTitle = ""
////        }
////        presentationMode.wrappedValue.dismiss()
////    }
////    
////}
////
////struct MyNotesView: View {
////    @Binding var selectedCategory: String?
////    @Binding var notes: [String: (title: String, text: String)]
////    var backgroundColor: Color
////
////    var body: some View {
////        VStack(spacing: 0) {
////            ForEach(Array(notes.values), id: \.title) { note in
////                VStack(alignment: .leading, spacing: 5) {
////                    Text(note.title)
////                        .font(.headline)
////                    Text(note.text)
////                }
////                .padding(.horizontal)
////                .frame(maxWidth: .infinity, alignment: .leading)
////                .background(backgroundColor.opacity(0.5)) // Nastavení barvy pozadí podle vybrané kategorie
////                .cornerRadius(10)
////                .padding(.bottom, 10)
////            }
////        }
////    }
////}
/////
//
//
//struct Diar: View {
//    @State private var entries: [DiarEntry] = {
//        if let data = UserDefaults.standard.data(forKey: "diarEntries"),
//           let entries = try? JSONDecoder().decode([DiarEntry].self, from: data) {
//            return entries
//        }
//        return []
//    }()
//    
//    @State private var newEntryText = ""
//    @State private var showingAddEntryView = false
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                Button("Pridať poznamku") {
//                    showingAddEntryView = true
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//                .padding()
//                
//                List {
//                    ForEach(entries.indices, id: \.self) { index in
//                        NavigationLink(destination: DiarDetailView(entry: $entries[index])) {
//                            Text(entries[index].text)
//                                .padding()
//                                .background(Color.gray.opacity(0.1))
//                                .cornerRadius(8)
//                        }
//                    }
//                    .onDelete(perform: deleteEntry)
//                }
//                .listStyle(PlainListStyle())
//            }
//            .sheet(isPresented: $showingAddEntryView) {
//                AddEntryView { newEntry in
//                    entries.append(newEntry)
//                    saveEntries()
//                    showingAddEntryView = false
//                }
//            }
//            .navigationTitle("Zoznam poznamok")
//        }
//    }
//    
//    private func addEntry() {
//        let newEntry = DiarEntry(text: newEntryText)
//        entries.append(newEntry)
//        saveEntries()
//        newEntryText = ""
//    }
//    
//    private func deleteEntry(at offsets: IndexSet) {
//        entries.remove(atOffsets: offsets)
//        saveEntries()
//    }
//    
//    private func saveEntries() {
//        if let encodedData = try? JSONEncoder().encode(entries) {
//            UserDefaults.standard.set(encodedData, forKey: "diarEntries")
//        }
//    }
//}
//
//struct AddEntryView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @State private var newEntryText = ""
//    @State private var showingAlert = false
//    
//    var addEntryAction: (DiarEntry) -> Void
//    
//    var body: some View {
//        VStack {
//            TextEditor(text: $newEntryText)
//                .padding()
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(8)
//                .padding()
//            
//            Button("Pridať poznamku") {
//                if newEntryText.isEmpty {
//                    showingAlert = true
//                } else {
//                    let newEntry = DiarEntry(text: newEntryText)
//                    addEntryAction(newEntry)
//                    newEntryText = ""
//                    
//                    // Dismiss the view
//                    presentationMode.wrappedValue.dismiss()
//                }
//            }
//            .padding()
//            .alert(isPresented: $showingAlert) {
//                Alert(title: Text("Chýbajúce informácie"), message: Text("Prosím, vyplňte text poznamky."), dismissButton: .default(Text("OK")))
//            }
//            
//            Spacer()
//        }
//        .navigationTitle("Pridať poznamku")
//    }
//}
//
//struct DiarDetailView: View {
//    @Binding var entry: DiarEntry
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Poznámka:")
//                .font(.headline)
//            TextEditor(text: $entry.text)
//                .padding()
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(8)
//        }
//        .navigationTitle("Detaily poznamok")
//    }
//}
//
//struct DiarEntry: Identifiable, Codable {
//    let id: UUID
//    var text: String
//    
//    init(id: UUID = UUID(), text: String) {
//        self.id = id
//        self.text = text
//    }
//}
//
//
//struct Diar_Previews: PreviewProvider {
//    static var previews: some View {
//        Diar()
//    }
//}
