//
//  CalendarViewController.swift
//  Albums
//
//  Created by Сабитов Данил on 14.06.2022.
//

import UIKit
import FSCalendar
protocol CalendarViewControllerDelegate: AnyObject {
    func dateDidSelect(selectedDate: String)
}

class CalendarViewController: UIViewController {
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.delegate = self
        calendar.dataSource = self
        return calendar
    }()
    
    fileprivate var dateFormatter = DateFormatter()
    
    weak var delegate: CalendarViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setupConstraints()
    }
    
    private func addSubview() {
        view.addSubview(calendar)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateFormatter.dateFormat = "YYYY"
        let currentDate = Calendar.current
        let components = currentDate.dateComponents([.year], from: Date())
        
        guard let selectedDate = Int(dateFormatter.string(from: date)),
              let year = components.year else { return }
        
        let userAge = String(year - selectedDate)
        
        delegate?.dateDidSelect(selectedDate: userAge)
        dismiss(animated: true)
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: "1900-01-01") ?? Date()
        
    }

    func maximumDate(for calendar: FSCalendar) -> Date {
        return dateFormatter.date(from: "2004-01-01") ?? Date()
    }
}
