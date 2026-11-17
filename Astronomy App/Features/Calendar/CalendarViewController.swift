//
//  CalendarViewController.swift
//  Astronomy App
//
//  Created by Ana Soares on 16/11/26.
//

import Foundation
import UIKit

final class CalendarViewController: UIViewController {
    
    private let calendarView = UICalendarView()
    var repository: ArticleRepository!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Calendar"
        
        setupCalendar() 
        
    }
    
    private func setupCalendar(){
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            calendarView.leadingAnchor.constraint(equalTo:safeArea.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
         
        let startComponents = DateComponents(year: 2026, month: 11, day: 1)
        let start = Calendar.current.date(from: startComponents)!
        
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.availableDateRange = DateInterval(start: start, end: Date())
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
    }
    
}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {

    func dateSelection(_ selection: UICalendarSelectionSingleDate,
                       didSelectDate dateComponents: DateComponents?) {
        
        guard let dateComponents,
              let seed = DailySeed.seed(for: dateComponents) else { return }
        
        let detail = ArticleViewController()
        detail.repository = repository
        detail.seed = seed
        
        navigationController?.pushViewController(detail, animated: true)
        
        print("Escolheu:", dateComponents)
        
    }
}
