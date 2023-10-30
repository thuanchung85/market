//
//  tabView.swift
//  market
//
//  Created by Admin on 30/10/2023.
//

import SwiftUI

struct tabView: View {
    @State var selection: Int = 0
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 0) {
                    Button(action: {
                        selection = 0
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Watch")
                                .bold()
                                .padding(5)
                                .foregroundColor(selection == 0 ? .white : .green)
                            Spacer()
                        }
                        .background(selection != 0 ? Color.white : Color.green )
                        .cornerRadius(50)
                    })
                    Button(action: {
                        selection = 1
                    }, label: {
                        HStack {
                            Spacer()
                            Text("News")
                                .bold()
                                .padding(5)
                                .foregroundColor(selection != 0 ? .white : .green)
                            Spacer()
                        }
                        .background(selection == 0 ? Color.white : Color.green )
                        .cornerRadius(50)
                    })
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(.green, lineWidth: 1)
                )
                .padding([.leading,.trailing], 10)
                TabView(selection: $selection){
                    WatchMarketView().tag(0)
                    newsMarket().tag(1)
                }
                .tabViewStyle(PageTabViewStyle())
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct tabView_Previews: PreviewProvider {
    static var previews: some View {
        tabView()
    }
}
