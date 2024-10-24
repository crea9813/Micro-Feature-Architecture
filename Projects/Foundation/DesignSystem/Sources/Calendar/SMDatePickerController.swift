//
//  SMDatePickerController.swift
//  DesignSystem
//
//  Created by Supermove on 4/22/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import UIKit
import Extensions

public class SMCalendarView: UIViewController {
    public var selectedDate: ((Date, String) -> Void)?
    public var selectedDates: ((Date, Date) -> Void)?
    
    private let isRangeSelection: Bool!
    private var selectableStartDate: Date!
    private var selectableEndDate: Date!
    private var disabledDates: [Date] = []
    
    private var isInitial: Bool = true
    private var availableBeginTime: Int = 0
    private let hourTagOffset: Int = 10
    private var hours: [Int] = [] {
        willSet(hours) {
            deselectAllHour()
            selectHour(with: availableBeginTime + hourTagOffset)
        }
    }
    
    private var startDate: Date?
    private var startTime: String?
    
    private var selectedStartDate: Date?
    private var selectedEndDate: Date?
    private var selectedStartDateHour: String?
    private var selectedEndDateHour: String?
    
    private var feedbackGenerator: UISelectionFeedbackGenerator?
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .sm(.background(.bg0))
    }
    private let contentView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    private let titleLabel = UILabel().then {
        $0.font = .spoqaFont(size: 16, weight: .bold)
        $0.textColor = .black
        $0.text = "가는 날 선택"
    }
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let hourView = UIView().then {
        $0.backgroundColor = .white
    }
    private let hourSeparator = UIView().then {
        $0.backgroundColor = .sm(.background(.bg10))
    }
    private let hourTitleLabel = UILabel().then {
        $0.font = .systemFont(size: 16, weight: .bold)
        $0.textColor = .black
        $0.text = "10시 이후 출발"
    }
    private let hourScrollView = UIScrollView().then {
        $0.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        $0.showsHorizontalScrollIndicator = false
    }
    private let hourStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 8
    }
    private let confirmButton = UIButton().then {
        $0.backgroundColor = .sm(.primary)
        $0.setTitle("적용하기", for: .normal)
        $0.titleLabel?.font = .spoqaFont(size: 16, weight: .bold)
        $0.layer.cornerRadius = 8
    }
    
    public init(selectableStartDate: Date,
         selectableEndDate: Date,
         disabledDates: [Date] = [],
         isRangeSelection: Bool = false,
         startDate: Date? = nil, startTime: String? = nil) {
        self.selectableStartDate = selectableStartDate
        self.selectableEndDate = selectableEndDate
        self.disabledDates = disabledDates
        self.isRangeSelection = isRangeSelection
        self.startDate = startDate
        self.startTime = startTime
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let startTime else { return }
    }
    
    @objc private func didSubmit() {
        if isRangeSelection {
            guard let selectedStartDate,
                  let selectedStartDateHour,
                  let selectedEndDate,
                  let selectedEndDateHour else { return }
            self.selectedDates?(selectedStartDate, selectedEndDate)
        } else {
            guard let selectedStartDate,
                  let selectedStartDateHour else { return }
            let date = Calendar.current.date(bySettingHour: Int(selectedStartDateHour)!, minute: 0, second: 0, of: selectedStartDate)!
            self.selectedDate?(date, selectedStartDateHour)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        setupGenerator()
    }
    
    private func setupViews() {
        self.view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(tap)
        
        self.view.addSubview(contentView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(collectionView)
        self.contentView.addSubview(hourView)
        
        self.hourView.addSubview(hourSeparator)
        self.hourView.addSubview(hourTitleLabel)
        self.hourView.addSubview(hourScrollView)
        self.hourScrollView.addSubview(hourStackView)
        self.hourView.addSubview(confirmButton)
        
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(80)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(250)
        }
        
        hourView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
        }
        
        hourSeparator.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        hourTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
        }
        
        hourScrollView.snp.makeConstraints {
            $0.top.equalTo(hourTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
        
        hourStackView.snp.makeConstraints {
            $0.height.edges.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(hourScrollView.snp.bottom).offset(40)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
        
        confirmButton.addTarget(self, action: #selector(didSubmit), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.allowsMultipleSelection = true
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        self.collectionView.register(SMCalendarWeekHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: SMCalendarWeekHeaderView.self))
        self.collectionView.register(SMCalendarCell.self, forCellWithReuseIdentifier: "SMCalendarCell")
    }
    
    private func deselectHour(with targetHour: Int) {
        guard let hourButton = self.hourStackView.viewWithTag(targetHour) as? UIButton else { return }
        
        hourButton.backgroundColor = .black.withAlphaComponent(0.05)
        hourButton.isSelected = false
    }
    
    private func deselectAllHour() {
        if self.hours.count == 0 { return }
        self.hours.forEach {
            self.deselectHour(with: $0 + hourTagOffset)
        }
    }
    
    private func selectHour(with targetHour: Int) {
        guard let hourButton = self.hourStackView.viewWithTag(targetHour) as? UIButton else { return }
        
        hourButton.backgroundColor = .sm(.text(.t20))
        hourButton.isSelected = true
        
        if self.selectedStartDate != nil && self.selectableEndDate == nil {
            self.selectedStartDateHour = "\(targetHour - self.hourTagOffset)"
        } else if self.selectedEndDate != nil {
            self.selectedEndDateHour = "\(targetHour - self.hourTagOffset)"
        } else {
            self.selectedStartDateHour = "\(targetHour - self.hourTagOffset)"
        }
        
        self.hourTitleLabel.text = "\(targetHour - self.hourTagOffset)시 이후 출발"
        let hourButtonWidth = 65
        let buttonSpacing = 8
        let offset = CGPoint(x: (hourButtonWidth + buttonSpacing) * (targetHour - self.hourTagOffset) - 24, y: 0)
        self.hourScrollView.setContentOffset(offset, animated: true)
    }
    
    @objc private func didSelectHour(sender: UIButton) {
        deselectAllHour()
        selectHour(with: sender.tag)
    }
    
    private func setupHours(with remainHours: Int, availableBeginTime: Int) {
        self.hourStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        var hours: [Int] = []
        
        for hour in 24 - remainHours..<24 {
            hours.append(hour)
            
            let isEnabled = hour >= availableBeginTime
            
            let hourButton = UIButton().then {
                $0.layer.cornerRadius = 21
                $0.backgroundColor = isEnabled ? .sm(.text(.t10)).withAlphaComponent(0.05) : .sm(.background(.bg10))
                $0.titleLabel?.font = .spoqaFont(size: 14, weight: .medium)
                $0.setTitleColor(.black, for: .normal)
                $0.setTitleColor(.white, for: .selected)
                $0.setTitleColor(.sm(.text(.t30)), for: .disabled)
                $0.setTitle("\(hour)시", for: .normal)
                $0.isEnabled = isEnabled
                $0.tag = hour + hourTagOffset
                $0.addTarget(self, action: #selector(didSelectHour), for: .touchUpInside)
            }
            
            hourButton.snp.makeConstraints {
                $0.width.equalTo(65)
                $0.height.equalTo(42)
            }
            
            self.hourStackView.addArrangedSubview(hourButton)
        }
        
        self.availableBeginTime = availableBeginTime
        self.hours = hours
    }
    
    private func didSelectItem(indexPath: IndexPath, isInitial: Bool = false) {
        let cell = collectionView.cellForItem(at: indexPath) as! SMCalendarCell
        if !cell.viewModel.isSelectable { return }
        if isBefore(dateA: cell.viewModel.date, dateB: selectableStartDate) { return }
        
        if isRangeSelection {
            if selectedStartDate == nil {
                selectedStartDate = cell.viewModel.date
            } else if selectedEndDate == nil {
                if isBefore(dateA: selectedStartDate!, dateB: cell.viewModel.date) {
                    selectedEndDate = cell.viewModel.date
                } else {
                    selectedStartDate = cell.viewModel.date
                }
            } else {
                selectedStartDate = cell.viewModel.date
                selectedEndDate = nil
            }
        } else {
            selectedStartDate = cell.viewModel.date
        }
        self.feedbackGenerator?.selectionChanged()
        
        self.setupHours(with: 24, availableBeginTime: 24 - self.getHoursTillMidnight(date: cell.viewModel.date))
        
        if isInitial, let startTime {
            let hour = Int(startTime)!
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
                self.selectHour(with: hour + 10)
            })
        }
        
        collectionView.reloadData()
    }
    
    private func setupGenerator() {
        self.feedbackGenerator = UISelectionFeedbackGenerator()
        self.feedbackGenerator?.prepare()
    }
}

