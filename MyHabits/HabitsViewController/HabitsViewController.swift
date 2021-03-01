//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Миша Козырь on 19.02.2021.
//

import UIKit

protocol Updated: class {
    func update()
}

final class HabitsViewController: UIViewController {
    
    @IBAction func addButton(_ sender: Any) {
        let habitViewController = HabitViewController()
        habitViewController.delegate = self
        present(habitViewController, animated: true, completion: nil)

    }
    private lazy var habitsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: "CellID")
        collection.register(ProgressCollectionReusableView.self, forCellWithReuseIdentifier: "Progress")
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        title = "Сегодня"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    
   
    override func viewWillAppear(_ animated: Bool) {
        habitsCollection.reloadData()
    }
   
    private func setupScreen(){
        view.addSubview(habitsCollection)
        setConsraits()
    }

    private func setConsraits(){
        
        habitsCollection.backgroundColor = UIColor(named: "bitGray")
        
        let constraits = [
            habitsCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habitsCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            habitsCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            habitsCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraits)
    }
    
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let progressCell: ProgressCollectionReusableView = habitsCollection.dequeueReusableCell(withReuseIdentifier: "Progress", for: indexPath) as! ProgressCollectionReusableView
            progressCell.backgroundColor = .white
            progressCell.layer.cornerRadius = 4
            progressCell.clipsToBounds = true
            progressCell.progressIndicator.setProgress(storage.todayProgress, animated: true)
            progressCell.percentLabel.text = String(Int(storage.todayProgress*100)) + "%"
            return progressCell
        } else {
            let cell: HabitCollectionViewCell = habitsCollection.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! HabitCollectionViewCell
            cell.layer.cornerRadius = 8
            cell.clipsToBounds = true
            cell.nameHabit.numberOfLines = 2
            cell.nameHabit.textColor = cell.circleView.backgroundColor
            if storage.habits[indexPath.item].isAlreadyTakenToday == false {
                cell.whiteView.alpha = 1 } else { cell.whiteView.alpha = 0 }
            cell.delegate = self
            return cell
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) { return 1 } else {
            let habitsCount = storage.habits.count
            return habitsCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (indexPath.section == 0) { return CGSize(width: habitsCollection.frame.width - 16 * 2, height: 60) } else {
            return CGSize(width: habitsCollection.frame.width - 16 * 2, height: 130)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if (section == 0) { return UIEdgeInsets(top: 22, left: 16, bottom: 6, right: 16)} else {
            return UIEdgeInsets(top: 12, left: 16, bottom: .zero, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let habitCell = cell as? HabitCollectionViewCell else { return }
        habitCell.habit = storage.habits[indexPath.item]
        habitCell.nameHabit.textColor = habitCell.circleView.backgroundColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let habit = storage.habits[indexPath.item]
        let habitDetailsViewController = HabitDetailsViewController(habit: habit)
        navigationController?.pushViewController(habitDetailsViewController, animated: true)
        habitsCollection.reloadData()
    }
}

extension HabitsViewController: Updated {
    func update() {
        habitsCollection.reloadData()
    }
}
