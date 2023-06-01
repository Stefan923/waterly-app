//
//  OutlinedDatePicker.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.05.2023.
//

import SwiftUI

struct OutlinedDatePicker: View {
    private let title: String
    private var selectedDate: Binding<Date>
    private let radius: CGFloat
    private let corners: [RectangleCorner]
    private var isWrongValue: Binding<Bool>
    
    init(title: String = "Select date",
         selectedDate: Binding<Date>,
         radius: CGFloat = 0.30,
         corners: [RectangleCorner] = [],
         isWrongValue: Binding<Bool> = Binding.constant(false)) {
        self.title = title
        self.selectedDate = selectedDate
        self.radius = radius
        self.corners = corners
        self.isWrongValue = isWrongValue
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if isWrongValue.wrappedValue {
                    RoundedCornersRectangle(radius: self.radius, corners: self.corners)
                        .fill(Color("TextFieldFillColor"),
                              strokeBorder: Color("ErrorRedColor"),
                              lineWidth: 1.0)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                } else {
                    RoundedCornersRectangle(radius: self.radius, corners: self.corners)
                        .fill(Color("TextFieldFillColor"),
                              strokeBorder: Color("TextFieldEdgeColor"),
                              lineWidth: 1.0)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
                
                HStack {
                    Text(self.title)
                        .foregroundColor(Color("TextFieldFontColor"))
                        .padding([.leading], 20)
                    
                    Spacer(minLength: 0)
                    
                    DatePicker("", selection: selectedDate, displayedComponents: [.date])
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding([.trailing], 20)
                }
            }
        }
        .zIndex(self.isWrongValue.wrappedValue ? 1 : 0)
        .frame(height: 60.0)
    }
}

struct OutlinedDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedDate = Date()
        VStack(spacing: 0) {
            OutlinedDatePicker(selectedDate: $selectedDate,
                               corners: [.top])
                .frame(width: 360)
            
            OutlinedDatePicker(selectedDate: $selectedDate,
                               corners: [],
                               isWrongValue: Binding.constant(true))
                .frame(width: 360)
            
            OutlinedDatePicker(selectedDate: $selectedDate,
                               corners: [.bottom])
                .frame(width: 360)
        }
    }
}

//struct ContentView: View {
//    @State var date = Date()
//
//    var body: some View {
//        ZStack {
//            DatePicker("label", selection: $date, displayedComponents: [.date])
//                .frame(width: 32, height: 32, alignment: .center)
//                .datePickerStyle(DefaultDatePickerStyle())
//                .labelsHidden()
//            Image(systemName: "calendar.circle")
//                .resizable()
//                .frame(width: 32, height: 32, alignment: .center)
//                .userInteractionDisabled()
//        }
//    }
//
//    private var formattedDate: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        return dateFormatter.string(from: date)
//    }
//}
//
//struct NoHitTesting: ViewModifier {
//    func body(content: Content) -> some View {
//        SwiftUIWrapper { content }.allowsHitTesting(false)
//    }
//}
//
//extension View {
//    func userInteractionDisabled() -> some View {
//        self.modifier(NoHitTesting())
//    }
//}
//
//struct SwiftUIWrapper<T: View>: UIViewControllerRepresentable {
//    let content: () -> T
//    func makeUIViewController(context: Context) -> UIHostingController<T> {
//        UIHostingController(rootView: content())
//    }
//    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {}
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
