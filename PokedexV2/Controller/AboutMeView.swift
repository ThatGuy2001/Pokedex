//
//  AboutMeView.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 17/04/2024.
//

import UIKit

class AboutMeView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBacgorundImage()
        addTextBox()
    }
    
    func addBacgorundImage() {
        let backgroundImage = UIImageView(image: UIImage(named: "Image"))
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    }
    
    func addTextBox(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let textBox = UIVisualEffectView(effect: blurEffect)
        textBox.layer.cornerRadius = 50
        textBox.clipsToBounds = true
        view.addSubview(textBox)
        textBox.translatesAutoresizingMaskIntoConstraints = false
        textBox.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        textBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        textBox.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50).isActive = true
        textBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        
     // addTextLabel
        
        let textLabel = UILabel()
        textLabel.text = """
This app was devoped by Diogo Rodrigues as a part of a internship in DigitalWorks.

The Objective of the app os to use the API provided by https://pokeapi.co/ to obtain and display information about the Pokemon.

All the app was designed using a storyboard or xib files, with the exeption of this very page. Some of my favorite aspecsts are: the layout shown on the first page, the iteractive sprite, and the dynamic habitat image show
"""
        
        textLabel.numberOfLines = 0
        
        textBox.contentView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.bottomAnchor.constraint(equalTo: textBox.contentView.bottomAnchor, constant: -50).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: textBox.contentView.trailingAnchor,constant: -50).isActive = true
        textLabel.topAnchor.constraint(equalTo: textBox.contentView.topAnchor, constant: 210).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: textBox.contentView.leadingAnchor, constant: 50).isActive = true
        
    // add profileImage
        
        let contentview = textBox.contentView
        
        let image = UIImageView(image: UIImage(named: "AboutMe"))
        contentview.addSubview(image)
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        image.topAnchor.constraint(equalTo: contentview.topAnchor, constant: 10 ).isActive = true
        image.centerXAnchor.constraint(equalTo: contentview.centerXAnchor , constant: 0).isActive = true
        
        image.widthAnchor.constraint(equalToConstant: 200).isActive = true
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
}
