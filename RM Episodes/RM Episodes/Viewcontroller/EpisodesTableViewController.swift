//
//  EpisodesTableViewController.swift
//  RM Episodes
//
//  Created by Admin on 7/14/19.
//  Copyright © 2019 Keyur Sosa. All rights reserved.
//

import UIKit

class EpisodesTableViewController: UITableViewController {
    var epoisodeModel: EpisodesModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "R&M Episodes"
        self.tableView.tableFooterView = UIView()
        let endpoint = "episode?page=\(1)"
        epoisodeModel = EpisodesModel(delegate: self)
        epoisodeModel?.fetchEpisodes(endPoint: endpoint)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.epoisodeModel?.currentCount ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodesCell", for: indexPath) as! EpisodesTableViewCell
        if isLoadingCell(for: indexPath) {
            cell.setupWithEpisodes(with: .none)
        } else {
            cell.setupWithEpisodes(with: self.epoisodeModel!.episode(at: indexPath.row))
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "characterVC", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let characterViewController = segue.destination as? CharacterViewController,
            let index = tableView.indexPathForSelectedRow?.row
        else {
            return
        }
        characterViewController.episode = self.epoisodeModel?.episode(at: index)
    }
}

extension EpisodesTableViewController: CommonModelDelagate {
    func onFetchNextPageData(with page: Int) {
        let endpoint = "episode?page=\(page)"
        epoisodeModel?.fetchEpisodes(endPoint: endpoint)
    }

    func onFetchCompleted() {
        self.tableView.reloadData()
    }

    func onFetchFailed() {
        print("Failed")
    }
}

private extension EpisodesTableViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= self.epoisodeModel?.currentCount ?? 0
    }
}