extension SMCalendarView: UICollectionViewDataSource,
                          UICollectionViewDelegate,
                          UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        let difference = Calendar.current.dateComponents([.month], from: selectableStartDate, to: selectableEndDate)
        return difference.month! + 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let firstDateForSection = getFirstDateForSection(section: section)
        let blankItems = getWeekday(date: firstDateForSection) - 1
        let daysInMonth = getNumberOfDaysInMonth(date: firstDateForSection)
        return blankItems + daysInMonth
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SMCalendarCell", for: indexPath) as! SMCalendarCell
        
        let blankItems = getWeekday(date: getFirstDateForSection(section: indexPath.section)) - 1
        if indexPath.item < blankItems {
            cell.bind(with: SMCalendarItemViewModel())
        } else {
            let dayOfMonth = indexPath.item - blankItems + 1
            let date = getDate(dayOfMonth: dayOfMonth, section: indexPath.section)
            let viewModel = SMCalendarItemViewModel(with: date)
            var isSelectable: Bool = selectableStartDate.dateCompare(fromDate: date) && date.dateCompare(fromDate: selectableEndDate)
            
            disabledDates.forEach {
                if areSameDay(dateA: date, dateB: $0) {
                    isSelectable = false
                }
            }
            
            viewModel.isSelectable = isSelectable
            
            if selectedStartDate != nil && selectedEndDate != nil && isBefore(dateA: selectedStartDate!, dateB: date) && isBefore(dateA: date, dateB: selectedEndDate!) {
                if dayOfMonth == 1 {
                    viewModel.selectItem(.left)
                } else if dayOfMonth == getNumberOfDaysInMonth(date: date) {
                    viewModel.selectItem(.middle)
                } else {
                    viewModel.selectItem(.middle)
                }
            } else if selectedStartDate != nil && areSameDay(dateA: date, dateB: selectedStartDate!) {
                viewModel.selectItem(.full)
                if selectedEndDate != nil {
                    viewModel.selectItem(.left)
                }
            } else if selectedEndDate != nil && areSameDay(dateA: date, dateB: selectedEndDate!) {
                viewModel.selectItem(.right)
            }
            
            if areSameDay(dateA: self.startDate ?? Date(), dateB: date) && isInitial {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
                    self.didSelectItem(indexPath: indexPath, isInitial: true)
                    self.isInitial = false
                })
            }
            
            cell.bind(with: viewModel)
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 76)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width - 28) / 7
        return CGSize(width: width, height: width)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: SMCalendarWeekHeaderView.self), for: indexPath) as? SMCalendarWeekHeaderView else {
            return SMCalendarWeekHeaderView()
        }
        let firstDateForSection = getFirstDateForSection(section: indexPath.section)
        let month = getMonthLabel(date: firstDateForSection)
        header.configure(month: month)
        return header
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem(indexPath: indexPath)
    }
}

