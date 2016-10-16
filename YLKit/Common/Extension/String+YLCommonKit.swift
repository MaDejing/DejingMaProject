
extension String {
    var date: NSDate? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self) as NSDate?
    }
}

extension String {
    init(duration: Int) {
        if duration < 0 { self = "00:00" }
        else {
            let h = duration / 3600, m = duration / 60 % 60, s = duration % 60
            if h == 0 { self = String(format: "%02d:%02d", m, s) }
            else { self = String(format: "%02d:%02d:%02d", h, m, s) }
        }
    }
}
