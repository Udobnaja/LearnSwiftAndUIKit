//
//  GameScene.swift
//  Pachinko
//
//  Created by Anna Udobnaja on 29.04.2021.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private lazy var scoreLabel = makeScoreLabel()
    private lazy var editLabel = makeEditLabel()
    private var score = 0 {
      didSet {
        scoreLabel.text = "Score: \(score)"
      }
    }
    private var editingMode = false {
      didSet {
        editLabel.text = editingMode ? "Done" : "Edit"
      }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")

      background.position = CGPoint(x: 512, y: 384)
      background.blendMode = .replace
      background.zPosition = -1

      addChild(background)
      addChild(scoreLabel)
      addChild(editLabel)

      physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
      physicsWorld.contactDelegate = self


      for position in [(0, 0), (256, 0), (512, 0), (768, 0), (1024, 0)] {
        let (x, y) = position
        makeBouncer(at: CGPoint(x: x, y: y))
      }

      for slot in [(128, 0, true), (384, 0, false), (640, 0, true), (896, 0, false)] {
        let (x, y, isGood) = slot
        makeSlot(at: CGPoint(x: x, y: y), isGood: isGood)
      }
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let touch = touches.first else { return }

      let location = touch.location(in: self)
      let objects = nodes(at: location)

      if objects.contains(editLabel) {
        editingMode.toggle()
      } else {
        if editingMode {
          let box = makeBox(at: location)

          addChild(box)
        } else {
          let ball = makeBall(at: CGPoint(x: location.x, y: CGFloat.random(in: (location.y < 700 ? location.y : 0)...700)))

          addChild(ball)
        }
      }

  //    let boxSize = CGSize(width: 64, height: 64)
  //    let box = SKSpriteNode(color: .red, size: boxSize)
  //
  //    box.physicsBody = SKPhysicsBody(rectangleOf: boxSize)
  //    box.position = location
  //
  //    addChild(box)
    }

    private func makeScoreLabel() -> SKLabelNode {
      let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
      scoreLabel.text = "Score: 0"
      scoreLabel.horizontalAlignmentMode = .right
      scoreLabel.position = CGPoint(x: 980, y: 700)

      return scoreLabel
    }

    private func makeEditLabel() -> SKLabelNode {
      let editLabel = SKLabelNode(fontNamed: "Chalkduster")
      editLabel.text = "Edit"
      editLabel.position = CGPoint(x: 80, y: 700)

      return editLabel
    }

    private func makeBall(at position: CGPoint) -> SKSpriteNode {
      var balls = ["ballRed", "ballGreen", "ballBlue", "ballPurple", "ballGrey", "ballCyan", "ballYellow"]
      balls.shuffle()
      let ball = SKSpriteNode(imageNamed: balls[0])

      ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
      ball.physicsBody?.restitution = 0.4
      ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
      ball.position = position
      ball.name = "ball"

      return ball
    }

    private func makeBox(at position: CGPoint) -> SKSpriteNode {
      let size = CGSize(width: Int.random(in: 16...128), height: 16)
      let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
      box.zRotation = CGFloat.random(in: 0...3)
      box.position = position
      box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
      box.physicsBody?.isDynamic = false

      return box
    }

    private func makeBouncer(at position: CGPoint) {
      let bouncer = SKSpriteNode(imageNamed: "bouncer")

      bouncer.position = position
      bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
      bouncer.physicsBody?.isDynamic = false

      addChild(bouncer)
    }

    private func makeSlot(at position: CGPoint, isGood: Bool) {
      let slotBase = SKSpriteNode(imageNamed: "slotBase\(isGood ? "Good" : "Bad")")
      slotBase.name = isGood ? "good" : "bad"

      let slotGlow = SKSpriteNode(imageNamed: "slotGlow\(isGood ? "Good" : "Bad")")

      slotBase.position = position
      slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
      slotBase.physicsBody?.isDynamic = false
      slotGlow.position = position

      for slot in [slotBase, slotGlow] {
        addChild(slot)
      }

      let spin = SKAction.rotate(byAngle: .pi, duration: 10)
      let spinForever = SKAction.repeatForever(spin)
      slotGlow.run(spinForever)
    }

    private func collision(between ball: SKNode, obj: SKNode) {
      if obj.name == "good" {
        destroy(ball: ball)
        score += 1
      } else if obj.name == "bad" {
        destroy(ball: ball)
        score -= 1
      }
    }

    private func destroy(ball: SKNode){
      if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
        fireParticles.position = ball.position
        addChild(fireParticles)
      }

      ball.removeFromParent()
    }

    func didBegin(_ contact: SKPhysicsContact) {
      guard let nodeA = contact.bodyA.node else {
        return
      }

      guard let nodeB = contact.bodyB.node else {
        return
      }

      if nodeA.name == "ball" {
        collision(between: nodeA, obj: nodeB)
      } else if nodeB.name == "ball" {
        collision(between: nodeB, obj: nodeA)
      }
    }
}
