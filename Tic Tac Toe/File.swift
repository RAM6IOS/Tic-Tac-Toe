//
//  File.swift
//  Tic Tac Toe
//
//  Created by MAC on 10/5/2021.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title : Text
    var memssage : Text
    var buttontitle :Text
}
struct AlertContext {
   static let humanWin = AlertItem(title: Text("you win"), memssage: Text("you are smart "), buttontitle: Text("Hell yeah"))
    
   static let computerWin = AlertItem(title: Text("you lose"), memssage: Text("Try again "), buttontitle: Text("Hell yeah"))
    static let draw = AlertItem(title: Text("draw"), memssage: Text(" Try again"), buttontitle: Text("Hell yeah"))
    
}
