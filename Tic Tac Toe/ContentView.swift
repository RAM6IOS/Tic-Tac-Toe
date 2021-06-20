//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by MAC on 6/5/2021.
//

import SwiftUI

struct ContentView: View {
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            
        ]
    
    @State private var moves :[Move?] = Array(repeating : nil , count :9)
    @State private var isGameboardDisabled = false
    @State private var alertItem: AlertItem?
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer()
                LazyVGrid(columns:columns){
                    ForEach(0 ..< 9 ){ i in
                        ZStack{
                        Circle()
                            .foregroundColor(.red).opacity(0.9)
                            .frame(width: geometry.size.width/3-15, height: geometry.size.width/3-15)
                            
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 48, height: 48)
                        
                        }
                        .onTapGesture {
                            if isSquareOccupired(in: moves, forIndex: i){return}
                            
                            moves[i] = Move(player: .human , boardIndex: i)
                            
                           
                            
                            if checkWinCondition(for: .human, in: moves){
                                alertItem = AlertContext.humanWin
                                return
                            }
                            
                            if checkForDrew(in: moves){
                                alertItem = AlertContext.draw
                                return
                            }
                            isGameboardDisabled = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                let computerPosition =  determineComputerMovePosition(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                
                                
                                if checkWinCondition(for: .computer, in: moves){
                                    alertItem = AlertContext.computerWin
                                    return
                                }
                                if checkForDrew(in: moves){
                                    alertItem = AlertContext.draw
                                    return
                                }
                                isGameboardDisabled = false
                                
                            }
                            
                        }
                        
                    }
                    
                }
                Spacer()
                
            }
            .disabled(isGameboardDisabled)
            .alert(item: $alertItem, content: {alerItem in Alert(title: alerItem.title, message: alerItem.memssage, dismissButton: .default(alerItem.buttontitle , action:{restGame()} ) ) })
            
        }
       
      
            
        }
   
    func isSquareOccupired( in moves: [Move?], forIndex index:Int)-> Bool{
        
        return moves.contains(where:{ $0?.boardIndex == index })
    }
    func determineComputerMovePosition ( in moes:[Move?])-> Int{
        
        let winPatterns : Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let computerMoves = moves.compactMap {$0}.filter {$0.player == .computer}
        
        let computerPositions = Set(computerMoves.map{ $0.boardIndex} )
        
        for pattern in  winPatterns {
            
            let winPatterns = pattern.subtracting(computerPositions)
            
            if  winPatterns .count == 1 {
                let isAvaile = !isSquareOccupired(in: moves, forIndex: winPatterns.first!)
                if isAvaile{return winPatterns.first!}
            }
        }
        
        
        let humanMoves = moves.compactMap {$0}.filter {$0.player == .computer}
        
        let humanPositions = Set(humanMoves.map{ $0.boardIndex} )
        
        for pattern in  winPatterns {
            
            let winPatterns = pattern.subtracting(humanPositions)
            
            if  winPatterns .count == 1 {
                let isAvaile = !isSquareOccupired(in: moves, forIndex: winPatterns.first!)
                if isAvaile{return winPatterns.first!}
            }
        }
        
        let centerSquare = 4
        if !isSquareOccupired(in: moves, forIndex: centerSquare){
            return centerSquare
        }
        
        
        
        
        
        
        var movePoseition = Int.random(in: 0..<9)
        while isSquareOccupired(in: moves, forIndex:movePoseition){
              movePoseition = Int.random(in: 0..<9)
        }
        
        return movePoseition
        
    }
    
    func checkWinCondition(for player:Player , in moves:[Move?])->Bool{
        let winPatterns : Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let playerMoves = moves.compactMap {$0}.filter {$0.player == player}
        
        let playerPositions = Set(playerMoves.map{ $0.boardIndex} )
        
        for pattern in winPatterns where pattern.isSubset(of :playerPositions){return true}
        
        return false
          
        
    }
    
    func checkForDrew (in moves:[Move?])->Bool{
        return moves.compactMap{ $0 }.count == 9
    }
    
    func restGame(){
        moves = Array(repeating : nil , count :9)
    }

}

enum Player {
    case human , computer
}

struct Move {
    let player : Player
    var boardIndex :Int
    
    var indicator :String{
        return player == .human ? "xmark" : "circle"
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
