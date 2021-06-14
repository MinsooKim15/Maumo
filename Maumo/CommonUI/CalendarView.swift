
//
//  Calendar.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/05.
//

import SwiftUI
struct CalendarMainView: View {
    @ObservedObject var modelView : MaumJournalModelView
    private let calendar: Calendar
    private let monthFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let fullFormatter: DateFormatter
    private let yearFormatter : DateFormatter
    public var clickClosure : (Date)->Void
    @State private var selectedDate = Self.now
    private static var now = Date() // Cache now
    let generator = UINotificationFeedbackGenerator()
    init(calendar: Calendar, modelView : MaumJournalModelView, clickClosure:@escaping (Date)->Void) {
        self.calendar = calendar
        self.yearFormatter = DateFormatter(dateFormat: "yyyy", calendar: calendar)
        self.monthFormatter = DateFormatter(dateFormat: "MM", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEEEE", calendar: calendar)
        self.fullFormatter = DateFormatter(dateFormat: "MMMM dd, yyyy", calendar: calendar)
        self.modelView = modelView
        self.clickClosure = clickClosure
    }
    private func dateTapped(date:Date)->Void{
        if !self.modelView.hasJournalItem(of: date){
            self.clickClosure(date)
        }else{
            self.generator.notificationOccurred(.error)
        }
    }
    private func changeToNextMonth()->Void{
        withAnimation {
            guard let newDate = calendar.date(
                byAdding: .month,
                value: 1,
                to: selectedDate
            ) else {
                return
            }
            selectedDate = newDate
        }
    }
    private func changeToPreviousMonth()->Void{
        withAnimation {
            guard let newDate = calendar.date(
                byAdding: .month,
                value: -1,
                to: selectedDate
            ) else {
                return
            }

            selectedDate = newDate
        }
    }
    private let spacerHeightForCollectionItem : CGFloat = 20.0

    var body: some View {
        VStack {
            CalendarView(
                calendar: calendar,
                date: $selectedDate,
                content: { date in
                    Button(action: { self.dateTapped(date: date) }) {
                        ZStack{
                            if self.modelView.hasJournalItem(of: date){
                                Circle().frame(width:10, height:10).foregroundColor(self.modelView.getJournalItemColor(of: date))
//                                    Text(self.collection.getCalendarData(targetDate: date)!.title)
                            }
                            Text(dayFormatter.string(from: date))
                                .foregroundColor(.black)
                        }.frame(height:self.spacerHeightForCollectionItem)
                    }
                },
                trailing: { date in
                    Text(dayFormatter.string(from: date))
                        .foregroundColor(.secondary)
                },
                header: { date in
                    Text(weekDayFormatter.string(from: date))
                },
                title: { date in
                    HStack {
                        Text(yearFormatter.string(from:date)+"년 "+monthFormatter.string(from: date)+"월")
                            .font(.headline)
                            .padding()
                        Spacer()
                        Button {
                            self.changeToPreviousMonth()
                        } label: {
                            Label(
                                title: { Text("Previous") },
                                icon: { Image(systemName: "chevron.left").foregroundColor(.salmon) }
                            )
                            .labelStyle(IconOnlyLabelStyle())
                            .padding(.horizontal)
                            .frame(maxHeight: .infinity)
                        }
                        Button {
                            self.changeToNextMonth()
                        } label: {
                            Label(
                                title: { Text("Next") },
                                icon: { Image(systemName: "chevron.right").foregroundColor(.salmon) }
                            )
                            .labelStyle(IconOnlyLabelStyle())
                            .padding(.horizontal)
                            .frame(maxHeight: .infinity)
                        }
                    }
                    .padding(.bottom, 6)
                }
            )
            .equatable()
        }
        .padding()
    }
}

// MARK: - Component

public struct CalendarView<Day: View, Header: View, Title: View, Trailing: View>: View {
    // Injected dependencies
    private var calendar: Calendar
    @Binding private var date: Date
    private let content: (Date) -> Day
    private let trailing: (Date) -> Trailing
    private let header: (Date) -> Header
    private let title: (Date) -> Title

    // Constants
    private let daysInWeek = 7

    public init(
        calendar: Calendar,
        date: Binding<Date>,
        @ViewBuilder content: @escaping (Date) -> Day,
        @ViewBuilder trailing: @escaping (Date) -> Trailing,
        @ViewBuilder header: @escaping (Date) -> Header,
        @ViewBuilder title: @escaping (Date) -> Title
    ) {
        self.calendar = calendar
        self._date = date
        self.content = content
        self.trailing = trailing
        self.header = header
        self.title = title
    }

    public var body: some View {
        let month = date.startOfMonth(using: calendar)
        let days = makeDays()

        return LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
            Section(header: title(month)) {
                ForEach(days.prefix(daysInWeek), id: \.self, content: header)
                ForEach(days, id: \.self) { date in
                    if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                        content(date)
                    } else {
                        trailing(date)
                    }
                }
            }
        }
    }
}

// MARK: - Conformances

extension CalendarView: Equatable {
    public static func == (lhs: CalendarView<Day, Header, Title, Trailing>, rhs: CalendarView<Day, Header, Title, Trailing>) -> Bool {
        lhs.calendar == rhs.calendar && lhs.date == rhs.date
    }
}

// MARK: - Helpers

private extension CalendarView {
    func makeDays() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }

        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        return calendar.generateDays(for: dateInterval)
    }
}

private extension Calendar {
    func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]

        enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date = date else { return }

            guard date < dateInterval.end else {
                stop = true
                return
            }

            dates.append(date)
        }

        return dates
    }

    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
            matching: dateComponents([.hour, .minute, .second], from: dateInterval.start)
        )
    }
}

private extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
}

private extension DateFormatter {
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
    }
}

// MARK: - Previews

#if DEBUG
//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ContentView(calendar: Calendar(identifier: .gregorian))
//            ContentView(calendar: Calendar(identifier: .islamicUmmAlQura))
//            ContentView(calendar: Calendar(identifier: .hebrew))
//            ContentView(calendar: Calendar(identifier: .indian))
//        }
//    }
//}
#endif
