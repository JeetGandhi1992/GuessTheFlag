//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jeet Gandhi on 26/3/21.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct CapsuleShape: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .overlay(Capsule()
                        .stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
    
    func capsuleStyle() -> some View {
        self.modifier(CapsuleShape())
    }
}

struct Watermark: ViewModifier {
    var text: String
    
    init(_ text: String) {
        self.text = text
    }

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.blue)
        }
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        self.modifier(Watermark(text))
    }
}

extension Image {
    func flagImage() -> some View {
        self
            .renderingMode(.original)
            .capsuleStyle()
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreSubTitle = ""
    @State private var score: Int = 0
    
    @State private var useRedText = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .flagImage()
                    }
                }
                Text("Current score: \(score)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    self.score = 0
                    self.askQuestion()
                }, label: {
                    Text("Reset")
                })
                .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.white)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 100.0))
                .overlay(RoundedRectangle(cornerRadius: 100.0)
                            .stroke(Color.white, lineWidth: 1))
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle),
                  message: Text(scoreSubTitle),
                  dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                  })
        }.watermarked(with: "Hacking with Swift")
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            scoreSubTitle = "That’s the flag of \(countries[correctAnswer])"
            score += 1
        } else {
            scoreTitle = "Wrong"
            scoreSubTitle = "That’s the flag of \(countries[correctAnswer])"
            score -= 1
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
}

struct GridStackCustom<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(alignment: .center, spacing: 10) {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }.padding(5)
    }
}

struct ContentView2: View {
    var body: some View {
        GridStackCustom(rows: 4, columns: 4) { row, col in
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: "\(row * 4 + col).circle")
                Text("R\(row)C\(col)")
                Spacer()
            }
        }
    }
}

struct ContentView3: View {
    var body: some View {
        let columns: [GridItem] =
            Array(repeating: .init(.flexible(), spacing: 10, alignment: .center),
                  count: 6)
        VStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach((0...79), id: \.self) {
                        let codepoint = $0 + 0x1f600
                        let codepointString = String(format: "%02X", codepoint)
                        Text("\(codepointString)")
                        let emoji = String(Character(UnicodeScalar(codepoint)!))
                        Text("\(emoji)")
                    }
                }.font(.system(size: 14)).padding()
            }
            ScrollView(.horizontal) {
                LazyHGrid(rows: columns) {
                    ForEach((0...79), id: \.self) {
                        let codepoint = $0 + 0x1f600
                        let codepointString = String(format: "%02X", codepoint)
                        Text("\(codepointString)")
                        let emoji = String(Character(UnicodeScalar(codepoint)!))
                        Text("\(emoji)")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
