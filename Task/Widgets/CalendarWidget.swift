import SwiftUI

struct CalendarWidget: View {
    struct DayWidget: View {
        private var currentYear: Int
        private var currentMonth: Int
        private var day: Int
        @Binding private var chosenDate: Date
        @Binding private var chosenYear: Int
        @Binding private var chosenMonth: Int
        @Binding private var chosenDay: Int
        @Binding private var chosenHour: Int
        @Binding private var chosenMinute: Int
        
        init(_ day: Int, currentYear: Int, currentMonth: Int, chosenDate: Binding<Date>, chosenYear: Binding<Int>, chosenMonth: Binding<Int>, chosenDay: Binding<Int>, chosenHour: Binding<Int>, chosenMinute: Binding<Int>) {
            self.currentYear = currentYear
            self.currentMonth = currentMonth
            self.day = day
            self._chosenDate = chosenDate
            self._chosenYear = chosenYear
            self._chosenMonth = chosenMonth
            self._chosenDay = chosenDay
            self._chosenHour = chosenHour
            self._chosenMinute = chosenMinute
        }
        
        private var isChosen: Bool {
            day == chosenDay && currentMonth == chosenMonth && currentYear == chosenYear
        }
        
        var body: some View {
            Button {
                chosenDay = day
                chosenMonth = currentMonth
                chosenYear = currentYear
                chosenDate = Date(year: chosenYear, month: chosenMonth, day: chosenDay, hour: chosenHour, minute: chosenMinute)
            } label: {
                ZStack {
                    Circle()
                        .fill(isChosen ? .accentColor : Color(NSColor.textColor).opacity(0.05))
                        .frame(width: 30, height: 30)
                    Text(day.description)
                        .font(.title3.weight(.ultraLight))
                        .foregroundColor(isChosen ? .white : .primary)
                }
            }
            .buttonStyle(.plain)
            .padding(.all, 2.5)
        }
    }
    
    @State private var currentYear: Int
    @State private var currentMonth: Int
    @State private var weekdayOfTheFirstDayOfTheMonth: Int
    @State private var daysInMonth: Int
    @Binding private var chosenDate: Date
    @State private var chosenYear: Int
    @State private var chosenMonth: Int
    @State private var chosenDay: Int
    @State private var chosenHour: Int
    @State private var chosenMinute: Int
    
    init(_ chosenDate: Binding<Date>) {
        self._chosenDate = chosenDate
        self._chosenYear = State(initialValue: chosenDate.wrappedValue.year)
        self._chosenMonth = State(initialValue: chosenDate.wrappedValue.month)
        self._chosenDay = State(initialValue: chosenDate.wrappedValue.day)
        self._currentYear = State(initialValue: chosenDate.wrappedValue.year)
        self._currentMonth = State(initialValue: chosenDate.wrappedValue.month)
        self._weekdayOfTheFirstDayOfTheMonth = State(initialValue: chosenDate.wrappedValue.weekdayOfTheFirstDayOfTheMonth)
        self._daysInMonth = State(initialValue: chosenDate.wrappedValue.daysInMonth)
        self._chosenHour = State(initialValue: chosenDate.wrappedValue.hour)
        self._chosenMinute = State(initialValue: chosenDate.wrappedValue.minute)
    }
    
    private var wholeWeekCount: Int {
        (daysInMonth - (7 - weekdayOfTheFirstDayOfTheMonth)) / 7
    }
    
    private var daysCountInLastWeek: Int {
        (daysInMonth - (7 - weekdayOfTheFirstDayOfTheMonth)) % 7
    }
    
