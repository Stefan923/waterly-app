//
//  ConsumptionStatisticsView.swift
//  Waterly
//
//  Created by Stefan Popescu on 04.05.2023.
//

import SwiftUI
import Charts

struct ConsumptionStatisticsView : View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var router: Router
    
    private var stackedBarData: [DataEntry] = [
        .init(date: "25-04-2023", count: 17),
        .init(date: "26-04-2023", count: 15),
        .init(date: "27-04-2023", count: 19),
        .init(date: "28-04-2023", count: 21),
        .init(date: "29-04-2023", count: 17),
        .init(date: "30-04-2023", count: 15),
        .init(date: "01-05-2023", count: 17),
        .init(date: "02-05-2023", count: 19),
        .init(date: "03-05-2023", count: 18),
        .init(date: "04-05-2023", count: 18)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("PrimaryColor")
                    .ignoresSafeArea(.all, edges: .all)
                
                ZStack {
                    VStack {
                        Spacer()
                        
                        WaveEdgedRectangle()
                            .fill(Color("SecondaryColor"))
                            .shadow(color: .black.opacity(0.25), radius: 15, x: 0, y: -10)
                            .frame(height: geometry.size.height * 0.98, alignment: .bottom)
                    }
                    .frame(height: geometry.size.height * 1.05)
                    
                    VStack {
                        HStack {
                            Text("Liquids consumption statistics")
                                .foregroundColor(Color("TextFieldFontColor"))
                                .font(.system(size: 20).weight(.bold))
                                .padding([.bottom], 9.0)
                                .frame(alignment: .leading)
                            
                            Spacer()
                        }
                        .padding([.horizontal], geometry.size.width * 0.10)
                        
                        ZStack {
                            RoundedCornersRectangle(radius: 0.02, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                                .fill(Color("RectangleFillColor"),
                                      strokeBorder: Color("RectangleEdgeColor"),
                                      lineWidth: 1.0)
                                .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.80)
                            
                            Chart {
                                ForEach(stackedBarData) { shape in
                                    BarMark(
                                        x: .value("Shape Type", shape.date),
                                        y: .value("Total Count", shape.count)
                                    )
                                    .foregroundStyle(by: .value("Shape Color", shape.count))
                                }
                            }
                            .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.40)
                        }
                    }
                    .padding([.top], geometry.size.height * 0.06)
                }
            }
        }
    }
}

struct DataEntry : Identifiable {
    var date: String
    var count: Int
    var id = UUID()
}

struct ConsumptionStatisticsView_Previews : PreviewProvider {
    static var previews: some View {
        ConsumptionStatisticsView()
    }
}
