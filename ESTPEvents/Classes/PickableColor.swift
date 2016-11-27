//
//  PickableColor.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 20/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

enum PickableColor: Int, MajorColor {
    struct Hex: Color {
        let hex: String
        init(_ hex: String) { self.hex = hex }
    }

    case red = 0
    case pink
    case purple
    case deepPurple
    case indigo
    case blue
    case lightBlue
    case cyan
    case teal
    case green
    case lightGreen
    case lime
    case yellow
    case amber
    case orange
    case deepOrange
    case brown
    case grey
    case blueGrey

    var declinaisons: [Color] {
        switch self {
        case .red:
            return [
                Hex("#FFEBEE"),
                Hex("#FFCDD2"),
                Hex("#EF9A9A"),
                Hex("#E57373"),
                Hex("#EF5350"),
                Hex("#F44336"),
                Hex("#E53935"),
                Hex("#D32F2F"),
                Hex("#C62828"),
                Hex("#B71C1C"),
                Hex("#FF8A80"),
                Hex("#FF5252"),
                Hex("#FF1744"),
                Hex("#D50000")
            ]
        case .pink:
            return [
                Hex("#FCE4EC"),
                Hex("#F8BBD0"),
                Hex("#F48FB1"),
                Hex("#F06292"),
                Hex("#EC407A"),
                Hex("#E91E63"),
                Hex("#D81B60"),
                Hex("#C2185B"),
                Hex("#AD1457"),
                Hex("#880E4F"),
                Hex("#FF80AB"),
                Hex("#FF4081"),
                Hex("#F50057"),
                Hex("#C51162")
            ]
        case .purple:
            return [
                Hex("#F3E5F5"),
                Hex("#E1BEE7"),
                Hex("#CE93D8"),
                Hex("#BA68C8"),
                Hex("#AB47BC"),
                Hex("#9C27B0"),
                Hex("#8E24AA"),
                Hex("#7B1FA2"),
                Hex("#6A1B9A"),
                Hex("#4A148C"),
                Hex("#EA80FC"),
                Hex("#E040FB"),
                Hex("#D500F9"),
                Hex("#AA00FF")
            ]
        case .deepPurple:
            return [
                Hex("#EDE7F6"),
                Hex("#D1C4E9"),
                Hex("#B39DDB"),
                Hex("#9575CD"),
                Hex("#7E57C2"),
                Hex("#673AB7"),
                Hex("#5E35B1"),
                Hex("#512DA8"),
                Hex("#4527A0"),
                Hex("#311B92"),
                Hex("#B388FF"),
                Hex("#7C4DFF"),
                Hex("#651FFF"),
                Hex("#6200EA")
            ]
        case .indigo:
            return [
                Hex("#E8EAF6"),
                Hex("#C5CAE9"),
                Hex("#9FA8DA"),
                Hex("#7986CB"),
                Hex("#5C6BC0"),
                Hex("#3F51B5"),
                Hex("#3949AB"),
                Hex("#303F9F"),
                Hex("#283593"),
                Hex("#1A237E"),
                Hex("#8C9EFF"),
                Hex("#536DFE"),
                Hex("#3D5AFE"),
                Hex("#304FFE")
            ]
        case .blue:
            return [
                Hex("#E3F2FD"),
                Hex("#BBDEFB"),
                Hex("#90CAF9"),
                Hex("#64B5F6"),
                Hex("#42A5F5"),
                Hex("#2196F3"),
                Hex("#1E88E5"),
                Hex("#1976D2"),
                Hex("#1565C0"),
                Hex("#0D47A1"),
                Hex("#82B1FF"),
                Hex("#448AFF"),
                Hex("#2979FF"),
                Hex("#2962FF")
            ]
        case .lightBlue:
            return [
                Hex("#E1F5FE"),
                Hex("#B3E5FC"),
                Hex("#81D4FA"),
                Hex("#4FC3F7"),
                Hex("#29B6F6"),
                Hex("#03A9F4"),
                Hex("#039BE5"),
                Hex("#0288D1"),
                Hex("#0277BD"),
                Hex("#01579B"),
                Hex("#80D8FF"),
                Hex("#40C4FF"),
                Hex("#00B0FF"),
                Hex("#0091EA")
            ]
        case .cyan:
            return [
                Hex("#E0F7FA"),
                Hex("#B2EBF2"),
                Hex("#80DEEA"),
                Hex("#4DD0E1"),
                Hex("#26C6DA"),
                Hex("#00BCD4"),
                Hex("#00ACC1"),
                Hex("#0097A7"),
                Hex("#00838F"),
                Hex("#006064"),
                Hex("#84FFFF"),
                Hex("#18FFFF"),
                Hex("#00E5FF"),
                Hex("#00B8D4")
            ]
        case .teal:
            return [
                Hex("#E0F2F1"),
                Hex("#B2DFDB"),
                Hex("#80CBC4"),
                Hex("#4DB6AC"),
                Hex("#26A69A"),
                Hex("#009688"),
                Hex("#00897B"),
                Hex("#00796B"),
                Hex("#00695C"),
                Hex("#004D40"),
                Hex("#A7FFEB"),
                Hex("#64FFDA"),
                Hex("#1DE9B6"),
                Hex("#00BFA5")
            ]
        case .green:
            return [
                Hex("#E8F5E9"),
                Hex("#C8E6C9"),
                Hex("#A5D6A7"),
                Hex("#81C784"),
                Hex("#66BB6A"),
                Hex("#4CAF50"),
                Hex("#43A047"),
                Hex("#388E3C"),
                Hex("#2E7D32"),
                Hex("#1B5E20"),
                Hex("#B9F6CA"),
                Hex("#69F0AE"),
                Hex("#00E676"),
                Hex("#00C853")
            ]
        case .lightGreen:
            return [
                Hex("#F1F8E9"),
                Hex("#DCEDC8"),
                Hex("#C5E1A5"),
                Hex("#AED581"),
                Hex("#9CCC65"),
                Hex("#8BC34A"),
                Hex("#7CB342"),
                Hex("#689F38"),
                Hex("#558B2F"),
                Hex("#33691E"),
                Hex("#CCFF90"),
                Hex("#B2FF59"),
                Hex("#76FF03"),
                Hex("#64DD17")
            ]
        case .lime:
            return [
                Hex("#F9FBE7"),
                Hex("#F0F4C3"),
                Hex("#E6EE9C"),
                Hex("#DCE775"),
                Hex("#D4E157"),
                Hex("#CDDC39"),
                Hex("#C0CA33"),
                Hex("#AFB42B"),
                Hex("#9E9D24"),
                Hex("#827717"),
                Hex("#F4FF81"),
                Hex("#EEFF41"),
                Hex("#C6FF00"),
                Hex("#AEEA00")
            ]
        case .yellow:
            return [
                Hex("#FFFDE7"),
                Hex("#FFF9C4"),
                Hex("#FFF59D"),
                Hex("#FFF176"),
                Hex("#FFEE58"),
                Hex("#FFEB3B"),
                Hex("#FDD835"),
                Hex("#FBC02D"),
                Hex("#F9A825"),
                Hex("#F57F17"),
                Hex("#FFFF8D"),
                Hex("#FFFF00"),
                Hex("#FFEA00"),
                Hex("#FFD600")
            ]
        case .amber:
            return [
                Hex("#FFF8E1"),
                Hex("#FFECB3"),
                Hex("#FFE082"),
                Hex("#FFD54F"),
                Hex("#FFCA28"),
                Hex("#FFC107"),
                Hex("#FFB300"),
                Hex("#FFA000"),
                Hex("#FF8F00"),
                Hex("#FF6F00"),
                Hex("#FFE57F"),
                Hex("#FFD740"),
                Hex("#FFC400"),
                Hex("#FFAB00")
            ]
        case .orange:
            return [
                Hex("#FFF3E0"),
                Hex("#FFE0B2"),
                Hex("#FFCC80"),
                Hex("#FFB74D"),
                Hex("#FFA726"),
                Hex("#FF9800"),
                Hex("#FB8C00"),
                Hex("#F57C00"),
                Hex("#EF6C00"),
                Hex("#E65100"),
                Hex("#FFD180"),
                Hex("#FFAB40"),
                Hex("#FF9100"),
                Hex("#FF6D00")
            ]
        case .deepOrange:
            return [
                Hex("#FBE9E7"),
                Hex("#FFCCBC"),
                Hex("#FFAB91"),
                Hex("#FF8A65"),
                Hex("#FF7043"),
                Hex("#FF5722"),
                Hex("#F4511E"),
                Hex("#E64A19"),
                Hex("#D84315"),
                Hex("#BF360C"),
                Hex("#FF9E80"),
                Hex("#FF6E40"),
                Hex("#FF3D00"),
                Hex("#DD2C00")
            ]
        case .brown:
            return [
                Hex("#EFEBE9"),
                Hex("#D7CCC8"),
                Hex("#BCAAA4"),
                Hex("#A1887F"),
                Hex("#8D6E63"),
                Hex("#795548"),
                Hex("#6D4C41"),
                Hex("#5D4037"),
                Hex("#4E342E"),
                Hex("#3E2723")
            ]
        case .grey:
            return [
                Hex("#FAFAFA"),
                Hex("#F5F5F5"),
                Hex("#EEEEEE"),
                Hex("#E0E0E0"),
                Hex("#BDBDBD"),
                Hex("#9E9E9E"),
                Hex("#757575"),
                Hex("#616161"),
                Hex("#424242"),
                Hex("#212121")
            ]
        case .blueGrey:
            return [
                Hex("#ECEFF1"),
                Hex("#CFD8DC"),
                Hex("#B0BEC5"),
                Hex("#90A4AE"),
                Hex("#78909C"),
                Hex("#607D8B"),
                Hex("#546E7A"),
                Hex("#455A64"),
                Hex("#37474F"),
                Hex("#263238")
            ]
        }
    }

    var hex: String {
        let count = declinaisons.count
        return declinaisons[count / 2].hex
    }

    static var possibleColors: [PickableColor] {
        return [
            .red,
            .pink,
            .purple,
            .deepPurple,
            .indigo,
            .blue,
            .lightBlue,
            .cyan,
            .teal,
            .green,
            .lightGreen,
            .lime,
            .yellow,
            .amber,
            .orange,
            .deepOrange,
            .brown,
            .grey,
            .blueGrey
        ]
    }
}
