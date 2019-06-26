//
//  DetailViewController.swift
//  MJ Notes
//
//  Created by maurice on 6/26/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	@IBOutlet weak var detailTextView: UITextView!
	var emptyText:String = ""
	
	var masterView:ViewController!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

		detailTextView.text = emptyText
		
		self.navigationItem.largeTitleDisplayMode = .never
	}
	
	
	func setNoteText(t:String){
		emptyText = t
		if isViewLoaded {
			detailTextView.text = t
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		detailTextView.becomeFirstResponder()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		masterView.newRowText = detailTextView.text
		detailTextView.resignFirstResponder()
	}
	
	
	
	
	
	
}