    var body: some View {
        GroupBox {
            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                GridRow {
                    Text("周日")
                    Text("周一")
                    Text("周二")
                    Text("周三")
                    Text("周四")
                    Text("周五")
                    Text("周六")
                }
                .font(.headline)
                .foregroundColor(.secondary)
                Divider()
                    .padding(.vertical, 5)
                GridRow {
                    if weekdayOfTheFirstDayOfTheMonth >= 1 {
                        ForEach(1...weekdayOfTheFirstDayOfTheMonth, id: \.self) { _ in
                            Spacer()
                                .frame(width: 0, height: 0)
                        }
                    }
                    ForEach(weekdayOfTheFirstDayOfTheMonth..<7, id: \.self) { index in
                        DayWidget(index - weekdayOfTheFirstDayOfTheMonth + 1, currentYear: currentYear, currentMonth: currentMonth, chosenDate: $chosenDate, chosenYear: $chosenYear, chosenMonth: $chosenMonth, chosenDay: $chosenDay, chosenHour: $chosenHour, chosenMinute: $chosenMinute)
                    }
                }
                ForEach(1...wholeWeekCount, id: \.self) { weekIndex in
                    GridRow {
                        ForEach(1...7, id: \.self) { index in
                            DayWidget(weekIndex * 7 + index - weekdayOfTheFirstDayOfTheMonth, currentYear: currentYear, currentMonth: currentMonth, chosenDate: $chosenDate, chosenYear: $chosenYear, chosenMonth: $chosenMonth, chosenDay: $chosenDay, chosenHour: $chosenHour, chosenMinute: $chosenMinute)
                        }
                    }
                }
                if daysCountInLastWeek >= 1 {
                    GridRow {
                        ForEach(1...daysCountInLastWeek, id: \.self) { index in
                            DayWidget(wholeWeekCount * 7 + (7 - weekdayOfTheFirstDayOfTheMonth) + index, currentYear: currentYear, currentMonth: currentMonth, chosenDate: $chosenDate, chosenYear: $chosenYear, chosenMonth: $chosenMonth, chosenDay: $chosenDay, chosenHour: $chosenHour, chosenMinute: $chosenMinute)
                        }
                    }
                }
            }
            .padding(.all, 5)
        } label: {
            VStack(spacing: 0) {
                HStack{
                    Text("\(currentYear.description)年")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                    Text("\(currentMonth.description)月")
                        .font(.title2)
                    Spacer()
                    Button {
                        let date = Date(year: currentYear, month: currentMonth, day: 1).getLastMonthDate()
                        currentYear = date.year
                        currentMonth = date.month
                        weekdayOfTheFirstDayOfTheMonth = date.weekdayOfTheFirstDayOfTheMonth
                        daysInMonth = date.daysInMonth
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.plain)
                    Button {
                        let date = Date(year: currentYear, month: currentMonth, day: 1).getNextMonthDate()
                        currentYear = date.year
                        currentMonth = date.month
                        weekdayOfTheFirstDayOfTheMonth = date.weekdayOfTheFirstDayOfTheMonth
                        daysInMonth = date.daysInMonth
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.plain)
                }
                HStack {
                    TextField("", value: $chosenHour, format: .number)
                        .onSubmit {
                            if chosenHour > 23 {
                                chosenHour = 23
                            }
                            if chosenHour < 0 {
                                chosenHour = 0
                            }
                            chosenDate = Date(year: chosenYear, month: chosenMonth, day: chosenDay, hour: chosenHour, minute: chosenMinute)
                        }
                        .labelsHidden()
                    Stepper("") {
                        if chosenHour < 23 {
                            chosenHour += 1
                        } else {
                            chosenHour = 0
                        }
                        chosenDate = Date(year: chosenYear, month: chosenMonth, day: chosenDay, hour: chosenHour, minute: chosenMinute)
                    } onDecrement: {
                        if chosenHour > 0 {
                            chosenHour -= 1
                        } else {
                            chosenHour = 23
                        }
                        chosenDate = Date(year: chosenYear, month: chosenMonth, day: chosenDay, hour: chosenHour, minute: chosenMinute)
                    }
                    .labelsHidden()
                    .padding(.leading, -5)
                    Text("时")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                        .frame(width: 30, height: 0)
                    TextField("", value: $chosenMinute, format: .number)
                        .onSubmit {
                            if chosenMinute > 59 {
                                chosenMinute = 59
                            }
                            if chosenMinute < 0 {
                                chosenMinute = 0
                            }
                            chosenDate = Date(year: chosenYear, month: chosenMonth, day: chosenDay, hour: chosenHour, minute: chosenMinute)
                        }
                        .labelsHidden()
                    Stepper("") {
                        if chosenMinute < 59 {
                            chosenMinute += 1
                        } else {
                            chosenMinute = 0
                        }
                        chosenDate = Date(year: chosenYear, month: chosenMonth, day: chosenDay, hour: chosenHour, minute: chosenMinute)
                    } onDecrement: {
                        if chosenMinute > 0 {
                            chosenMinute -= 1
                        } else {
                            chosenMinute = 59
                        }
                        chosenDate = Date(year: chosenYear, month: chosenMonth, day: chosenDay, hour: chosenHour, minute: chosenMinute)
                    }
                    .labelsHidden()
                    .padding(.leading, -5)
                    Text("分")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 5)
            }
        }
    }
}

struct CalendarWidget_Previews: PreviewProvider {
    struct HelperView: View {
        @State private var date = Date()
        
        var body: some View {
            CalendarWidget($date)
                .frame(width: 250, height: 280)
                .padding()
        }
    }
    
    static var previews: some View {
        HelperView()
    }
}
