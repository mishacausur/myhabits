//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Миша Козырь on 19.02.2021.
//

import UIKit

class InfoViewController: UIViewController {

    let infoScrollView = UIScrollView()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычка за 21 день"
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let infoText: UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        text.text = textForInfoText
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 0
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Информация"
        view.addSubview(infoScrollView)
        setupView()
    }

    private func setupView(){
        infoScrollView.translatesAutoresizingMaskIntoConstraints = false
        infoScrollView.addSubview(infoLabel)
        infoScrollView.addSubview(infoText)
        
        infoScrollView.clipsToBounds = true
        
        let width = view.frame.width - 16 * 2
        
        let constraints = [
            infoScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            infoScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            infoScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            infoScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: infoScrollView.topAnchor, constant: 22),
            infoLabel.leadingAnchor.constraint(equalTo: infoScrollView.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: infoScrollView.trailingAnchor, constant: -16),
            
            infoText.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 16),
            infoText.leadingAnchor.constraint(equalTo: infoScrollView.leadingAnchor, constant: 16),
            infoText.trailingAnchor.constraint(equalTo: infoScrollView.trailingAnchor, constant: -16),
            infoText.bottomAnchor.constraint(equalTo: infoScrollView.bottomAnchor, constant: -16),
            infoText.widthAnchor.constraint(equalToConstant: width)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}

let textForInfoText = """
Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:

1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага.

2. Выдержать 2 дня в прежнем состоянии самоконтроля.

3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче, с чем еще предстоит серьезно бороться.

4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.

5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.

6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.

Источник: psychbook.ru
"""
