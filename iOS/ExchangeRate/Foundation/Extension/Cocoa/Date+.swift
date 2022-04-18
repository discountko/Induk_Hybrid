//
//  Date+.swift
//  Base
//
//  Created by pineone on 2021/09/02.
//

import Foundation
import Then

extension TimeZone {
    static let korea = TimeZone(identifier: "Asia/Seoul")!
}

extension Locale {
    static let korea = Locale(identifier: "ko_KR")
}

extension Date {
    init?(string: String, format: String, locale: Locale = .current) {
        let dateFormatter = DateFormatter().then {
            $0.dateFormat = format
            $0.locale = locale
        }
        guard let date = dateFormatter.date(from: string) else {
            return nil
        }
        self.init(timeInterval: 0, since: date)
    }

    /// 입력된 포맷으로 Date 타입을 문자열로 변환합니다.
    ///
    /// - Parameter format: 포맷
    /// - Returns: 문자열
    ///
    /// ```
    /// let string = Date().string(withFormat: "yyyyMMdd")
    /// ```
    ///
    func string(withFormat format: String, locale: Locale = Locale.korea, timeZone: TimeZone = TimeZone.korea) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        return dateFormatter.string(from: self)
    }

    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date).year ?? 0
    }

    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date).month ?? 0
    }

    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date).day ?? 0
    }
    
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date).hour ?? 0
    }
    
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date).minute ?? 0
    }

    /// 자기 자신의 Date 시간값 초기화
    public var clearDate: Date {
        get {
            let calendar = NSCalendar.current
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            components.hour = 0
            components.minute = 0
            components.second = 0

            return calendar.date(from: components)!
        }
    }

    /// 입력된 Date를 비교하여 오늘, 1~5일전, "yyyy.MM.dd" 문자열로 변환합니다.
    ///
    /// - Parameter date: 비교 날짜
    /// - Returns: 문자열
    ///
    /// ```
    /// let string = Date().offset(withFormat: Date())
    /// ```
    ///
    func offset(from date: Date) -> String {
        let date = date.clearDate

        /// 2~5일전
        if days(from: date) > 1 && days(from: date) < 6 {
            return "\(days(from: date))일전"
        }
        /// 어제
        if days(from: date) == 1 {
            return "어제"
        }
        /// 오늘
        if days(from: date) == 0 {
            return "오늘"
        }
        /// 그외 날짜는 yyyy.MM.dd 포멧
        return date.string(withFormat: "yyyy.MM.dd")
    }

    func currentTimeStamp() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }

    /// 상대값지정
    ///
    /// - Parameters:
    ///   - year: 년
    ///   - month: 월
    ///   - day: 일
    ///   - hour: 시간
    ///   - minute: 분
    ///   - second: 초
    /// - Returns: Date
    func added(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .korea
        calendar.locale   = .korea

        var comp = DateComponents()
        comp.year = (year ?? 0) + calendar.component(.year, from: self)
        comp.month = (month ?? 0) + calendar.component(.month, from: self)
        comp.day = (day ?? 0) + calendar.component(.day, from: self)
        comp.hour = (hour ?? 0) + calendar.component(.hour, from: self)
        comp.minute = (minute ?? 0) + calendar.component(.minute, from: self)
        comp.second = (second ?? 0) + calendar.component(.second, from: self)

        return calendar.date(from: comp)!
    }

    func adding(_ value: Int, _ component: Calendar.Component, calendar: Calendar = .current) -> Date {
        var dateComponents = DateComponents()
        switch component {
        case .era:                  dateComponents.era = value
        case .year:                 dateComponents.year = value
        case .month:                dateComponents.month = value
        case .day:                  dateComponents.day = value
        case .hour:                 dateComponents.hour = value
        case .minute:               dateComponents.minute = value
        case .second:               dateComponents.second = value
        case .nanosecond:           dateComponents.nanosecond = value
        case .weekday:              dateComponents.weekday = value
        case .weekdayOrdinal:       dateComponents.weekdayOrdinal = value
        case .quarter:              dateComponents.quarter = value
        case .weekOfMonth:          dateComponents.weekOfMonth = value
        case .weekOfYear:           dateComponents.weekOfYear = value
        case .yearForWeekOfYear:    dateComponents.yearForWeekOfYear = value
        default: break
        }
        return calendar.date(byAdding: dateComponents, to: self)!
    }
}
