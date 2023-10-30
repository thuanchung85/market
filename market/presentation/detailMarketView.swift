//
//  DetailMarketView.swift
//  market
//
//  Created by Admin on 27/10/2023.
//

import SwiftUI
import LightweightCharts

struct DetailMarketView: View {
    @State var data = MartketItemData(
        id: 1,
        icon: "https://s2.coinmarketcap.com/static/img/coins/64x64/1.png",
        miniChart: "https://s3.coinmarketcap.com/generated/sparklines/web/7d/2781/1.svg",
        name: "Bitcoin",
        symbol: "BTC",
        slug: "bitcoin",
        totalSupply: 19495368,
        cmcRank: 1,
        quote: QuoteMartketData(
            price: 26119.986806942667,
            volume24h: 10806363012.366905,
            volumeChange24h: 68.301,
            percentChange1h: 0.04167903,
            percentChange24h: -1.73428343,
            percentChange7d: -2.20327616,
            percentChange30d: 0.41993002,
            percentChange60d: -11.26987282,
            percentChange90d: -13.95072195,
            marketCap: 509218754956.49225,
            marketCapDominance: 48.8964,
            fullyDilutedMarketCap: 548519722945.8
        )
    )
    @Environment(\.presentationMode) var presentationMode
    
    func dataRowView(
        keyLeft: String,
        valueLeft: Float?,
        keyRight: String,
        valueRight: Float?
    ) -> some View {
        HStack {
            Text(keyLeft)
                .font(.caption)
                .bold()
                .lineLimit(1)
                .foregroundColor(.gray)
            Spacer()
            Text("\(valueLeft ?? 0.0)%")
                .font(.caption)
                .lineLimit(1)
                .foregroundColor(data.quote?.percentChange1h ?? 0.0 > 0 ? .green : .red)
            Text(keyRight)
                .font(.caption)
                .lineLimit(1)
                .foregroundColor(.gray)
            Spacer()
            Text("\((valueRight ?? 0.0), specifier: "%.3f")%")
                .font(.caption)
                .foregroundColor(data.quote?.percentChange24h ?? 0.0 > 0 ? .green : .red)
                .lineLimit(1)
                .frame(width: 80, alignment: .trailing)
        }
        .padding([.leading,.trailing], 20)
    }
    func dataRowView(
        keyLeft: String,
        valueLeft: Float?
    ) -> some View {
        HStack {
            Text(keyLeft)
                .font(.caption)
                .bold()
                .lineLimit(1)
                .foregroundColor(.gray)
            Spacer()
            Text("\(valueLeft ?? 0.0)$")
                .bold()
                .font(.caption)
                .lineLimit(1)
                .foregroundColor(.black)
        }
        .padding([.leading,.trailing], 20)
    }
    var body: some View {
        VStack {
            HStack {
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 5, height: 10)
                            .foregroundColor(.black)
                            .font(.system(size: 10, weight: .bold))
                    }
                )
                Spacer()
                AsyncImage(
                    url: URL(string: data.icon ?? "")!,
                    
                    placeholder: { Text("Loading ...") },
                    
                    image: {
                        Image(uiImage: $0)
                            .resizable()
                    }
                )
                .frame(width: 20, height: 20)
                Text("\(data.symbol ?? "")")
                    .bold()
                Text(data.name ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding([.leading,.trailing], 20)
            ScrollView {
                HStack {
                    Text("\(data.quote?.price ?? 0.0)")
                        .bold()
                        .lineLimit(1)
                        .foregroundColor(.black)
                    Text("\((data.quote?.percentChange24h ?? 0.0), specifier: "%.3f")%")
                        .bold()
                        .foregroundColor(data.quote?.percentChange24h ?? 0.0 > 0 ? .green : .red)
                        .lineLimit(1)
                        .frame(width: 80, alignment: .trailing)
                    Spacer()
                }
                .padding(20)
                VStack{
                    GeometryReader(content: { e in
                        BarChartView(id: data.id ?? 0)
                            .frame(width: e.size.width, height: 300)
                    })
                }
                .frame(height: 300)
                .padding(20)
                dataRowView(keyLeft: "1 hour", valueLeft: data.quote?.percentChange1h, keyRight: "1 day", valueRight: data.quote?.percentChange24h)
                    .padding(.bottom, 10)
                
                dataRowView(keyLeft: "1 week", valueLeft: data.quote?.percentChange7d, keyRight: "1 month", valueRight: data.quote?.percentChange30d)
                    .padding(.bottom, 10)
                
                dataRowView(keyLeft: "2 month", valueLeft: data.quote?.percentChange60d, keyRight: "3 month", valueRight: data.quote?.percentChange90d)
                    .padding(.bottom, 10)
                
                dataRowView(keyLeft: "24h Vol", valueLeft: data.quote?.volume24h)
                    .padding(.bottom, 10)
                
                dataRowView(keyLeft: "Volume change 24h", valueLeft: data.quote?.volumeChange24h)
                    .padding(.bottom, 10)
                
                dataRowView(keyLeft: "Market Cap", valueLeft: data.quote?.marketCap)
                    .padding(.bottom, 10)
            }
            
            Link(destination: URL(string: "https://www.binance.com/en/trade/\(data.symbol ?? "")_USDT?theme=dark&type=spot")!, label: {
                HStack {
                    Spacer()
                    Text("Buy \(data.symbol ?? "")")
                        .bold()
                    Spacer()
                }
                .padding(10)
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(10)
                .padding(20)
            })
        }
        .navigationBarHidden(true)
    }
}

struct DetailMarketView_Previews: PreviewProvider {
    static var previews: some View {
        DetailMarketView()
    }
}
