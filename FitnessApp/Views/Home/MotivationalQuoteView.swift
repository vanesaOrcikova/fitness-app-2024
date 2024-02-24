import Foundation
import SwiftUI

struct MotivationalQuoteView :View{
    @State private var contentDataMotivationQuote: [HomeMotivationQuoteModel]? = []
    
    var body : some View{
        VStack {
            Text("Motivational Quote:")
                .font(.headline)
                .padding(.top, 16)
            
//tento kód zaisťuje zobrazenie motivujúceho citátu z dátového zdroja contentDataMotivationQuote, pokiaľ sú tieto citáty k dispozícii a nie sú prázdne. V prípade nedostupnosti citátov alebo prázdneho poľa je zobrazená chybová správa.
            if let motivationQuote = self.contentDataMotivationQuote, !motivationQuote.isEmpty {
                Text(self.contentDataMotivationQuote?[GlobalData.getCurrentDayIndex()].quote ?? "") //Tento riadok zobrazuje motivujúci citát. Ak sú dáta dostupné, použije sa citát pre aktuálny deň. Ak údaje nie sú dostupné alebo citát pre aktuálny deň nie je k dispozícii, zobrazí sa prázdny reťazec.
            } else {
                Text("ERROR: No quote available.")
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
        //.padding()
        .onAppear{
            self.contentDataMotivationQuote = ContentLoader.loadJSON(fileName: "ContentData/HomeMotivationQuote", type: [HomeMotivationQuoteModel].self)
        }
        .offset(y: 15)
    }
}
