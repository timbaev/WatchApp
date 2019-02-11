//
//  CheatSheetsTableViewController.swift
//  CheatSheet
//
//  Created by Timur Shafigullin on 30/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class CheatSheetsTableViewController: LoggedViewController {
    
    // MARK: - Nested Types
    
    fileprivate enum Constants {
        
        // MARK: - Type Properties
        
        static let cheatSheetCellIdentifier = "CheatSheetCell"
    }
    
    // MARK: -
    
    fileprivate enum Segues {
        
        // MARK: - Type Properties
        
        static let showCheatSheetDetails = "ShowCheatSheetDetails"
    }
    
    // MARK: - Instance Properties
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    @IBOutlet fileprivate weak var emptyStateContainerView: UIView!
    @IBOutlet fileprivate weak var emptyStateView: EmptyStateView!
    
    // MARK: -
    
    fileprivate(set) var shouldApplyData = true
    
    fileprivate var cheatSheets: [CheatSheet] = []
    
    // MARK: - Initializers
    
    deinit {
        self.unsubscribeFromCheatSheetsEvents()
    }
    
    // MARK: - Instance Methods
    
    @IBAction fileprivate func onCreateCheatSheetFinished(segue: UIStoryboardSegue) {
        Log.high("onCreateCheatSheetFinished(segue: \(String(describing: segue.identifier)))", from: self)
    }
    
    @IBAction fileprivate func onUpdateCheatSheetFinished(segue: UIStoryboardSegue) {
        Log.high("onUpdateCheatSheetFinished(segue: \(String(describing: segue.identifier)))", from: self)
    }
    
    // MARK: -
    
    fileprivate func subscribeToCheatSheetsEvents() {
        self.unsubscribeFromCheatSheetsEvents()
        
        Managers.cheatSheetManager.objectsChangedEvent.connect(self, handler: { [weak self] cheatSheets in
            self?.apply(cheatSheets: cheatSheets)
        })
        
        Managers.cheatSheetManager.startObserving()
    }
    
    fileprivate func unsubscribeFromCheatSheetsEvents() {
        Managers.cheatSheetManager.objectsChangedEvent.disconnect(self)
    }
    
    // MARK: -
    
    fileprivate func apply(cheatSheets: [CheatSheet]) {
        Log.high("apply(cheatSheets: \(cheatSheets.count))", from: self)
        
        self.cheatSheets = cheatSheets
        
        if self.isViewLoaded {
            self.tableView.reloadData()
            
            self.updateEmptyState()
            
            Managers.watchManager.sendDataArray(["cheatSheets": cheatSheets])
            
            self.shouldApplyData = false
        } else {
            self.shouldApplyData = true
        }
    }
    
    // MARK: -
    
    fileprivate func config(cheatSheetCell cell: CheatSheetTableViewCell, at indexPath: IndexPath) {
        let cheatSheet = self.cheatSheets[indexPath.row]
        
        cell.title = cheatSheet.title
    }
    
    fileprivate func updateEmptyState() {
        if self.cheatSheets.isEmpty {
            self.emptyStateContainerView.isHidden = false
        } else {
            self.emptyStateContainerView.isHidden = true
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.shouldApplyData = true
        
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.subscribeToCheatSheetsEvents()
        
        if self.shouldApplyData {
            Managers.cheatSheetManager.fetch(completion: { [weak self] cheatSheets in
                self?.apply(cheatSheets: cheatSheets)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case Segues.showCheatSheetDetails:
            guard let cheatSheet = sender as? CheatSheet else {
                fatalError()
            }
            
            let dictionaryReceiver: DictionaryReceiver?
            
            if let navigationController = segue.destination as? UINavigationController {
                dictionaryReceiver = navigationController.viewControllers.first as? DictionaryReceiver
            } else {
                dictionaryReceiver = segue.destination as? DictionaryReceiver
            }
            
            if let dictionaryReceiver = dictionaryReceiver {
                dictionaryReceiver.apply(dictionary: ["cheatSheet": cheatSheet])
            }
            
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension CheatSheetsTableViewController: UITableViewDataSource {
    
    // MARK: - Instance Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cheatSheets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cheatSheetCellIdentifier, for: indexPath)
        
        self.config(cheatSheetCell: cell as! CheatSheetTableViewCell, at: indexPath)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CheatSheetsTableViewController: UITableViewDelegate {
    
    // MARK: - Instance Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cheatSheet = self.cheatSheets[indexPath.row]
        
        self.performSegue(withIdentifier: Segues.showCheatSheetDetails, sender: cheatSheet)
    }
}
