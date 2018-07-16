//
//  MalertView.swift
//  Pods
//
//  Created by Vitor Mesquita on 31/10/16.
//
//

import UIKit

public class MalertView: UIView {
    
    private lazy var titleLabel = UILabel.ilimitNumberOfLines()
    private lazy var buttonsStackView = UIStackView.defaultStack(axis: .vertical)
    
    private var stackConstraints: [NSLayoutConstraint] = []
    private var titleLabelConstraints: [NSLayoutConstraint] = []
    private var customViewConstraints: [NSLayoutConstraint] = []
    
    private var inset: CGFloat = 0 {
        didSet { refreshViews() }
    }
    
    private var stackInset: CGFloat = 0 {
        didSet { updateButtonsStackViewConstraints() }
    }
    
    private var customView: UIView? {
        didSet {
            if let oldValue = oldValue {
                oldValue.removeFromSuperview()
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        clipsToBounds = true
        
        //TODO Verificar se não não sobreescreve o appearence
        margin = 0
        cornerRadius = 6
        backgroundColor = .white
        textColor = .black
        textAlign = .left
        titleFont = UIFont.systemFont(ofSize: 14)
        buttonsSpace = 0
        buttonsMargin = 0
        buttonsAxis = .vertical
        //TODO Verificar se não não sobreescreve o appearence
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK - Utils
    
    private var hasButtons: Bool {
        guard buttonsStackView.isDescendant(of: self) else { return false }
        return !buttonsStackView.arrangedSubviews.isEmpty
    }
    
    private func refreshViews() {
        updateTitleLabelConstraints()
        updateCustomViewConstraints()
        updateButtonsStackViewConstraints()
    }
}

// MARK: - Extensions to setUp Views in alert
extension MalertView {
    
    func seTitle(_ title: String?) {
        if let title = title {
            titleLabel.text = title
            
            if !titleLabel.isDescendant(of: self) {
                self.addSubview(titleLabel)
                refreshViews()
            }
            
        } else {
            titleLabel.removeFromSuperview()
            refreshViews()
        }
    }
    
    func setCustomView(_ customView: UIView?) {
        guard let customView = customView else { return }
        self.customView = customView
        self.addSubview(customView)
        refreshViews()
    }
    
    func addButton(_ button: MalertAction) {
        let buttonView = MalertButtonView(type: .system)
        buttonView.initializeMalertButton(malertButton: button,
                                          index: buttonsStackView.arrangedSubviews.count,
                                          hasMargin: buttonsSpace > 0,
                                          isHorizontalAxis: buttonsAxis == .horizontal)
        
        buttonsStackView.addArrangedSubview(buttonView)
        
        if !buttonsStackView.isDescendant(of: self) {
            self.addSubview(buttonsStackView)
            refreshViews()
        }
    }
}

/**
 * Extensios that implements Malert constraints to:
 *  - Title Label
 *  - Custom View
 *  - Buttons Stack View
 */
extension MalertView {
    
    private func updateTitleLabelConstraints() {
        NSLayoutConstraint.deactivate(titleLabelConstraints)
        guard titleLabel.isDescendant(of: self) else { return }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    private func updateCustomViewConstraints() {
        guard let customView = customView else { return }
        
        NSLayoutConstraint.deactivate(customViewConstraints)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customViewConstraints = [
            customView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset),
            customView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset)
        ]
        
        if titleLabel.isDescendant(of: self) {
            customViewConstraints.append(customView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: inset))
        } else {
            customViewConstraints.append(customView.topAnchor.constraint(equalTo: self.topAnchor, constant: inset))
        }
        
        if !hasButtons {
            customViewConstraints.append(customView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset))
        }
        
        NSLayoutConstraint.activate(customViewConstraints)
    }
    
    private func updateButtonsStackViewConstraints() {
        if let customView = customView, hasButtons {
            
            NSLayoutConstraint.deactivate(stackConstraints)
            buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
            stackConstraints = [
                buttonsStackView.topAnchor.constraint(equalTo: customView.bottomAnchor, constant: inset),
                buttonsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -stackInset),
                buttonsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: stackInset),
                buttonsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -stackInset)
            ]
            
            NSLayoutConstraint.activate(stackConstraints)
        }
    }
}

// MARK: - Appearance
extension MalertView {
    
    /// Dialog view corner radius
    @objc public dynamic var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    /// Title text color
    @objc public dynamic var textColor: UIColor {
        get { return titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }
    
    /// Title text Align
    @objc public dynamic var textAlign: NSTextAlignment {
        get { return titleLabel.textAlignment }
        set { titleLabel.textAlignment = newValue }
    }
    
    /// Title font
    @objc public dynamic var titleFont: UIFont {
        get { return titleLabel.font }
        set { titleLabel.font = newValue }
    }
    
    /// Buttons distribution in stack view
    @objc public dynamic var buttonsDistribution: UIStackViewDistribution {
        get { return buttonsStackView.distribution }
        set { buttonsStackView.distribution = newValue }
    }
    
    /// Buttons aligns in stack view
    @objc public dynamic var buttonsAligment: UIStackViewAlignment {
        get { return buttonsStackView.alignment }
        set { buttonsStackView.alignment = newValue }
    }
    
    /// Buttons axis in stack view
    @objc public dynamic var buttonsAxis: UILayoutConstraintAxis {
        get { return buttonsStackView.axis }
        set { buttonsStackView.axis = newValue }
    }
    
    /// Margin inset to titleLabel and CustomView
    @objc public dynamic var margin: CGFloat {
        get { return inset }
        set { inset = newValue }
    }
    
    /// Margin inset to StackView buttons
    @objc public dynamic var buttonsMargin: CGFloat {
        get { return stackInset }
        set { stackInset = newValue }
    }
    
    /// Margin inset between buttons
    @objc public dynamic var buttonsSpace: CGFloat {
        get { return buttonsStackView.spacing }
        set { buttonsStackView.spacing = newValue }
    }
}

//extension MalertView {
//
//    private func buildButtonsBy(buttons: [MalertButton]?, hasMargin: Bool, isHorizontalAxis: Bool) -> [MalertButtonView]? {
//        guard let buttons = buttons else { return nil }
//        return buttons.enumerated().map { (index, button) -> MalertButtonView in
//            let buttonView = MalertButtonView(type: .system)
//            buttonView.initializeMalertButton(malertButton: button, index: index, hasMargin: hasMargin, isHorizontalAxis: isHorizontalAxis)
//            return buttonView
//        }
//    }
//}
