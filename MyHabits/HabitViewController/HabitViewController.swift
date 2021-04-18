//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Миша Козырь on 22.02.2021.
//

import UIKit

class HabitViewController: UIViewController {
    
    let navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        let navigationItems = UINavigationItem(title: "Создать")
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveHabit))
        navigationItems.rightBarButtonItem = saveButton
        let cancelButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(closeCreateVC))
        navigationItems.leftBarButtonItem = cancelButton
        bar.tintColor = UIColor(named: "purple")
        bar.backgroundColor = .white
        bar.setItems([navigationItems], animated: false)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    public var habit: Habit? {
           didSet {
            nameTextField.text = habit?.name
            timeChanger.text = formatter.string(from: habit!.date)
            colorViewCircle.backgroundColor = habit?.color
           }
       }
    
    let wrapperView = UIView()
    
    let timeView = UIView()
    
    weak var delegate: Updated?
    
    weak var closerDelegate: PopToMainVC?
    
    weak var newTitleDelegate: NewTitle?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Название"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        field.textColor = .black
        field.font = UIFont.systemFont(ofSize: 18)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let colorViewCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 30/2
//        view.backgroundColor = UIColor(named: "orange")
        return view
    }()
    
    let colorPicker: UIColorPickerViewController = {
        let picker = UIColorPickerViewController()
        picker.selectedColor = UIColor(named: "orange")!
        return picker
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Время"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let timeTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Каждый день в"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    let timeChanger: UITextField = {
//        let field = UITextField()
//        field.translatesAutoresizingMaskIntoConstraints = false
//        field.text = "11:00"
//        field.textColor = UIColor(named: "purple")
//        return field
//    }()
    
    let timeChanger: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "11:00"
        label.textColor = UIColor(named: "purple")
        return label
    }()
    
    let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.backgroundColor = .white
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(deleteAlert), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let formatter = DateFormatter()
    
//    let toolBar = UIToolbar()
//
//    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(buttonDone))
//
//    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//
//    var dateForHabit: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Создать"
        view.backgroundColor = .white
        view.addSubview(wrapperView)
        setView()
        let tapColorCircle = UITapGestureRecognizer(target: self, action: #selector(colorCircleTapped))
        if habit == nil {
            colorViewCircle.backgroundColor = UIColor(named: "orange")
            timeChanger.text = "11:00"
            title = "Создать"
        } else {
            timeChanger.text = formatter.string(from: habit!.date)
            let navigationItems = UINavigationItem(title: "Править")
            let saveButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveHabit))
            navigationItems.rightBarButtonItem = saveButton
            let cancelButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(closeCreateVC))
            navigationItems.leftBarButtonItem = cancelButton
            navigationBar.setItems([navigationItems], animated: false)
            
        }
        colorViewCircle.addGestureRecognizer(tapColorCircle)
//        timeChanger.inputView = timePicker
//        timePicker.preferredDatePickerStyle = .wheels
//        timePicker.datePickerMode = .time
    }
  
    func deleteHabit(habit: Habit){
        for i in storage.habits {
            if i == habit {
                storage.habits = storage.habits.filter(){$0 != habit}
            }
            self.delegate?.update()
            self.closerDelegate?.popToMAinVC()
        }
    }
    
    @objc  private func closeCreateVC(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func colorCircleTapped(){
        present(colorPicker, animated: true, completion: nil)
    }
    
    @objc private func buttonDone(){
//        getDateFromPicker()
        view.endEditing(true)
    }
    
//    private func getDateFromPicker(){
//        let formatter = DateFormatter()
//        formatter.dateFormat = "H:mm"
//        timeChanger.text = formatter.string(from: timePicker.date)
//    }
    
    @objc func  saveHabit() {
        guard let name = nameTextField.text else { return }
        let date = timePicker.date
        guard let color = colorViewCircle.backgroundColor else { return }
        let newHabit = Habit(name: name, date: date, color: color)
        
        if habit != nil {
            habit?.name = name
            habit?.date = date
            habit?.color = color
            storage.save()
            self.newTitleDelegate?.newTitle(newTitle: name)
        } else {
            storage.habits.append(newHabit)
        }
        self.delegate?.update()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteAlert(){
        let alertController = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(habit!.name) ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: {_ in
            print("Отмена")
        })
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive, handler: {_ in self.deleteHabit()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteHabit(){
        for i in storage.habits {
            if i == habit {
                storage.habits = storage.habits.filter(){$0 != habit}
            }
        }
        dismiss(animated: true, completion: nil)
        self.delegate?.update()
        self.closerDelegate?.popToMAinVC()
    }
    
    @objc private func timeChanged() {
        timeChanger.text = formatter.string(from: timePicker.date)
    }
    
    private func setView(){
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        timeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        wrapperView.addSubview(nameLabel)
        wrapperView.addSubview(nameTextField)
        wrapperView.addSubview(colorLabel)
        wrapperView.addSubview(colorViewCircle)
        wrapperView.addSubview(timeLabel)
        wrapperView.addSubview(timeTextLabel)
        wrapperView.addSubview(timeChanger)
        wrapperView.addSubview(deleteButton)
        colorPicker.delegate = self
        wrapperView.addSubview(timeView)
        wrapperView.addSubview(timePicker)
        
        if habit == nil {
            timeChanger.text = formatter.string(from: timePicker.date)
        } else {
            timeChanger.text = formatter.string(from: habit!.date)
        }
        
        formatter.dateFormat = "HH:mm"
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
//        toolBar.sizeToFit()
//        toolBar.setItems([flexSpace, doneButton], animated: true)
//        timeChanger.inputAccessoryView = toolBar
        
        let constraints = [
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.widthAnchor.constraint(equalToConstant: 44),
            
            wrapperView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            wrapperView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            wrapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            wrapperView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 22),
            nameLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            
            colorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            
            colorViewCircle.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 7),
            colorViewCircle.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            colorViewCircle.widthAnchor.constraint(equalToConstant: 30),
            colorViewCircle.heightAnchor.constraint(equalToConstant: 30),
            
            timeLabel.topAnchor.constraint(equalTo: colorViewCircle.bottomAnchor, constant: 15),
            timeLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            
            timeTextLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            timeTextLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            
            timeChanger.topAnchor.constraint(equalTo: timeTextLabel.topAnchor),
            timeChanger.leadingAnchor.constraint(equalTo: timeTextLabel.trailingAnchor, constant: 3),
            
            timePicker.topAnchor.constraint(equalTo: timeTextLabel.bottomAnchor, constant: 15),
//            timePicker.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor),
        
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)]
        NSLayoutConstraint.activate(constraints)
        
        if habit != nil {
            deleteButton.alpha = 1
           
            
        }
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        colorViewCircle.backgroundColor = viewController.selectedColor
    }
}


