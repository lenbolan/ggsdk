import Foundation

let CreateDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

extension Date {
    
    func timeAgoSinceNow(numericDates: Bool = true) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = (now as NSDate).earlierDate(self)
        let latest = (earliest == now) ? self : now
        let components: DateComponents = (calendar as NSCalendar)
            .components([NSCalendar.Unit.minute,
                         NSCalendar.Unit.hour,
                         NSCalendar.Unit.day,
                         NSCalendar.Unit.weekOfYear,
                         NSCalendar.Unit.month,
                         NSCalendar.Unit.year,
                         NSCalendar.Unit.second],
                        from: earliest,
                        to: latest,
                        options: NSCalendar.Options())
        
        guard let year = components.year,
              let month = components.month,
              let weekOfYear = components.weekOfYear,
              let day = components.day,
              let hour = components.hour,
              let minute = components.minute,
              let second = components.second
              else {
            return "刚刚"
        }
        
        if year >= 1 {
            return year >= 2 ? "\(year)年前" : numericDates ? "1年前" : "去年"
        } else if month >= 1 {
            return month >= 2 ? "\(month)个月前" : numericDates ? "1个月前" : "上月"
        } else if weekOfYear >= 1 {
            return weekOfYear >= 2 ? "\(weekOfYear)周前" : numericDates ? "1周前" : "上周"
        } else if day >= 1 {
            return day >= 2 ? "\(day)天前" : numericDates ? "1天前" : "昨天"
        } else if hour >= 1 {
            return hour >= 2 ? "\(hour)小时前" : numericDates ? "1小时前" : "一小时前"
        } else if minute >= 1 {
            return minute >= 2 ? "\(minute)分钟前" : numericDates ? "1分钟前" : "一分钟前"
        } else {
            return second >= 3 ? "\(second)秒前" : "刚刚"
        }
    }
    
    //MARK: - 获取日期各种值
    //MARK: 年
    func year() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        return com.year!
    }
    //MARK: 月
    func month() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        return com.month!
        
    }
    //MARK: 日
    func day() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        return com.day!

    }
    //MARK: 星期几
    func weekDay()->Int{
        let interval = Int(self.timeIntervalSince1970)
        let days = Int(interval/86400) // 24*60*60
        let weekday = ((days + 4)%7+7)%7
        return weekday == 0 ? 7 : weekday
    }
    //MARK: 当月天数
    func countOfDaysInMonth() ->Int {
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let range = (calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: self)
        return (range?.length)!

    }
    //MARK: 当月第一天是星期几
    func firstWeekDay() ->Int {
        //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let firstWeekDay = (calendar as NSCalendar?)?.ordinality(of: NSCalendar.Unit.weekday, in: NSCalendar.Unit.weekOfMonth, for: self)
        return firstWeekDay! - 1
        
    }
    //MARK: - 日期的一些比较
    //是否是今天
    func isToday()->Bool {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        let comNow = calendar.dateComponents([.year,.month,.day], from: Date())
        return com.year == comNow.year && com.month == comNow.month && com.day == comNow.day
    }
    //是否是这个月
    func isThisMonth()->Bool {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        let comNow = calendar.dateComponents([.year,.month,.day], from: Date())
        return com.year == comNow.year && com.month == comNow.month
    }
    
    
    //MARK: - 当前时间相关
    //MARK: 今年
    static func currentYear() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: Date())
        return com.year!
    }
    //MARK: 今月
    static func currentMonth() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: Date())
        return com.month!

    }
    //MARK: 今日
    static func currentDay() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: Date())
        return com.day!

    }
    //MARK: 今天星期几
    static func currentWeekDay()->Int{
        let interval = Int(Date().timeIntervalSince1970)
        let days = Int(interval/86400) // 24*60*60
        let weekday = ((days + 4)%7+7)%7
        return weekday == 0 ? 7 : weekday
    }
    //MARK: 本月天数
    static func countOfDaysInCurrentMonth() ->Int {
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let range = (calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: Date())
        return (range?.length)!

    }
    //MARK: 当月第一天是星期几
    static func firstWeekDayInCurrentMonth() ->Int {
        //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let firstWeekDay = (calendar as NSCalendar?)?.ordinality(of: NSCalendar.Unit.weekday, in: NSCalendar.Unit.weekOfMonth, for: Date())
        return firstWeekDay! - 1

    }
    //MARK: - 获取指定日期各种值
    //根据年月得到某月天数
    static func getCountOfDaysInMonth(year:Int,month:Int) ->Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date
            = dateFormatter.date(from: String(year)+"-"+String(month))
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let range = (calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: date!)
        return (range?.length)!
    }
    //MARK: 根据年月得到某月第一天是周几
    static func getfirstWeekDayInMonth(year:Int,month:Int) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date
            = dateFormatter.date(from: String(year)+"-"+String(month))
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let comps = (calendar as NSCalendar?)?.components(NSCalendar.Unit.weekday, from: date!)
        let week = comps?.weekday
        return week! - 1
    }

    //MARK: 获取指定年月的date
    static func getMonthDate(year:Int,month:Int) ->Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date
            = dateFormatter.date(from: String(year)+"-"+String(month))
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        var com = calendar.dateComponents([.year,.month,.day], from: date!)
        com.month = month
        com.day = 1
        return calendar.date(from: com)!
    }
    //MARK: 比较时间先后
    static func compareOneDay(oneDay:Date, withAnotherDay anotherDay:Date) -> Int {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let oneDayStr:String = dateFormatter.string(from: oneDay)
        let anotherDayStr:String = dateFormatter.string(from: anotherDay)
        let dateA = dateFormatter.date(from: oneDayStr)
        let dateB = dateFormatter.date(from: anotherDayStr)
        let result:ComparisonResult = (dateA?.compare(dateB!))!
        //Date1  is in the future
        if(result == ComparisonResult.orderedDescending ) {
            return 1

        }
        //Date1 is in the past
        else if(result == ComparisonResult.orderedAscending) {
            return 2

        }
        //Both dates are the same
        else {
            return 0
        }
    }

    //MARK: 时间与时间戳之间的转化
    //将时间转换为时间戳
    static func stringToTimeStamp(_ stringTime:String)->String {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        dfmatter.locale = Locale.current

        let date = dfmatter.date(from: stringTime)

        let dateStamp:TimeInterval = date!.timeIntervalSince1970

        let dateSt:Int = Int(dateStamp)

        return String(dateSt)
    }
    //将时间戳转换为年月日
    static func timeStampToString(_ timeStamp:String, useCN:Bool = true, strLink: String = "")->String {
        let string = NSString(string: timeStamp)
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        if useCN {
            dfmatter.dateFormat="yyyy年MM月dd日"
        } else {
            dfmatter.dateFormat="yyyy\(strLink)MM\(strLink)dd"
        }
        let date = Date(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date)
    }
    //将时间戳转换为具体时间
    static func timeStampToStringDetail(_ timeStamp:String)->String {
        let string = NSString(string: timeStamp)
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy年MM月dd日HH:mm:ss"
        let date = Date(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date)
    }
    //将时间戳转换为时分秒
    static func timeStampToHHMMSS(_ timeStamp:String)->String {
        let string = NSString(string: timeStamp)
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="HH:mm:ss"
        let date = Date(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date)
    }
    //将当前时间转换为指定格式
    static func dateToString(formatStr: String = "yyyy-MM-dd_HH:mm:ss") -> String {
        return dateToString(date: Date(), formatStr: formatStr)
    }
    //将时间转换为指定格式
    static func dateToString(date: Date = Date(), formatStr: String = "yyyy-MM-dd_HH:mm:ss") -> String {
        // create a date formatter
        let dateFormatter = DateFormatter()
        // setup formate string for the date formatter
        dateFormatter.dateFormat = formatStr
        // format the current date and time by the date formatter
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    //将时间戳转换为日期
    static func timeStampToDate(_ timeStamp:Int) -> Date {
        let timeSta:TimeInterval = Double(timeStamp)
        let date = Date(timeIntervalSince1970: timeSta)
        return date
    }
    //将时间戳转换为日期
    static func timeStampToDate(_ timeStamp:String) -> Date {
        let string = NSString(string: timeStamp)
        let timeSta:TimeInterval = string.doubleValue
        let date = Date(timeIntervalSince1970: timeSta)
        return date
    }
    /// 日期字符串转化为Date类型
    ///
    /// - Parameters:
    ///   - string: 日期字符串
    ///   - dateFormat: 格式化样式，默认为“yyyy-MM-dd HH:mm:ss”
    /// - Returns: Date类型
    static func stringConvertDate(string:String, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: string)
        return date!
    }
    //获取系统的当前时间戳
    static func getStamp()->Int{
        //获取当前时间戳
        let date = Date()
        let timeInterval:Int = Int(date.timeIntervalSince1970)
        return timeInterval
    }
    //月份数字转汉字
    static func numberToChina(monthNum:Int) -> String {
        let ChinaArray = ["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"]
        let ChinaStr:String = ChinaArray[monthNum - 1]
        return ChinaStr

    }
    //MARK: 数字前补0
    static func add0BeforeNumber(_ number:Int) -> String {
        if number >= 10 {
            return String(number)
        }else{
            return "0" + String(number)
        }
    }
    
}

// MARK: - Week
extension Date {
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next,
                   weekday,
                   considerToday: considerToday)
    }
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
                   weekday,
                   considerToday: considerToday)
    }
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        let dayName = weekDay.rawValue
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        let calendar = Calendar(identifier: .gregorian)
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        return date!
    }
}

// MARK: - Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    enum SearchDirection {
        case next
        case previous
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
}
