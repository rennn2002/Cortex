//
//  CardView.swift
//  Cortex
//
//  Created by Nomura Rentaro on 2021/12/28.
//

import SwiftUI
import CoreData

struct CardView: View {
    
    //arguments
    var id: UUID
    var word: String
    var word_trans: String
    var status: String

    @State var isFaceUp: Bool = true
    
    @State var cardRotation: Double = 0.0
    @State var contentRotation: Double = 0.0
    
    @State var cardColor: Color = Color.white
    @State var isLongPressed: Bool = false
    
    @State var offset = CGSize.zero
    
    @State var colorsDict: [String:Color] = ["green": Color.green, "blue": Color.blue, "pink": Color.pink, "white": Color.white]
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(  // FetchRequest updates View corresponding to the change of data
        entity: Word.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Word.timestamp, ascending: true)], predicate: nil
    ) private var words: FetchedResults<Word>
    
    let haptics = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            if self.isFaceUp {
                Text(self.word)
                    .font(.title)
                    .fontWeight(.bold)
                    .rotation3DEffect(Angle.degrees(self.contentRotation), axis: (0,1,0))
                    .zIndex(1)
                StatusIconView(id: self.id, color: self.colorsDict[self.status]!)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height * 0.35, alignment: .topTrailing)
                    .zIndex(2)
            } else {
                Text(self.word_trans)
                    .font(.title)
                    .fontWeight(.bold)
                    .rotation3DEffect(Angle.degrees(self.contentRotation), axis: (0,1,0))
                    .zIndex(1)
                EmptyView()
                    .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height * 0.35, alignment: .topTrailing)
                    .zIndex(2)
            }
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(self.cardColor)
                .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height * 0.35)
                .padding()
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 3, y: 3)
                .zIndex(0)
        }
        .onTapGesture {
            flipCard()
            self.haptics.notificationOccurred(.success)
        }
        .rotation3DEffect(Angle.degrees(self.cardRotation), axis: (0,1,0))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    withAnimation(.linear(duration: 1)) {
                    self.offset = gesture.translation
                    }
                }
                .onEnded { _ in
                    if abs(self.offset.width) > 100 {
                        // remove the card
                        withAnimation(.linear(duration: 1)) {
                        delete(id: self.id)
                        }
                } else {
                    self.offset = .zero
                }
            }
        )
    }
    
    func delete(id: UUID) {
        let wordRequested: NSFetchRequest<Word> = Word.fetchRequest()
        wordRequested.predicate = NSPredicate.init(format: "id=%@", id.uuidString)
        let savedWords =  try? context.fetch(wordRequested) // search word by UUID
        for word in savedWords! {
            context.delete(word)
        }
        try? context.save()
       
    }
    func flipCard() {
        withAnimation(Animation.linear(duration: 0.7)) {
            self.cardRotation += 180
        }
        withAnimation(Animation.linear(duration: 0.001).delay(0.7/2)) {
            self.contentRotation += 180
            self.isFaceUp.toggle()
        }
    }
}

