//
//  ContentView.swift
//  minesweeper
//
//  Created by Ben Zobrist on 6/23/20.
//  Copyright © 2020 Ben Zobrist. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: MineSweeperViewModel
    @State var flagMode: Bool = false
    @State var difficulty: Difficulty = .normal
    @State var currentGridSize: (rows: Int, columns: Int) = (rows: 10, columns: 10)
    @State var showWonAlert: Bool = false
    
    var gridSizes: (rows: Int, columns: Int) {
        if difficulty == .easy {
            return (rows: 7, columns: 7)
        }
        else if difficulty == .normal {
            return (rows: 10, columns: 10)
        }
        else {
            return (rows: 13, columns: 13)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                
                Picker(selection: $difficulty, label: Text("Difficulty")) {
                    Text("Easy").tag(Difficulty.easy)
                    Text("Normal").tag(Difficulty.normal)
                    Text("Expert").tag(Difficulty.expert)
                }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    withAnimation {
                        self.currentGridSize = self.gridSizes
                        self.viewModel.resetGame(difficulty: self.difficulty)
                    }
                })
                {
                    Text("New Game")
                }
                    .padding(.horizontal)
            }
            Spacer()
            HStack {
                VStack {
                    Button(action: {
                        withAnimation {
                            self.flagMode.toggle()
                        }
                    })
                    {
                        Text("Flag Mode")
                            .font(.title)
                            .foregroundColor(self.flagMode ? .green : .gray)
                    }
                }
            
                VStack {
                    Grid (viewModel.cells, size: currentGridSize) { cell in
                        CardView(cell: cell).onTapGesture {
                            withAnimation(.linear) {
                                if !self.flagMode {
                                    self.viewModel.choose(cell: cell)
                                }
                                else {
                                    self.viewModel.flag(cell: cell)
                                }
                                
                                if self.viewModel.gameWon {
                                    self.viewModel.revealAllCells()
                                    self.showWonAlert = true
                                }
                            }
                        }
                            .padding(5)
                    }
                        .foregroundColor(Color.gray)
                        .padding()
                }
                    
                    .frame(width: 700, height: 700, alignment: .center)
                
                VStack {
                    Text("💣 x \(String(format: "%02d", self.viewModel.numBombs)) ")
                        .font(.largeTitle)
//                        .frame(width: 250, height: nil, alignment: .leading)

                    Text("🚩 x \(String(format: "%02d", self.viewModel.numFlags))")
                        .font(.largeTitle)
//                        .frame(width: 250, height: nil, alignment: .leading)
                }

            }

            Spacer()
            
        }
            .padding()
        .alert(isPresented: $showWonAlert) {
                Alert(title: Text("Congrats!"), message: Text("You found all the bombs!"), dismissButton: .default(Text("Ok")))
            }
    }
}

struct CardView: View {
    var cell: MineSweeperGame.Cell
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        ZStack {
            if cell.isRevealed{
                Text(self.cell.isMine ? "💣" : (self.cell.numAdjacentMines != 0 ? "\(self.cell.numAdjacentMines)" : " "))
                    .font(Font.system(size: fontSize(for: size)))
            }
        }
        .cardify(isFaceUp: cell.isRevealed, flagStyle: cell.flag)
    }
    // MARK: - Drawing Constants
    
    private let fontScaleFactor: CGFloat = 0.7
    
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = MineSweeperViewModel()
        game.choose(cell: game.cells[0])
        return ContentView(viewModel: game)
    }
}
