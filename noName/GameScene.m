//
//  GameScene.m
//  noName
//
//  Created by Guilherme Castro on 31/03/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene{
    int width;
    int height;
}

-(void)didMoveToView:(SKView *)view{
    width = self.scene.size.width;
    height = self.scene.size.height;
    
    self.physicsWorld.contactDelegate = (id)self;
    self.backgroundColor = [SKColor redColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.anchorPoint = CGPointMake (0.5,0.5);
    
    SKNode *myWorld = [SKNode node];
    [self addChild:myWorld];
    
    myWorld.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    SKNode *camera = [SKNode node];
    camera.name = @"camera";
    [myWorld addChild:camera];
    
    [camera addChild:[self createCharacter]];
    [camera addChild:[self initializeBackground]];
    [camera addChild:[self createRightButton]];
    [camera addChild:[self createLeftButton]];
    
    self.physicsWorld.gravity = CGVectorMake(0.0f, -1.0f);
}

-(SKSpriteNode *)createCharacter{
    SKSpriteNode *spartan = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(width*0.05, height*0.05)];
    spartan.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spartan.size];
    spartan.name = @"spartan";
//    spartan.position = CGPointMake(200, 200);
    spartan.zPosition = 1;
    
    return spartan;
}

-(SKSpriteNode *)initializeBackground{
    SKTexture *fundo = [SKTexture textureWithImageNamed:@"grecia.jpg"];
    SKSpriteNode *fundo2 = [[SKSpriteNode alloc] initWithTexture:fundo color:nil size:CGSizeMake(self.scene.size.width, self.scene.size.height)];
    fundo2.anchorPoint = CGPointMake (0.5,0.5);
    return fundo2;
}


- (void)didSimulatePhysics{
    [self centerOnNode: [self childNodeWithName: @"//spartan"]];
}

- (void) centerOnNode: (SKNode *) node{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x,                                       node.parent.position.y);
}

-(SKSpriteNode *)createRightButton{
    SKSpriteNode *right = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(width*0.06, width*0.06)];
    right.name = @"right";
    right.position = CGPointMake(width/8-width/2, right.size.height/2-height/2);
    
    return right;
}

-(SKSpriteNode *)createLeftButton{
    SKSpriteNode *left = [[SKSpriteNode alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(width*0.06, width*0.06)];
    left.name = @"left";
    left.position = CGPointMake(left.size.width/2-width/2, left.size.height/2-height/2);
    
    return left;
}



- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    SKNode *spartan = [self childNodeWithName:@"//spartan"];
    SKNode *right = [self childNodeWithName:@"//right"];
    SKNode *left = [self childNodeWithName:@"//left"];
    spartan.position = CGPointMake(spartan.position.x + 100, spartan.position.y);
    left.position = CGPointMake(left.position.x + 100, left.position.y);
    right.position = CGPointMake(right.position.x + 100, right.position.y);
}

@end
