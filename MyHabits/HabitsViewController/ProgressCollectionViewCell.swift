//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Misha Causur on 22.02.2021.
//

import UIKit

class ProgressCollectionReusableView: UICollectionViewCell {
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Все получится!"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var percentLabel: UILabel = {
        let label = UILabel()
        let percent = Int(storage.todayProgress) * 100
        label.text = String(percent) + "%"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let progressIndicator: UIProgressView = {
        let line = UIProgressView()
        line.progressTintColor = UIColor.init(named: "purple")
        line.layer.cornerRadius = 4
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(topLabel)
        addSubview(percentLabel)
        addSubview(progressIndicator)
        
        let constraints = [
            topLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            topLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
        
            percentLabel.topAnchor.constraint(equalTo: topLabel.topAnchor),
            percentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        
            progressIndicator.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 10),
            progressIndicator.heightAnchor.constraint(equalToConstant: 7),
            progressIndicator.leadingAnchor.constraint(equalTo: topLabel.leadingAnchor),
            progressIndicator.trailingAnchor.constraint(equalTo: percentLabel.trailingAnchor),
            progressIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)]
        
        NSLayoutConstraint.activate(constraints)
    }
}
