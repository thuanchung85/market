//
//  ContentView.swift
//  market
//
//  Created by Admin on 26/10/2023.
//

import Foundation
import SwiftUI
import UIKit
import Combine
import SVGKit

struct WatchMarketView: View {
    @State var searchTF = ""
    @State var isDescending = false
    @State var page = 1
    @State private var isLoading = false
    @State var data = MartketData()
    @State private var timeRemaining = -1
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    func fetchData() {
        isLoading = true
        guard var urlComponents = URLComponents(string: "https://api-dev-poolswallet.poolsmobility.com/pools-wallet/market") else {
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "order", value: isDescending ? "desc" : ""),
            URLQueryItem(name: "limit", value: "20"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "search", value: "\(searchTF)")
        ]
        // Create the request
        guard let url = urlComponents.url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            isLoading = false
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                self.isDescending.toggle()
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(MartketData.self, from: data)
                DispatchQueue.main.async {
                    if page == 1 {
                        self.data = decodedData
                        page += 1
                    }
                    else {
                        if decodedData.data != nil {
                            self.data.data?.append(contentsOf: decodedData.data!)
                            page += 1
                        }
                    }
                    
                }
            } catch {
                self.isDescending.toggle()
                print("Error decoding API response: \(error)")
            }
        }.resume()
    }
    
    func searchView() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.black.opacity(0.6))
            TextField("Search for tokens", text: $searchTF)
                .onChange(of: searchTF, perform: { value in
                    self.timeRemaining = 2
                })
            if !searchTF.isEmpty {
                Button(action: {
                    searchTF = ""
                    self.timeRemaining = -1
                    page = 1
                    fetchData()
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.black)
                })
            }
        }
        .padding(10)
        .padding([.leading,.trailing],10)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(50)
        .padding(10)
        .padding([.leading,.trailing],10)
    }
    
    func sortView() -> some View {
        HStack {
            Button(action: {
                page = 1
                isDescending.toggle()
                fetchData()
            }, label: {
                HStack {
                    Text(!isDescending ? "DESCENDING" : "ASCENDING")
                        .foregroundColor(.black)
                    VStack(spacing: 3) {
                        Image(systemName: "triangle.fill")
                            .resizable()
                            .frame(width: 8, height: 5)
                            .foregroundColor(!isDescending ? .black : .gray)
                        Image(systemName: "triangle.fill")
                            .resizable()
                            .frame(width: 8, height: 5)
                            .rotationEffect(.radians(.pi))
                            .foregroundColor(isDescending ? .black : .gray)
                    }
                }
            })
            Spacer()
        }
        .padding(10)
        .padding([.leading,.trailing],10)
    }
    
    func listView() -> some View {
        ScrollView {
            if data.data != nil {
                ForEach(data.data!, id: \.id) { item in
                    NavigationLink(destination: DetailMarketView(data: item))
                    {
                        HStack {
                            AsyncImage(
                                url: URL(string: item.icon ?? "")!,
                                
                                placeholder: { Text("Loading ...") },
                                
                                image: {
                                    Image(uiImage: $0)
                                        .resizable()
                                }
                            )
                            .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text(item.symbol ?? "")
                                    .bold()
                                    .lineLimit(1)
                                    .foregroundColor(.black)
                                    .frame(width: 50, alignment: .leading)
                                Text(item.name ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                    .frame(width: 50, alignment: .leading)
                            }
                            SVGImageView(url:URL(string: "https://s3.coinmarketcap.com/generated/sparklines/web/30d/2781/\(item.id ?? 0).svg")!, size: CGSize(width: 10, height: 2))
                                .colorMultiply(item.quote?.percentChange24h ?? 0.0 > 0 ? .green : .red)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\((item.quote?.price ?? 0.0), specifier: "%.3f")")
                                    .bold()
                                    .font(.subheadline)
                                    .lineLimit(1)
                                    .foregroundColor(.black)
                                    .frame(width: 80, alignment: .trailing)
                                Text("\((item.quote?.percentChange7d ?? 0.0), specifier: "%.3f")%")
                                    .font(.subheadline)
                                    .foregroundColor(item.quote?.percentChange7d ?? 0.0 > 0 ? .green : .red)
                                    .lineLimit(1)
                                    .frame(width: 80, alignment: .trailing)
                            }
                        }
                    }
                }
                .padding([.leading,.trailing], 20)
                Button(action: {
                    fetchData()
                }, label: {
                    Text("Load more")
                })
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    //Search
                    searchView()
                    
                    //Sort
                    sortView()
                    
                    //List
                    listView()
                    
                }
                .onAppear {
                    page = 1
                    fetchData()
                }
                .onReceive(timer, perform: { time in
                    if timeRemaining > 0 {
                        withAnimation(.easeInOut(duration: 1)) {
                            timeRemaining -= 1
                        }
                        print(timeRemaining)
                    }
                    if timeRemaining == 0 {
                        timeRemaining -= 1
                        page = 1
                        fetchData()
                    }
                    
                })
                if isLoading {
                    Color.black.opacity(0.1)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.white)
                    
                    
                }
            }
        }
    }
}

struct WatchMarketView_Previews: PreviewProvider {
    static var previews: some View {
        WatchMarketView()
    }
}

