//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Misha Causur on 22.02.2021.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    var delegate: Updated?
    
    var habit: Habit? {
        didSet {
            nameHabit.text = habit?.name
            circleView.backgroundColor = habit?.color
            bottomText.text = "Подряд: " + String(habit?.trackDates.count ?? 0)
            timeLabel.text = "Каждый день в " + dateFormatter.string(from: habit!.date)
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    let nameHabit: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let date = Date()
        let label = UILabel()
        label.text = "Каждый день в"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 36/2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(systemName: "checkmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        //        button.setImage(UIImage(named: "checkmark"), for: .normal)
        return button
    }()
    
    let whiteView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 32/2
        view.backgroundColor = .white
        view.alpha = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    override init(frame: CGRect){
        super.init(frame: frame)
        setupHabitCell()
        nameHabit.textColor = circleView.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let checkRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkHabit))
        whiteView.addGestureRecognizer(checkRecognizer)
    }
    
    @objc func checkHabit() {
        storage.track(habit!)
        let animatorCheckButton = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            self.whiteView.alpha = 0
        }
        animatorCheckButton.startAnimation()
        self.delegate?.update()
        
    }
    
    private func setupHabitCell(){
        contentView.addSubview(nameHabit)
        contentView.addSubview(timeLabel)
        contentView.addSubview(circleView)
        contentView.addSubview(bottomText)
        circleView.addSubview(checkButton)
        circleView.addSubview(whiteView)
        contentView.backgroundColor = .white
    
        let width = CGFloat(contentView.frame.width/3 * 2)
        let constraints = [
            
            
            nameHabit.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameHabit.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameHabit.widthAnchor.constraint(equalToConstant: width),
            timeLabel.topAnchor.constraint(equalTo: nameHabit.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            circleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 36),
            circleView.heightAnchor.constraint(equalToConstant: 36),
            
            checkButton.widthAnchor.constraint(equalToConstant: 36),
            checkButton.heightAnchor.constraint(equalToConstant: 36),
            checkButton.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            checkButton.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            
            whiteView.widthAnchor.constraint(equalToConstant: 32),
            whiteView.heightAnchor.constraint(equalToConstant: 32),
            whiteView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            whiteView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            
            bottomText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            bottomText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