extension SMCalendarView {
    
    func getHoursTillMidnight(date: Date) -> Int {
        let now = Calendar.current.dateComponents(in: .current, from: Calendar.current.isDateInToday(date) ? Date() : date)
        return 24 - (now.hour ?? 0)
    }
    
    func getFirstDate() -> Date {
        var components = Calendar.current.dateComponents([.month, .year], from: selectableStartDate)
        components.day = 1
        return Calendar.current.date(from: components)!
    }
    
    func getFirstDateForSection(section: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: section, to: getFirstDate())!
    }
    
    func getMonthLabel(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        return dateFormatter.string(from: date)
    }
    
    func getWeekdayLabel(weekday: Int) -> String {
        var components = DateComponents()
        components.calendar = Calendar.current
        components.weekday = weekday
        let date = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: Calendar.MatchingPolicy.strict)
        if date == nil {
            return "E"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEE"
        return dateFormatter.string(from: date!)
    }
    
    func getWeekday(date: Date) -> Int {
        return Calendar.current.dateComponents([.weekday], from: date).weekday!
    }
    
    func getNumberOfDaysInMonth(date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)!.count
    }
    
    func getDate(dayOfMonth: Int, section: Int) -> Date {
        var components = Calendar.current.dateComponents([.month, .year], from: getFirstDateForSection(section: section))
        components.day = dayOfMonth
        return Calendar.current.date(from: components)!
    }
    
    func areSameDay(dateA: Date, dateB: Date) -> Bool {
        return Calendar.current.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedSame
    }
    
    func isBefore(dateA: Date, dateB: Date) -> Bool {
        return Calendar.current.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedAscending
    }
    
}

