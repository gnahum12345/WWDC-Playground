//: Playground - noun: a place where people can play


import SpriteKit
import XCPlayground



let frame = CGRect(x: 0, y: 0, width: 320, height: 256)
let midPoint = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
var scene = SKScene(size: frame.size)

let stadium = SKSpriteNode(imageNamed: "stadiumPhotoL")
stadium.position = midPoint
stadium.setScale(1.5)
//nyanCat.run(SKAction.repeatForever(SKAction.sequence([
//    SKAction.moveBy(x: 0, y: 10, duration: 0.15),
//    SKAction.moveBy(x: 0, y: -10, duration: 0.15)
//    ])))
//nyanCat.zPosition = 10

scene.addChild(stadium)

class TouchableSpriteNode : SKSpriteNode
{
    var scored = 0
    var missed = 0
    
    override func mouseDown(with event: NSEvent) {
        print("touched")
        
        var randomXBall = Int(arc4random() % 100)
        let randomYBall = (arc4random() % 100) + 50
        
        if randomXBall % 2 == 0 {
            randomXBall = randomXBall * (-1)
        }
        
        let moveNodeUp = SKAction.moveBy(x: CGFloat(randomXBall),
                                         y: CGFloat(randomYBall),
                                         duration: 0.5)
        let scale = SKAction.scale(to: 0.01, duration: 0.5)
        
        self.run(moveNodeUp)
        self.run(scale)
        
        
        var randomXGoalie = Int(arc4random() % 100)
        if randomXGoalie % 2 == 0 {
            randomXGoalie = randomXGoalie * (-1)
        }
        let randomYGoalie = arc4random() % 50
        
        let randomAngle = Int(arc4random() % 180)
        
        
        let rotation = SKAction.rotate(byAngle: CGFloat(randomAngle)*3.14/180.0, duration: 0.5)
        
        let moveGoalie = SKAction.moveBy(x: CGFloat(randomXGoalie), y: CGFloat(randomYGoalie), duration: 0.5)
        goalie.run(moveGoalie)
        goalie.run(rotation, completion: {
            
            let scoreLabel = self.scene?.childNode(withName: "scoreLabel") as! SKLabelNode
            
            if self.checkGoal() {
                self.afterGoal()
                self.celebrate()
                //                scoreNum += 1
                self.scored += 1
                print(self.scored)
                scoreLabel.text = "\(self.scored):\(self.missed)"
                
                
            }else {
                self.scene?.run(SKAction.playSoundFileNamed("stadiumClap.mp3", waitForCompletion: false))
                
                self.missed += 1
                scoreLabel.text = "\(self.scored):\(self.missed)"
                self.restart()
                
            }
        })
        
        
        
    }
    func restart(){
        
        let returnGoalie = SKAction.move(to: CGPoint(x: 150, y: 135), duration: 2.5)
        let rotateGoalie = SKAction.rotate(toAngle: 0, duration: 2.5)
        goalie.run(SKAction.sequence([returnGoalie, rotateGoalie]))
        
        let returnBall = SKAction.move(to: CGPoint(x: 150, y: 70), duration: 2.5)
        let scaleBall = SKAction.scale(to: 0.02, duration: 2.5)
        
        self.run(SKAction.sequence([returnBall, scaleBall]), completion: {
            let messageScore = self.scene?.childNode(withName: "messageWWDC") as? SKLabelNode
            messageScore?.removeFromParent()
            
            
        })
        
        
    }
    
    func checkGoal() -> Bool{
        let p1 = goalie.position
        let p2 = self.position
        let distance = hypot((p1.x - p2.x), (p1.y - p2.y))
        print(distance)
        if distance < 22 {
            return false
        }else{
            return true
        }
    }
    
    let colors = [SKColor.red, SKColor.blue, SKColor.green, SKColor.cyan, SKColor.gray, SKColor.yellow, SKColor.orange, SKColor.white]
    func afterGoal(){
        let fallGoalie = SKAction.move(to: CGPoint(x: goalie.position.x, y: 140), duration: 0.5)
        
        
        let fallBall = SKAction.move(to:CGPoint(x:self.position.x, y: 150), duration:0.5)
        
        goalie.run(fallGoalie)
        self.run(fallBall)
    }
    func celebrate(){
        scene?.run(SKAction.playSoundFileNamed("stadiumClap.mp3", waitForCompletion: false))
        scene?.run(SKAction.playSoundFileNamed("airHorn.mp3", waitForCompletion: false))
        for color in colors {
            let emitter = SKEmitterNode()
            emitter.particleLifetime = 60
            emitter.particleBlendMode = SKBlendMode.alpha
            emitter.particleBirthRate = 200
            emitter.particleSize = CGSize(width: 6,height: 6)
            emitter.particleScale = 0.8
            emitter.particleScaleRange = 0.5
            emitter.particleColor = color
            emitter.position = CGPoint(x:frame.size.width/2,y:frame.size.height)
            emitter.particleSpeed = 75
            emitter.particleSpeedRange = 20
            emitter.particlePositionRange = CGVector(dx: 600, dy: 600)
            emitter.emissionAngle = CGFloat(3*3.14/2.0)
            emitter.advanceSimulationTime(4)
            emitter.particleAlpha = 0.5
            emitter.particleAlphaRange = 1
            
            scene?.addChild(emitter)
            emitter.particleBirthRate = 0
            
        }
        let message = SKLabelNode(fontNamed: "Chalkduster")
        message.text = "I scored a ticket to WWDC 17!!!!!"
        message.fontSize = CGFloat(15)
        message.position = CGPoint(x: 160, y: 85)
        message.name = "messageWWDC"
        message.color = SKColor.black
        scene?.addChild(message)
        
        bounce()
        
        
    }
    
    func bounce(){
        let posY = self.position.y
        let ballAction = SKAction.moveTo(y: 130, duration: 0.75)
        let returnAct = SKAction.moveTo(y: posY-20, duration: 1.5)
        let delay = SKAction.wait(forDuration: 3)
        self.run(SKAction.sequence([ballAction,returnAct,ballAction,delay]), completion: {
            self.restart()
        })
        
    }
}


let goalie = SKSpriteNode(imageNamed: "goalie")
goalie.position = CGPoint(x: 150, y: 135)
goalie.setScale(0.1)





let ball = TouchableSpriteNode(imageNamed: "soccerBall")
ball.position = CGPoint(x: 150, y: 70)
ball.setScale(0.02)
ball.isUserInteractionEnabled = true


scene.addChild(ball)
scene.addChild(goalie)


let instruct = SKLabelNode(fontNamed: "Chalkduster")
instruct.text = "Click the ball to shoot"
instruct.fontSize = CGFloat(15)
instruct.position = CGPoint(x:100, y: 2)
scene.addChild(instruct)


let score = SKLabelNode(fontNamed: "Chalkduster")
score.text = "\(ball.scored):\(ball.missed)"
score.position = CGPoint(x: 275, y: 2)
score.name = "scoreLabel"
scene.addChild(score)






scene.run(SKAction.repeatForever(SKAction.playSoundFileNamed("stadiumNorm.mp3", waitForCompletion: true)))

//: And show the scene in the liveView

let view = SKView(frame: frame)
view.presentScene(scene)
XCPlaygroundPage.currentPage.liveView = view

//: OK I'm done.
