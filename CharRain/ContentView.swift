//
//  ContentView.swift
//  CharRain
//
//  Created by 香饽饽zizizi on 2024/2/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.16)) { timeline in
            CharRainView(date: timeline.date)
                .ignoresSafeArea()
        }
    }
}

class SavedChar {
    let text: String
    let pos: CGRect
    let color: Color
    var opacity: CGFloat = 1.0

    init(text: String, pos: CGRect, color: Color, opacity: CGFloat) {
        self.text = text
        self.pos = pos
        self.color = color
        self.opacity = opacity
    }

    var textView: Text {
        Text(text)
            .font(.system(size: 16))
            .foregroundStyle(color.opacity(opacity))
    }
}

struct CharRainView: View {
    let date: Date
    let columnSize: CGFloat = 24
    @State private var nextIdx: [Int] = []
    @State private var row: [SavedChar] = []
    @State private var rows: [[SavedChar]] = []

    var body: some View {
        Canvas { context, size in
            context.fill(.init(roundedRect: .init(origin: .zero, size: size), cornerRadius: 0), with: .color(.black))

            for row in rows {
                for ch in row {
                    context.draw(ch.textView, in: ch.pos)
                    ch.opacity -= 0.1
                }
            }
        }
        .onAppear {
            let columnCount = Int(UIScreen.main.bounds.width / columnSize)
            nextIdx = Array(repeating: 0, count: columnCount)
        }
        .onChange(of: date) { _, _ in
            row = []

            for e in nextIdx.enumerated() {
                let pos = CGRect(x: columnSize * CGFloat(e.offset), y: columnSize * CGFloat(e.element), width: columnSize, height: columnSize)

                row.append(
                    SavedChar(text: getRandomChar(), pos: pos, color: getRandomColor(), opacity: 1)
                )
            }
            
            rows.append(row)
            rows = rows.filter({ row in
                return row[0].opacity > 0
            })

            nextIdx = nextIdx.map({ x in
                let result = x + 1
                if x > Int(UIScreen.main.bounds.height / columnSize) && Double.random(in: 0...1) > 0.8 {
                    return 0
                }
                return result
            })
        }
    }
}

func getRandomChar() -> String {
    return String("ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".randomElement() ?? "a")
}

func getRandomColor() -> Color {
    return Color(UIColor(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1), alpha: 1))
}


#Preview {
    ContentView()
}
