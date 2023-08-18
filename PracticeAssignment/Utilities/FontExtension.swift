//
//  FontExtension.swift
//  ExampleAssignment
//
//  Created by Aaryan jaiswal on 19/08/23.
//
import UIKit

extension UIFont {
    static func inter(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        var font: UIFont
        
        switch weight {
        case .ultraLight:
            font = UIFont(name: "Inter-UltraLight", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .thin:
            font = UIFont(name: "Inter-Thin", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .light:
            font = UIFont(name: "Inter-Light", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .regular:
            font = UIFont(name: "Inter-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .medium:
            font = UIFont(name: "Inter-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .semibold:
            font = UIFont(name: "Inter-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .bold:
            font = UIFont(name: "Inter-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .heavy:
            font = UIFont(name: "Inter-Heavy", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .black:
            font = UIFont(name: "Inter-Black", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        default:
            font = UIFont.systemFont(ofSize: size, weight: weight)
        }
        
        return font
    }
}

