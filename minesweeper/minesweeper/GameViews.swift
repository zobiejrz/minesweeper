//
//  GameViews.swift
//  minesweeper
//
//  Created by Ben Zobrist on 7/5/20.
//  Copyright © 2020 Ben Zobrist. All rights reserved.
//

import SwiftUI

struct TopBar: View {
    @ObservedObject var viewModel: MineSweeperViewModel
    @Binding var showMenu: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("💣 x \(String(format: "%02d", self.viewModel.numBombs)) ")
                    Text("🚩 x \(String(format: "%02d", self.viewModel.numFlags))")
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                                self.showMenu = true
                        }
                    })
                    {
                        Image(systemName: "ellipsis")
                            .font(.largeTitle)
                    }
                }
                .padding()
            }
        }
    }
}

struct NewGameView: View {
    @ObservedObject var viewModel: MineSweeperViewModel
    @Binding var showNewGameView: Bool
    @State private var difficulty: Difficulty = .normal
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    
                    Picker(selection: $difficulty, label: Text("Difficulty")) {
                        Text("Easy").tag(Difficulty.easy)
                        Text("Normal").tag(Difficulty.normal)
                        Text("Expert").tag(Difficulty.expert)
                    }
                        .pickerStyle(SegmentedPickerStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            self.showNewGameView = false
                            self.viewModel.resetGame(difficulty: self.difficulty)
                        }
                    })
                    {
                        Image(systemName: "arrow.right")
                            .font(.largeTitle)
                    }
                }
                .padding()
            }
        }
        .opacity(showNewGameView ? 1 : 0)
    }
}

struct PauseView: View {
    @ObservedObject var viewModel: MineSweeperViewModel
    @Binding var showMenu: Bool
    @Binding var showNewGameView:Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .foregroundColor(.pauseBackgroundColor)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .opacity(0.5)
                VStack {
                    Spacer()
                    VStack {
                        Text("Paused")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            withAnimation {
                                self.showMenu = false
                            }
                        })
                        {
                            Text("Resume")
                        }
                        Button(action: {
                            withAnimation {
                                self.viewModel.restart()
                            }
                        })
                        {
                            Text("Restart")
                        }
                        Button(action: {
                            withAnimation {
                                self.showMenu = false
                                self.showNewGameView = true
                            }
                        })
                        {
                            Text("New Game")
                        }
                        Button(action: {
                            print("TODO: How to Play")
                        })
                        {
                            Text("How to Play")
                        }
                        Button(action: {
                            print("TODO: Quit")
                        })
                        {
                            Text("Quit")
                        }
                        
                    }
                    .padding(50)
                    .font(.title)
                    .foregroundColor(.secondary)
                    .background(RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.whiteBlack))
                    
                    Spacer()
                    
                    HStack {
                        Text("Development Version")
                            .font(.footnote)
                        Spacer()
                        Text("© Ben Zobrist 2020")
                            .font(.footnote)
                    }
                }
                .padding()
            }
            .opacity(self.showMenu ? 1 : 0)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct Game: View {
    @ObservedObject var viewModel: MineSweeperViewModel
    @State var showWonAlert: Bool = false

    var body: some View {
        VStack {
            Grid (viewModel.cells, size: viewModel.currentGridSize) { cell in
                CardView(cell: cell)
                    .onTapGesture(count: 1) {
                        withAnimation(.linear) {
                            if cell.flag == .none {
                                self.viewModel.choose(cell: cell)
                            }
                            else {
                                self.viewModel.flag(cell: cell)
                            }
                            //                                    self.viewModel.flag(cell: cell)
                            
                            if self.viewModel.gameWon {
                                self.viewModel.revealAllCells()
                                self.showWonAlert = true
                            }
                        }
                }
                .onTapGesture(count: 2) {
                    withAnimation(.linear) {
                        if cell.flag == .none {
                            self.viewModel.choose(cell: cell)
                        }
                        else {
                            self.viewModel.flag(cell: cell)
                        }
                        //                                    self.viewModel.flag(cell: cell)
                        
                        if self.viewModel.gameWon {
                            self.viewModel.revealAllCells()
                            self.showWonAlert = true
                        }
                    }
                }
                .onLongPressGesture {
                    withAnimation(.linear) {
                        //                                    self.viewModel.choose(cell: cell)
                        self.viewModel.flag(cell: cell)
                        
                        if self.viewModel.gameWon {
                            self.viewModel.revealAllCells()
                            self.showWonAlert = true
                        }
                    }
                    
                }
                .padding(5)
            }
            .foregroundColor(Color.white)
            .padding()
        }
        .frame(width: 700, height: 700, alignment: .center)
        .padding()
        .alert(isPresented: $showWonAlert) {
            Alert(title: Text("Congrats!"), message: Text("You found all the bombs!"), dismissButton: .default(Text("Ok")))
        }
    }
}
