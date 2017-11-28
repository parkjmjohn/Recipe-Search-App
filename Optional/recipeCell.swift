//
//  recipeCell.swift
//  Optional
//
//  Created by John Park on 11/27/17.
//  Copyright © 2017 John Park. All rights reserved.
//

import UIKit


class recipeCell: UITableViewCell {
    
    // MARK: Spacing
    let padding1: CGFloat = 4
    let padding2: CGFloat = 16
    
    // MARK: UI
    var title: UILabel!
    var ingredients: UITextView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        title = UILabel(frame: CGRect(x: padding1, y: padding1, width: padding1 * 100, height: padding2))
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
        contentView.addSubview(title)
        
        ingredients = UITextView(frame: CGRect(x: padding1, y: padding1 + padding2, width: padding1 * 100, height: padding2 * 5))
        ingredients.textColor = .gray
        ingredients.isUserInteractionEnabled = false
        contentView.addSubview(ingredients)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp(Recipe: recipe) {
        title.text = Recipe.title
        ingredients.text = "Ingredients: " + Recipe.ingredients
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     // Configure the view for the selected state
    }
}


