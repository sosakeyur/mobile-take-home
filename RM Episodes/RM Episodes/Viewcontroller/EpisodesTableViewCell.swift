//
//  EpisodesTableViewCell.swift
//  RM Episodes
//
//  Created by Admin on 7/14/19.
//  Copyright © 2019 Keyur Sosa. All rights reserved.
//

import UIKit

class EpisodesTableViewCell: UITableViewCell {
    @IBOutlet var episodeTitle: UILabel!
    @IBOutlet var episodeId: UILabel!
    @IBOutlet var episodesAirDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupWithEpisodes(with episode: Episode?) {
        episodeTitle.text = episode?.name
        episodeId.text = episode?.episode
    }
}
