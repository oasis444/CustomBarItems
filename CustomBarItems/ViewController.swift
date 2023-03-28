//
//  ViewController.swift
//  CustomBarItems
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }

    private func configure() {
        let leftBtn1 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonTapped1))
        
        let leftBtn2 = UIBarButtonItem(title: "next1", style: .plain, target: self, action: #selector(buttonTapped1))
        leftBtn2.tintColor = .systemPink
        
        let rightBtn1 = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: self, action: #selector(buttonTapped1))
        rightBtn1.tintColor = .label
        
        let rightBtnConfig = CustomBarItemConfigure(title: "next2", image: nil, color: .label) {
            self.buttonTapped1()
        }
        let rightBtn2 = UIBarButtonItem.generate(config: rightBtnConfig, width: 50)
        
        navigationItem.leftBarButtonItems = [leftBtn1, leftBtn2]
        navigationItem.rightBarButtonItems = [rightBtn1, rightBtn2]
    }
    
    @objc func buttonTapped1() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! SecondVC
        navigationController?.pushViewController(vc, animated: true)
    }
}

struct CustomBarItemConfigure {
    let title: String?
    let image: UIImage?
    let color: UIColor?
    let handler: () -> Void
    
    init(title: String? = nil, image: UIImage? = nil, color: UIColor? = .link, handler: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.color = color
        self.handler = handler
    }
}

final class CustomBarItem: UIButton {
    var customConfig: CustomBarItemConfigure
    
    init(config: CustomBarItemConfigure) {
        self.customConfig = config
        super.init(frame: .zero)
        self.setTitle(customConfig.title, for: .normal)
        self.setImage(customConfig.image, for: .normal)
        self.setTitleColor(customConfig.color, for: .normal)
        self.addTarget(self, action: #selector(buttonTapped2), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: \(coder) has not been implemented")
    }
    
    @objc func buttonTapped2() {
        customConfig.handler()
    }
}

extension UIBarButtonItem {
    static func generate(config: CustomBarItemConfigure, width: CGFloat? = nil) -> UIBarButtonItem {
        let customView = CustomBarItem(config: config)
        
        if let width = width {
            NSLayoutConstraint.activate([
                customView.widthAnchor.constraint(equalToConstant: width)
            ])
        }
        
        let barButtonItem = UIBarButtonItem(customView: customView)
        return barButtonItem
    }
}
