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
        return bar
    }()
    
    let wrapperView = UIView()
    
    var updatedDelegate: Updated?
    
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
        view.backgroundColor = UIColor(named: "orange")
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
    
    let timeChanger: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.text = "11:00"
        field.textColor = UIColor(named: "purple")
        return field
    }()
    
    let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        return picker
    }()
    
    @objc let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let toolBar = UIToolbar()
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(buttonDone))
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    var dateForHabit: Date = Date()
    
    @IBOutlet var CancelButton: UIButton!
    
    @IBOutlet var SaveButton: UIButton!
    
    @IBAction func saveData(_ sender: Any) {
        
        let nameText = nameTextField.text!
        let dateHabit = timePicker.date
        let colorHabit = colorViewCircle.backgroundColor!
        let newHabit = Habit(name: nameText, date: dateHabit, color: colorHabit)
        storage.habits.append(newHabit)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Создать"
        setButtons()
        view.addSubview(wrapperView)
        setView()
        let tapColorCircle = UITapGestureRecognizer(target: self, action: #selector(colorCircleTapped))
        colorViewCircle.addGestureRecognizer(tapColorCircle)
        timeChanger.inputView = timePicker
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    
    func deleteHabit(habit: Habit){
        for i in storage.habits {
            if i == habit {
                storage.habits = storage.habits.filter(){$0 != habit}
            }
        }
    }
    
    private func setButtons(){
        CancelButton?.setTitle("Отменить", for: .normal)
        CancelButton?.tintColor = UIColor(named: "purple")
        CancelButton?.addTarget(self, action: #selector(closeCreateVC), for: .touchUpInside)
        
        SaveButton?.setTitle("Сохранить", for: .normal)
        SaveButton?.tintColor = UIColor(named: "purple")
    }
    
    @objc  private func closeCreateVC(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func colorCircleTapped(){
        present(colorPicker, animated: true, completion: nil)
    }
    
    @objc private func buttonDone(){
        getDateFromPicker()
        view.endEditing(true)
    }
    
    private func getDateFromPicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        timeChanger.text = formatter.string(from: timePicker.date)
    }
    
   @objc func  saveHabit() {
    
    let newHabit = Habit(name: nameTextField.text!, date: timePicker.date, color: colorViewCircle.backgroundColor!)
    storage.habits.append(newHabit)
    updatedDelegate?.update()
    dismiss(animated: true, completion: nil)
   }
    
  
   
    
    
    
    private func setView(){
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        wrapperView.addSubview(nameLabel)
        wrapperView.addSubview(nameTextField)
        wrapperView.addSubview(colorLabel)
        wrapperView.addSubview(colorViewCircle)
        wrapperView.addSubview(timeLabel)
        wrapperView.addSubview(timeTextLabel)
        wrapperView.addSubview(timeChanger)
        wrapperView.addSubview(deleteButton)
        colorPicker.delegate = self
        toolBar.sizeToFit()
        toolBar.setItems([flexSpace, doneButton], animated: true)
        timeChanger.inputAccessoryView = toolBar
        
        
        let constraints = [
            wrapperView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            wrapperView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            wrapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            wrapperView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 22),
            nameLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7),
            
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
        
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)]
        
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        colorViewCircle.backgroundColor = viewController.selectedColor
    }
}


