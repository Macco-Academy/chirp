//
//  ViewController.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 04.06.23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ChatsTableView: UITableView!
    

    let sections = ["one", "two", "three"]
    var chatData: [[String]] = [
        ["lion", "tiger"],
        ["one", "tow"]
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChatsTableView.dataSource = self
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        chatData.count
//        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
//        chatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell") as! MyTableViewCell
        let title = rows[indexPath.section][indexPath.row]
//        cell.textLabel?.text = title
//        cell.textLabel?.text = "Cell #\(indexPath.item)"
        cell.avatar.image = #imageLiteral(resourceName: "Ellipse 2testFigma_test.png")
        cell.name.text = title
        return cell
    }
    
    
   

    
}

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var notifications: UILabel!
}
