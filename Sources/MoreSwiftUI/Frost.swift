#if !os(macOS)

//
//  Frost.swift
//  https://gist.github.com/Clarko/8dbe26be36d4d317302791fceda7b30c
//
//  Created by Clarko on 7/19/20.
//
//  A SwiftUI representation of UIVisualEffectView
//  and UIBlurEffect, that handles mostly like a
//  SwiftUI Color view. Use it as a .background()
//  or on its own.
//
//  Don't try to use it as a .fill() or a .border()
//  on a shape, sorry.
//
//  Comes with styles like Frost.thin and Frost.thick
//
import SwiftUI

public struct Frost: UIViewRepresentable, Hashable {
    // Adaptive UI style, matching the system toolbars
    public static var chrome: Frost {
        Frost(style: .systemChromeMaterial)
    }
    
    // Adaptive UI styles, by thickness
    public static var ultraThin: Frost {
        Frost(style: .systemUltraThinMaterial)
    }
    
    public static var thin: Frost {
        Frost(style: .systemThinMaterial)
    }
    
    public static var normal: Frost {
        Frost(style: .systemMaterial)
    }
    
    public static var thick: Frost {
        Frost(style: .systemThickMaterial)
    }
    
    // Content styles, by brightness
    public static var lighter: Frost {
        Frost(style: .extraLight)
    }
    
    public static var neutral: Frost {
        Frost(style: .light)
    }
    
    public static var darker: Frost {
        Frost(style: .dark)
    }
    
    // Implementation
    var style: UIBlurEffect.Style = .systemChromeMaterial
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

#endif
