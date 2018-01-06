//
//  IconModel.swift
//  CustomCamera
//
//  Created by Mac Mini on 1/6/18.
//  Copyright © 2018 FAYA Corporation. All rights reserved.
//

import Foundation

enum CardType: String {
    case hearts = "hearts"
    case diamonds = "diamonds"
    case clubs = "clubs"
    case spades = "spades"
}

enum CardName: String {
    case ace = "A"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case ten = "10"
    case jack = "J"
    case queen = "Q"
    case king = "K"
}

struct CardModel {
    let name: CardName
    let kind: CardType = .hearts
    
    init(name: CardName) {
        self.name = name
    }
    
    static let ofCards: [CardModel] = {
        let ace = CardModel(name: .ace)
        let two = CardModel(name: .two)
        let three = CardModel(name: .three)
        let four = CardModel(name: .four)
        let five = CardModel(name: .five)
        let six = CardModel(name: .six)
        let seven = CardModel(name: .seven)
        let eight = CardModel(name: .eight)
        let nine = CardModel(name: .nine)
        let ten = CardModel(name: .ten)
        let j = CardModel(name: .jack)
        let q = CardModel(name: .queen)
        let k = CardModel(name: .king)

        return [ace, two, three, four, five, six, seven, eight, nine, ten, j, q, k]
    }()
    
    static let ofTypes = {
        return ["Cơ", "Rô", "Chuồn", "Bích"]
    }()
}
