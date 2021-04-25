//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Misha Causur on 24.02.2021.
//

import UIKit

protocol PopToMainVC: class {
    func popToMAinVC() -> Void
}

protocol NewTitle: class {
    func newTitle(newTitle: String)
}

class HabitDetailsViewController: UIViewController {
    
    let habitTableView = UITableView(frame: .zero, style: .grouped)
  
    weak var delegate: Updated?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("SUCHKA")
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
    
    override func willMove(toParent parent: UIViewController?) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func setupView(){
        view.addSubview(habitTableView)
        habitTableView.translatesAutoresizingMaskIntoConstraints = false
        habitTableView.delegate = self
        habitTableView.dataSource = self
        habitTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        
        let constraints = [
            habitTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habitTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            habitTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            habitTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    let habitVC = HabitViewController()
    
    @objc func openHabit(){
        let habitViewController = HabitViewController()
        habitViewController.habit = habit
        habitViewController.closerDelegate = self
        habitViewController.newTitleDelegate = self
        self.delegate?.update()
        present(habitViewController, animated: true, completion: nil)
    }
    
//    @objc func openHabit() {
//
//        habitVC.navigationItem.title = "Править"
//        habitVC.view.backgroundColor = .white
////        habitVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(resaveHabit))
//        habitVC.nameTextField.text = habit.name
//        habitVC.nameTextField.textColor = habit.color
//        habitVC.nameTextField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//        habitVC.colorViewCircle.backgroundColor = habit.color
////        habitVC.navigationItem.title = "Править"
//        let i = habit.date
//        let formatter = DateFormatter()
//        formatter.dateFormat = "H:mm"
//        habitVC.timeChanger.text = formatter.string(from: i)
//        let navigationItems = UINavigationItem(title: "Править")
////        let saveButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(resaveHabit))
////        navigationItems.rightBarButtonItem = saveButton
////        let cancelButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(closeButton))
////        navigationItems.leftBarButtonItem = cancelButton
////        habitVC.navigationBar.setItems([navigationItems], animated: true)
//        let removerRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteAlert))
//        habitVC.deleteButton.alpha = 1
//        habitVC.deleteButton.addGestureRecognizer(removerRecognizer)
//        self.navigationController?.present(habitVC, animated: true, completion: nil)
//    }
    
    @objc func resaveHabit(){
        habit.name = habitVC.nameTextField.text!
        habit.color = habitVC.colorViewCircle.backgroundColor!
        habit.date = habitVC.timePicker.date
        storage.save()
        self.delegate?.update()
        title = habit.name
        dismiss(animated: true, completion: nil)
    }
    
    @objc func closeButton(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteAlert(){
        let alertController = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(habit.name) ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: {_ in
            print("Отмена")
        })
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive, handler: {_ in self.deleteHabit()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        habitVC.present(alertController, animated: true, completion: nil)
    }
    
    func deleteHabit(){
        for i in storage.habits {
            if i == habit {
                storage.habits = storage.habits.filter(){$0 != habit}
            }
        }
        self.delegate?.update()
        dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }
}

extension HabitDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = HabitsStore.shared.dates.count - 1
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = habitTableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        let count = HabitsStore.shared.dates.count - indexPath.item - 2
        cell.textLabel?.text = HabitsStore.shared.trackDateString(forIndex: indexPath.row)
        if HabitsStore.shared.habit(habit, isTrackedIn: HabitsStore.shared.dates[count]) {
            cell.accessoryType = .checkmark
            cell.tintColor = UIColor(named: "purple")
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Активность"
    }
}

extension HabitDetailsViewController: PopToMainVC {
    
    func popToMAinVC() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension HabitDetailsViewController: NewTitle {
    func newTitle(newTitle: String) {
        self.navigationItem.title = newTitle
    }
}