final class SMCalendarWeekHeaderView: UICollectionReusableView {
    private let monthLabel = UILabel().then {
        $0.font = .spoqaFont(size: 18, weight: .medium)
        $0.textColor = .black
    }
    private let weekStackView = UIStackView().then {
        $0.distribution = .fillEqually
    }
    
    public func configure(month: String) {
        self.monthLabel.text = month
    }
    
    private func setupWeeks() {
        let dayOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
        
        dayOfWeek.forEach { day in
            let label = UILabel().then {
                $0.text = day
                $0.textAlignment = .center
                $0.font = .systemFont(size: 14, weight: .medium)
                $0.textColor = .sm(.text(.t20)).withAlphaComponent(0.6)
            }
            self.weekStackView.addArrangedSubview(label)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(monthLabel)
        self.addSubview(weekStackView)
        
        monthLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
        }
        
        weekStackView.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.setupWeeks()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

public enum SelectionRangePosition: Int {
    /// Selection position
    case left = 1, middle, right, full, none
}

class SMCalendarItemViewModel {
    var isSelectable: Bool
    var isSelected: Bool
    var selectedPosition: SelectionRangePosition
    let day: String
    let date: Date
    
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "d"
    }
    
    init() {
        self.isSelectable = false
        self.isSelected = false
        self.selectedPosition = .none
        self.day = String()
        self.date = Date()
    }
    
    init(with date: Date) {
        //        self.isSelectable = startDate.dateCompare(fromDate: date) && date.dateCompare(fromDate: endDate)
        self.isSelectable = true
        self.isSelected = false
        self.selectedPosition = .none
        self.day = dateFormatter.string(from: date)
        self.date = date
    }
    
    public func selectItem(_ selectedPosition: SelectionRangePosition) {
        self.isSelected = true
        self.selectedPosition = selectedPosition
    }
    
    public func deselectItem() {
        self.isSelected = false
        self.selectedPosition = .none
    }
}

final class SMCalendarCell: UICollectionViewCell {
    public var viewModel: SMCalendarItemViewModel!
    
    public let dayLabel = UILabel().then {
        $0.font = .systemFont(size: 16, weight: .medium)
        $0.textColor = UIColor(hex: "333333")
        $0.textAlignment = .center
    }
    
    public let selectedView = UIView().then {
        $0.backgroundColor = UIColor(hex: "333333")
        $0.layer.cornerRadius = 26
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        $0.isHidden = true
    }
    
    public func bind(with viewModel: SMCalendarItemViewModel) {
        self.viewModel = viewModel
        
        self.selectedView.isHidden = !viewModel.isSelected
        self.dayLabel.textColor = viewModel.isSelected ? .white : UIColor(hex: "333333")
        self.dayLabel.textColor = viewModel.isSelectable ? self.dayLabel.textColor : UIColor(hex: "333333").withAlphaComponent(0.32)
        
        switch viewModel.selectedPosition {
        case .left:
            self.selectedView.layer.cornerRadius = 26
            self.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        case .middle:
            self.selectedView.layer.cornerRadius = 0
            self.selectedView.layer.maskedCorners = []
        case .right:
            self.selectedView.layer.cornerRadius = 26
            self.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        case .full:
            self.selectedView.layer.cornerRadius = 26
            self.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, . layerMinXMinYCorner]
        default: break
        }
        
        self.dayLabel.text = viewModel.day
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(selectedView)
        self.addSubview(dayLabel)
        dayLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        selectedView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
