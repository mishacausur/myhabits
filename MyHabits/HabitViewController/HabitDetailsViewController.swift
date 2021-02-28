//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Misha Causur on 24.02.2021.
//

import UIKit

class HabitDetailsViewController: UIViewController {
    
    let habitTableView = UITableView(frame: .zero, style: .grouped)
  
    private let habit: Habit
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    init(habit: Habit) {
        self.habit = habit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        title = habit.name
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(openHabit))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "purple")!], for: .normal)
        view.backgroundColor = UIColor(named: "bitGray")
    }
    private func setupView(){
        view.addSubview(habitTableView)
        habitTableView.translatesAutoresizingMaskIntoConstraints = false
        habitTableView.delegate = self
        habitTableView.dataSource = self
        habitTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        
        let constrainrs = [
            habitTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habitTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            habitTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            habitTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
        
        NSLayoutConstraint.activate(constrainrs)
    }
    
    let habitVC = HabitViewController()
  
    @objc func openHabit() {
//        habitVC.viewDidLoad()
//        habitVC.navigationController?.isNavigationBarHidden = false
        habitVC.navigationItem.title = "Править"
        habitVC.view.backgroundColor = .white
        habitVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(resaveHabit))
        habitVC.nameTextField.text = habit.name
        habitVC.nameTextField.textColor = habit.color
        habitVC.nameTextField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        habitVC.colorViewCircle.backgroundColor = habit.color
        habitVC.navigationItem.title = "Править"
        let i = habit.date
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        habitVC.timeChanger.text = formatter.string(from: i)
        
        let navigationItems = UINavigationItem(title: "Править")
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(resaveHabit))
        navigationItems.rightBarButtonItem = saveButton
        let cancelButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(closeButton))
        habitVC.navigationItem.leftBarButtonItem = cancelButton
        habitVC.navigationBar.setItems([navigationItems], animated: true)
        let removerRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteHabit))
        habitVC.deleteButton.addGestureRecognizer(removerRecognizer)
        self.navigationController?.present(habitVC, animated: true, completion: nil)
    }
    @objc func resaveHabit(){
        habit.name = habitVC.nameTextField.text!
        habit.color = habitVC.colorViewCircle.backgroundColor!
        habit.date = habitVC.timePicker.date
        storage.save()
        dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func closeButton(){
        dismiss(animated: true, completion: nil)
    }
    
//    @objc func deleteH(habit: Habit){
//        deleteHabit(habit: habit)
//    }
    
  @objc func deleteHabit(){
        for i in storage.habits {
            if i == habit {
                storage.habits = storage.habits.filter(){$0 != habit}
            }
        }
    dismiss(animated: true, completion: nil)
    navigationController?.popToRootViewController(animated: true)
    }
}

extension HabitDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = habit.trackDates.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = habitTableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        let dateLabel = storage.dates
        let date = dateLabel[indexPath.section]
        print(dateLabel)
        let label = dateFormatter.string(from: date)
        cell.textLabel!.text = label
        cell.tintColor = UIColor.init(named: "purple")
        if storage.habit(habit, isTrackedIn: date) == false {
            cell.accessoryType = .none } else {
                cell.accessoryType = .checkmark
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Активность"
    }
    
}


