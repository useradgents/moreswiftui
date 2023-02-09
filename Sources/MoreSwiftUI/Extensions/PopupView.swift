//
//  PopupView.swift
//  MoreSwiftUI
//
//  Created by Prigent Roudaut on 31/01/2023.
//
import SwiftUI

extension View {
    func popupView(show: Binding<Bool>, view: AnyView, alpha : Double = 0.5) -> some View {
        self.modifier(PopupViewModifier(show: show, view: view, alpha: alpha))
    }
}

struct PopupViewModifier: ViewModifier {
    @Binding var show: Bool
    var view: AnyView
    var alpha: Double
    func body(content: Content) -> some View {
        ZStack {
            content
            PopupView(showPopUp: show, show: $show, view: view, alpha: alpha)
        }
    }
}

struct PopupView: View {
    @State var showPopUp: Bool
    @Binding var show: Bool
    var view: AnyView
    var alpha: Double

    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Spacer()
                if showPopUp {
                    view
                }
                Spacer()
            }
            .ignoresSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(show ? Color.black.opacity(alpha): Color.clear)
            .ignoresSafeArea(.all)
            .onChange(of: show) { newValue in
                withAnimation {
                    showPopUp = newValue
                }
            }
        }
    }
}
