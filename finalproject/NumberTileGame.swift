//
//  NumberTileGame.swift
//  00457021_2048
//
//  Created by User16 on 2019/1/11.
//  Copyright © 2019 00457021_2048. All rights reserved.
//

import UIKit


protocol FetchScoreDelegate {
    func fetchScore(_ score: Int)
}

class NumberTileGameViewController : UIViewController, GameModelProtocol {
    
    
    
    
    var dimension: Int
    
    var threshold: Int
    var flag: Int = 0
    
    
    var board: GameboardView?
    var model: GameModel?
    var scoreView: ScoreViewProtocol?
    
    var delegate: FetchScoreDelegate?
    
    
    
    let buttonExit:UIButton = UIButton(type:.custom)
    let buttonRestart = UIButton(type: .custom)
    
    
    let boardWidth: CGFloat = 230.0
    
    let thinPadding: CGFloat = 3.0
    let thickPadding: CGFloat = 6.0
    
    
    let viewPadding: CGFloat = 10.0
    
    
    let verticalViewOffset: CGFloat = 0.0
    
    
    init(dimension d: Int, threshold t: Int) {
        dimension = d > 2 ? d : 2
        threshold = t > 8 ? t : 8
        super.init(nibName: nil, bundle: nil)
        model = GameModel(dimension: dimension, threshold: threshold, delegate: self)
        
        view.backgroundColor = UIColor(patternImage: UIImage(named:"game_background")!)
        setupSwipeControls()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func setupSwipeControls() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(NumberTileGameViewController.upCommand(_:)))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(NumberTileGameViewController.downCommand(_:)))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(NumberTileGameViewController.leftCommand(_:)))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(NumberTileGameViewController.rightCommand(_:)))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(rightSwipe)
    }
    
    
    // View Controller
    override func viewDidLoad()  {
        super.viewDidLoad()
        setupGame()
        
        
        
    }
    
    func reset() {
        assert(board != nil && model != nil)
        let b = board!
        let m = model!
        b.reset()
        m.reset()
        m.insertTileAtRandomLocation(withValue: 2)
        m.insertTileAtRandomLocation(withValue: 2)
    }
    
    
    @objc func RestartGame(sender:UIButton)
    {
        self.reset()
    }
    @objc func ExitGame(sender:UIButton)
    {
        exit(0)
    }
    @objc func buttonBackClicked(sender:UIButton)
    {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "start") as! ViewController
        self.dismiss(animated: true, completion: nil)  //回前頁並顯示tab bar
    }
    
    
    
    func setupGame() {
        let vcHeight = view.bounds.size.height
        let vcWidth = view.bounds.size.width
        
        
        func xPositionToCenterView(_ v: UIView) -> CGFloat {
            let viewWidth = v.bounds.size.width
            let tentativeX = 0.5*(vcWidth - viewWidth)
            return tentativeX >= 0 ? tentativeX : 0
        }
        
        func yPositionForViewAtPosition(_ order: Int, views: [UIView]) -> CGFloat {
            assert(views.count > 0)
            assert(order >= 0 && order < views.count)
            //      let viewHeight = views[order].bounds.size.height
            let totalHeight = CGFloat(views.count - 1)*viewPadding + views.map({ $0.bounds.size.height }).reduce(verticalViewOffset, { $0 + $1 })
            let viewsTop = 0.5*(vcHeight - totalHeight) >= 0 ? 0.5*(vcHeight - totalHeight) : 0
            
            // Not sure how to slice an array yet
            var acc: CGFloat = 0
            for i in 0..<order {
                acc += viewPadding + views[i].bounds.size.height
            }
            return viewsTop + acc
        }
        
        
        let scoreView = ScoreView(backgroundColor: UIColor(red: 249/255, green: 109/255, blue: 156/255, alpha: 1.0),
                                  textColor: UIColor.white,
                                  font: UIFont(name: "HelveticaNeue-Bold", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0),
                                  radius: 6)
        scoreView.score = 0
        
        //create a button
        
        buttonExit.frame = CGRect(x:100, y:600, width:90, height:30)
        
        buttonExit.setTitle("exit", for:.normal)
        buttonExit.backgroundColor = UIColor(red: 100/255, green: 200/255, blue: 150/255, alpha: 1.0)
        buttonExit.setTitleColor(UIColor.white,for: .normal)
        buttonExit.layer.cornerRadius = 15
        
        buttonExit.layer.masksToBounds = true
        buttonExit.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        buttonExit.layer.shadowRadius = 15
        buttonExit.layer.shadowOffset = CGSize(width: 13, height: 13)
        buttonExit.layer.shadowOpacity = 0.5
        
        
        self.view.addSubview(buttonExit)
        
        
        buttonExit.tag = 4
        buttonExit.addTarget(self,action:#selector(ExitGame),
                         for:.touchUpInside)
        
        //create a button
        
        buttonRestart.frame = CGRect(x:220, y:600, width:90, height:30)
        
        buttonRestart.setTitle("restart", for:.normal)
        buttonRestart.backgroundColor = UIColor(red: 100/255, green: 200/255, blue: 150/255, alpha: 1.0)
        buttonRestart.setTitleColor(UIColor.white,for: .normal)
        buttonRestart.layer.cornerRadius = 15
        
        buttonRestart.layer.masksToBounds = true
        buttonRestart.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        buttonRestart.layer.shadowRadius = 15
        buttonRestart.layer.shadowOffset = CGSize(width: 13, height: 13)
        buttonRestart.layer.shadowOpacity = 0.5
        
        
        self.view.addSubview(buttonRestart)
        
        
        buttonRestart.tag = 5
        buttonRestart.addTarget(self,action:#selector(RestartGame),
                         for:.touchUpInside)
        
        
        
        
        let padding: CGFloat = dimension > 5 ? thinPadding : thickPadding
        let v1 = boardWidth - padding*(CGFloat(dimension + 1))
        let width: CGFloat = CGFloat(floorf(CFloat(v1)))/CGFloat(dimension)
        let gameboard = GameboardView(dimension: dimension,
                                      tileWidth: width,
                                      tilePadding: padding,
                                      cornerRadius: 6,
                                      backgroundColor: UIColor(red: 100/255, green: 150/255, blue: 150/255, alpha: 1.0),
                                      foregroundColor: UIColor(red: 100/255, green: 100/255, blue: 50/255, alpha: 1.0))
        
        let views = [scoreView, gameboard]
        
        var f = scoreView.frame
        f.origin.x = xPositionToCenterView(scoreView)
        f.origin.y = yPositionForViewAtPosition(0, views: views)
        scoreView.frame = f
        
        f = gameboard.frame
        f.origin.x = xPositionToCenterView(gameboard)
        f.origin.y = yPositionForViewAtPosition(1, views: views)
        gameboard.frame = f
        
        
        // Add to game state
        view.addSubview(gameboard)
        board = gameboard
        view.addSubview(scoreView)
        self.scoreView = scoreView
        
        assert(model != nil)
        let m = model!
        m.insertTileAtRandomLocation(withValue: 2)
        m.insertTileAtRandomLocation(withValue: 2)
    }
    
    // Misc
    func followUp() {
        assert(model != nil)
        let m = model!
        let (userWon, _) = m.userHasWon()
        if userWon {
            // TODO: alert delegate we won
            
            let alertView = UIAlertView()
            alertView.title = "成功啦！"
            alertView.message = "恭喜恭喜！"
            alertView.addButton(withTitle: "Cancel")
            alertView.show()
            // TODO: At this point we should stall the game until the user taps 'New Game' (which hasn't been implemented yet)
            return
        }
        
        
        
        let randomVal = Int(arc4random_uniform(10))
        m.insertTileAtRandomLocation(withValue: randomVal == 1 ? 4 : 2)
        
        if m.userHasLost() {
            NSLog("You lost")
            let alertController = UIAlertController(title: "可惜了！", message: "可惜失敗了", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "重新開始", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                self.reset()
            }
            let cancelAction = UIAlertAction(title: "退出遊戲", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
                exit(0)
            }
            
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // Commands
    @objc(up:)
    func upCommand(_ r: UIGestureRecognizer!) {
        assert(model != nil)
        let m = model!
        m.queueMove(direction: MoveDirection.up,
                    onCompletion: { (changed: Bool) -> () in
                        if changed {
                            self.followUp()
                        }
                    })
    }
    
    @objc(down:)
    func downCommand(_ r: UIGestureRecognizer!) {
        assert(model != nil)
        let m = model!
        m.queueMove(direction: MoveDirection.down,
                    onCompletion: { (changed: Bool) -> () in
                        if changed {
                            self.followUp()
                        }
                    })
    }
    
    @objc(left:)
    func leftCommand(_ r: UIGestureRecognizer!) {
        assert(model != nil)
        let m = model!
        m.queueMove(direction: MoveDirection.left,
                    onCompletion: { (changed: Bool) -> () in
                        if changed {
                            self.followUp()
                        }
                    })
    }
    
    @objc(right:)
    func rightCommand(_ r: UIGestureRecognizer!) {
        assert(model != nil)
        let m = model!
        m.queueMove(direction: MoveDirection.right,
                    onCompletion: { (changed: Bool) -> () in
                        if changed {
                            self.followUp()
                        }
                    })
    }
    
    // Protocol
    func scoreChanged(to score: Int) {
        if scoreView == nil {
            return
        }
        let s = scoreView!
        s.scoreChanged(to: score)
    }
    
    func getScore() -> Int {
        let s = scoreView!
        return s.getScore()
    }
    
    
    func moveOneTile(from: (Int, Int), to: (Int, Int), value: Int) {
        assert(board != nil)
        let b = board!
        b.moveOneTile(from: from, to: to, value: value)
    }
    
    func moveTwoTiles(from: ((Int, Int), (Int, Int)), to: (Int, Int), value: Int) {
        assert(board != nil)
        let b = board!
        b.moveTwoTiles(from: from, to: to, value: value)
    }
    
    func insertTile(at location: (Int, Int), withValue value: Int) {
        assert(board != nil)
        let b = board!
        b.insertTile(at: location, value: value)
    }
}

