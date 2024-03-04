import SwiftUI

struct Diar: View {
    @State private var selectedCategory: String?
    @State private var isNoteEditorActive = false
    @State private var currentDate = Date()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()

    var body: some View {
        NavigationView {
            ScrollView{
                VStack(spacing: 10) {
                    Text("Your Notes")
                        .font(.title)
                        .padding()
                    
                    HStack {
                        Button(action: {
                            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? Date()
                        }) {
                            Image(systemName: "chevron.left")
                        }
                        
                        Text(dateFormatter.string(from: currentDate))
                            .font(.headline)
                            .padding()
                        
                        Button(action: {
                            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? Date()
                        }) {
                            Image(systemName: "chevron.right")
                        }
                    }
                    
                    ExtractedNoteView(icon: "case", text: "work", color: .yellow.opacity(0.5))
                        .onTapGesture {
                            selectedCategory = "work"
                            isNoteEditorActive = true
                        }
                    
                    ExtractedNoteView(icon: "person", text: "personal", color: .green.opacity(0.5))
                        .onTapGesture {
                            selectedCategory = "personal"
                            isNoteEditorActive = true
                        }
                    
                    ExtractedNoteView(icon: "book.closed", text: "reading", color: .red.opacity(0.5))
                        .onTapGesture {
                            selectedCategory = "reading"
                            isNoteEditorActive = true
                        }
                    
                    ExtractedNoteView(icon: "moon", text: "sleep", color: .blue.opacity(0.5))
                        .onTapGesture {
                            selectedCategory = "sleep"
                            isNoteEditorActive = true
                        }
                }
                .padding(25)
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $isNoteEditorActive) {
                    NoteEditorView()
                }
                .onAppear {
                    selectedCategory = nil // Resetovanie vybranej kategórie po návrate na obrazovku Diar
                }
            }
        }
    }
}

struct ExtractedNoteView: View {
    var icon: String
    var text: String
    var color: Color // Pridaná premenná pre farbu pozadia

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .padding()
                    .background(color.opacity(0.3)) // Použitie zadaného vybraného farebného tónu
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
            Spacer()
            Text(text)
                .font(.title)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color.opacity(0.2)) // Použitie zadaného vybraného farebného tónu
        .cornerRadius(15)
    }
}

struct NoteEditorView: View {
    @State private var noteTitle = ""
    @State private var noteText = ""
    @Environment(\.presentationMode) var presentationMode // Potrebujeme environment pre zatvorenie aktuálneho výhľadu

    var body: some View {
        VStack {
            TextField("Enter title", text: $noteTitle)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top)
            
            TextEditor(text: $noteText)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                saveNote()
            }) {
                Text("Save")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
    
    func saveNote() {
        // Tu môžeš pridať kód na uloženie poznámky, napr. do databázy alebo iného úložiska
        // Tu len vypíšeme poznámku do konzoly
        print("Note saved: \(noteText)")
        
        // Po uložení poznámky zatvoríme aktuálny výhľad
        presentationMode.wrappedValue.dismiss()
    }
}

struct Diar_Previews: PreviewProvider {
    static var previews: some View {
        Diar()
    }
}
