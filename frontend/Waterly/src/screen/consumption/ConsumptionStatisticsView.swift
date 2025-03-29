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
    
    @State private var consumptions: [IntervalConsumption] = [
        IntervalConsumption(time: Date.now, quantity: 50),
        IntervalConsumption(time: Date.now.addingTimeInterval(12000), quantity: 120),
        IntervalConsumption(time: Date.now.addingTimeInterval(24000), quantity: 130),
        IntervalConsumption(time: Date.now.addingTimeInterval(36000), quantity: 90),
        IntervalConsumption(time: Date.now.addingTimeInterval(48000), quantity: 180),
        IntervalConsumption(time: Date.now.addingTimeInterval(60000), quantity: 140),
        IntervalConsumption(time: Date.now.addingTimeInterval(72000), quantity: 110)
    ]
    let consumptionType: ConsumptionType
    @State private var currentTab: String = "Day"
    @State private var calendarUnit: Calendar.Component = .hour
    @State private var animate: Bool = false
    @State private var currentActiveItem: IntervalConsumption?
    @State private var plotWidth: CGFloat = 0
    @State private var selectedDate: Date = Date.now
    
    var consumptionService = ConsumptionService()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("PrimaryColor")
                    .ignoresSafeArea(.all, edges: .all)
                
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
                        Text("\(consumptionType == .LIQUID ? "Hydration" : "Calorie") Statistics")
                            .foregroundColor(Color("TextFieldFontColor"))
                            .font(.system(size: 20).weight(.bold))
                            .padding([.bottom], 9.0)
                            .frame(alignment: .leading)
                        
                        Spacer()
                    }
                    .padding([.horizontal], geometry.size.width * 0.10)
                    
                    
                    VStack {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Consumption")
                                    .fontWeight(.semibold)
                                
                                Picker("", selection: $currentTab) {
                                    Text("Day").tag("Day")
                                    Text("Week").tag("Week")
                                    Text("Month").tag("Month")
                                }
                                .pickerStyle(.segmented)
                                .padding(.leading, 80)
                            }
                            
                            let totalValue = consumptions.reduce(0.0) { partialResult, item in
                                item.quantity + partialResult
                            }
                            
                            Text(totalValue.toString(consumptionType: consumptionType))
                                .font(.largeTitle.bold())
                            
                            AnimatedChart()
                            
                            HStack {
                                Text("Select date:")
                                    .frame(alignment: .leading)
                                
                                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .padding([.trailing], 20)
                                    .frame(alignment: .leading)
                                
                                Spacer()
                            }
                            .padding(.top, 4)
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.white.shadow(.drop(radius: 2)))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(.horizontal, 24)
                    .onChange(of: currentTab) { nextTab in
                        self.loadConsumptionData(tab: nextTab, selectedDate: selectedDate)
                    }
                    .onChange(of: selectedDate) { nextDate in
                        self.loadConsumptionData(tab: currentTab, selectedDate: nextDate)
                    }
                    .onAppear(perform: {
                        self.loadConsumptionData(tab: currentTab, selectedDate: selectedDate)
                    })
                }
                .colorScheme(.light)
                .padding([.top], geometry.size.height * 0.06)
                .frame(height: geometry.size.height * 0.89, alignment: .top)
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func AnimatedChart() -> some View {
        let max = consumptions.max { item1, item2 in
            return item2.quantity > item1.quantity
        }?.quantity ?? 0
        
        Chart {
            ForEach(consumptions) { item in
                BarMark(x: .value("Hour", item.time, unit: calendarUnit),
                        y: .value("Consumption", item.animate ? item.quantity : 0))
                .foregroundStyle(Color("PrimaryColor").gradient)
                
                if let currentActiveItem, currentActiveItem.id == item.id {
                    RuleMark(x: .value("Hour", currentActiveItem.time))
                        .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                        .offset(x: (self.plotWidth / CGFloat(consumptions.count)) / 2)
                        .annotation (position: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Quantity")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(currentActiveItem.quantity.toString(consumptionType: consumptionType))
                                    .font(.title3.bold())
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(.white.shadow(.drop(radius: 2)))
                            }
                        }
                }
            }
        }
        .chartYScale(domain: 0...(max + 50))
        .chartOverlay(content: { proxy in
            GeometryReader { geometry in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let location = value.location
                                if let date: Date = proxy.value(atX: location.x) {
                                    let calendar = Calendar.current
                                    let time = calendar.component(calendarUnit, from: date)
                                    if let currentItem = consumptions.first(where: { item in
                                        calendar.component(calendarUnit, from: item.time) == time
                                    }) {
                                        self.currentActiveItem = currentItem
                                        self.plotWidth = proxy.plotAreaSize.width
                                    }
                                }
                            }
                            .onEnded { value in
                                self.currentActiveItem = nil
                            }
                    )
            }
        })
        .frame(height: 250)
        .onAppear(perform: {
            animateConsumptionData()
        })
    }
    
    private func loadConsumptionData(tab: String, selectedDate: Date) -> Void {
        var statsType = "hourly"
        var newCalendarUnit: Calendar.Component = .hour
        
        switch tab {
        case "Week":
            newCalendarUnit = .weekday
            statsType = "daily"
            break
        case "Month":
            newCalendarUnit = .day
            statsType = "weekly"
            break
        default:
            newCalendarUnit = .hour
        }
        
        let userId = UserAccountTokenManager.shared.getUserAccountToken()?.getUserId()
        if let userId = userId {
            ConsumptionService().getConsumptionStatisticsByUserId(statsType: statsType, userId: userId, type: consumptionType, date: selectedDate, page: 0, size: 50, completion: { result in
                switch result {
                case .success(let intervalConsumptions):
                    self.consumptions = intervalConsumptions.consumptions
                    animateConsumptionData()
                    calendarUnit = newCalendarUnit
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            })
        }
    }
    
    private func animateConsumptionData() -> Void {
        for (index, _) in consumptions.enumerated() {
            print(consumptions[index])
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    consumptions[index].animate = true
                }
            }
        }
    }
}

struct ConsumptionStatisticsView_Previews : PreviewProvider {
    static var previews: some View {
        ConsumptionStatisticsView(consumptionType: .LIQUID)
    }
}
