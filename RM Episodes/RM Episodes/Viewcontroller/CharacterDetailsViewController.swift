//
//  CharacterDetailsViewController.swift
//  RM Episodes
//
//  Created by Admin on 7/14/19.
//  Copyright © 2019 Keyur Sosa. All rights reserved.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    @IBOutlet var characterAvatar: UIImageView!
    @IBOutlet var characterName: UILabel!
    @IBOutlet var characterStatus: UILabel!
    @IBOutlet var characterSpecies: UILabel!
    @IBOutlet var characterGender: UILabel!
    @IBOutlet var characterOrigin: UILabel!
    @IBOutlet var characterLastLocation: UILabel!

    var character: Character?
    var client = NetworkClass()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = character?.name
        guard let imageUrl = character?.image else { return }
        downloadImage(from: imageUrl)
        characterName.text = character?.name
        characterStatus.text = character?.status
        characterSpecies.text = character?.species
        characterGender.text = character?.gender
        characterOrigin.text = character?.origin.name
        characterLastLocation.text = character?.location.name
    }

    func downloadImage(from url: URL) {
        print("Download Started")
        client.getData(fromURL: url) { imageData in
            guard let data = imageData else { return }
            print("Download Finished")
            DispatchQueue.main.async {
                self.characterAvatar.image = UIImage(data: data)
            }
        }
    }
}
