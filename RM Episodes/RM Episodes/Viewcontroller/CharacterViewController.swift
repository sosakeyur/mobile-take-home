//
//  CharacterViewController.swift
//  RM Episodes
//
//  Created by Admin on 7/14/19.
//  Copyright © 2019 Keyur Sosa. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController {
    let cellIdentifier = "Cell"
    var characterModel: CharacterModel?
    var episode: Episode?
    @IBOutlet var characterAliveTableView: UITableView!
    @IBOutlet var characterDeadTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = episode?.name
        characterAliveTableView.dataSource = self
        characterDeadTableView.dataSource = self
        characterAliveTableView.delegate = self
        characterDeadTableView.delegate = self
        
        let endpoint = "character?episode=\(episode?.episode ?? "")&page=\(1)"
        characterModel = CharacterModel(delegate: self)
        characterModel?.fetchCharacters(endPoint: endpoint)
    }
}

extension CharacterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == characterAliveTableView {
            return "Alive"
            
        } else if tableView == characterDeadTableView {
            return "Dead"
        }
        
        fatalError()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == characterAliveTableView {
            return characterModel?.currentAliveCount ?? 0
        } else if tableView == characterDeadTableView {
            return characterModel?.currentDeadCount ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        var titleString: String = ""
        var StatusString: String = ""
        if tableView == characterAliveTableView {
            titleString = (characterModel?.characterAlive(at: indexPath.row).name)!
            StatusString = (characterModel?.characterAlive(at: indexPath.row).status)!
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            
        } else if tableView == characterDeadTableView {
            titleString = (characterModel?.characterDead(at: indexPath.row).name)!
            StatusString = (characterModel?.characterDead(at: indexPath.row).status)!
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        }
        cell.textLabel?.text = titleString
        cell.detailTextLabel?.text = StatusString
        configureCell(cell: cell)
        return cell
    }
    
    func configureCell(cell: UITableViewCell) {
        cell.textLabel?.textColor = #colorLiteral(red: 0.9963521361, green: 0.5935931206, blue: 0, alpha: 1)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.sizeToFit()
        
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        
        cell.contentView.backgroundColor = #colorLiteral(red: 0.3646724522, green: 0.3647280037, blue: 0.3646548986, alpha: 1)
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterDetails: CharacterDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CharacterDetailsViewController") as! CharacterDetailsViewController
        if tableView == characterAliveTableView {
            characterDetails.character = characterModel?.characterAlive(at: indexPath.row)
        } else if tableView == characterDeadTableView {
            characterDetails.character = characterModel?.characterDead(at: indexPath.row)
        }
        navigationController!.pushViewController(characterDetails, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView == characterAliveTableView {
            return .none
        } else if tableView == characterDeadTableView {
            return .delete
        }
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {}
}

extension CharacterViewController: CommonModelDelagate {
    func onFetchNextPageData(with page: Int) {
        let endpoint = "character?episode=\(episode?.episode ?? "")&page=\(page)"
        characterModel?.fetchCharacters(endPoint: endpoint)
    }
    
    func onFetchCompleted() {
        characterDeadTableView.reloadData()
        characterAliveTableView.reloadData()
    }
    
    func onFetchFailed() {
        print("Failed")
    }
}
