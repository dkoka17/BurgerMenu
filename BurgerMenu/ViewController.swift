//
//  ViewController.swift
//  BurgerMenu
//
//  Created by dato on 1/9/21.
//

import UIKit

class CellClass: UITableViewCell {
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    let dataSource = ["Abouts Us", "product","media","contact us"]
     
    var opened = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
    }


    func addTransperentView(){
        
        UIView.animateKeyframes(
            withDuration: 0.1,
            delay: 0,
            options: .calculationModeLinear,
            animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                    self.button.transform =  CGAffineTransform(rotationAngle: .pi/2)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.25, animations: {
                    self.button.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
                })
                    
              
                
            },
            completion: {_ in})

        
        let frames = button.frame
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x,
                                 y: frames.origin.y+frames.height,
                                 width: frames.width,
                                 height: 0)
        
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
    
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        let tapgesture = UITapGestureRecognizer(target: self, action:#selector(removeTranasparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: 0,
                                          y: frames.origin.y+frames.height,
                                          width: self.navigationController?.navigationBar.frame.size.width ?? 300,
                                          height: CGFloat(self.dataSource.count * 60))
        }, completion: nil)
    }
    
    @objc func removeTranasparentView() {
        
        UIView.animateKeyframes(
            withDuration: 0.1,
            delay: 0,
            options: .calculationModeLinear,
            animations: {
                
                self.button.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.25, animations: {
                    self.button.transform =  CGAffineTransform.identity
                })
                
            },
            completion: {_ in})
        
        
        let frames = button.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x,
                                          y: frames.origin.y+frames.height,
                                          width: frames.width,
                                          height: 0)
        }, completion: nil)
    }
    
    
    @IBAction func onClick(_ sender: Any) {
        
        if self.opened == 0 {
            addTransperentView()
            self.opened = 1
        }else{
            removeTranasparentView()
            self.opened = 0
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        removeTranasparentView()
    }
}

