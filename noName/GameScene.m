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
    [self touchesEnded:nil withEvent:nil];
    
    SKNode *myWorld = [SKNode node];
    [self addChild:myWorld];
    
    myWorld.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    SKNode *camera = [SKNode node];
    camera.name = @"camera";
    [myWorld addChild:camera];
    
    [camera addChild:[self initializeBackground]];
    [camera addChild:[self createCharacter]];
    
    [myWorld addChild:[self platformGG]];
    [self addChild:[self createRightButton]];
    [self addChild:[self createLeftButton]];
    
    self.physicsWorld.gravity = CGVectorMake(0.0f, -1.0f);
}

-(SKSpriteNode *)createCharacter{
    spartan = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(width*0.08, height*0.08)];
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"WALK_RIGHT"];
    SKTexture *parado = [atlas textureNamed:@"WALK_RIGHT_006_.png"];
    spartan.texture = parado;
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
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x-width/4,                                       node.parent.position.y);
}

-(SKSpriteNode *)createRightButton{
    right = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(width*0.06, width*0.06)];
    right.name = @"right";
    right.position = CGPointMake(width/8-width/2, right.size.height/2-height/2);
    
    return right;
}

-(SKSpriteNode *)createLeftButton{
    left = [[SKSpriteNode alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(width*0.06, width*0.06)];
    left.name = @"left";
    left.position = CGPointMake(left.size.width/2-width/2, left.size.height/2-height/2);
    
    return left;
}

-(SKSpriteNode *)platformGG{
    SKSpriteNode *platform = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(width, height/7)];
    platform.name = @"platform";
    platform.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:platform.size];
    platform.physicsBody.dynamic = NO;
    platform.position = CGPointMake(0, -height/2+(platform.size.height/2));
    
    return platform;
}



- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if([node.name isEqualToString:(@"right")]){
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"WALK_RIGHT"];
       SKTexture *f1 = [atlas textureNamed:@"WALK_RIGHT_000_.png"];
        SKTexture *f2 = [atlas textureNamed:@"WALK_RIGHT_001_.png"];
        SKTexture *f3 = [atlas textureNamed:@"WALK_RIGHT_002_.png"];
        SKTexture *f4 = [atlas textureNamed:@"WALK_RIGHT_003_.png"];
        SKTexture *f5 = [atlas textureNamed:@"WALK_RIGHT_004_.png"];
        SKTexture *f6 = [atlas textureNamed:@"WALK_RIGHT_005_.png"];
        SKTexture *f7 = [atlas textureNamed:@"WALK_RIGHT_006_.png"];
        NSArray *monsterWalkTextures = @[f2,f3,f4,f5,f6,f7];
        SKAction *moveRight = [SKAction moveByX:8.5 y:0 duration:0.1];
        
        [spartan runAction:[SKAction repeatActionForever:moveRight]];
        [spartan runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:monsterWalkTextures timePerFrame:0.1f]]];
    }

    if ([node.name isEqualToString:@"Attack"]) {
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"ATACK_RIGHT"];
        SKTexture *f1 = [atlas textureNamed:@"ATTACK_RIGHT_001.png"];
        SKTexture *f2 = [atlas textureNamed:@"ATTACK_RIGHT_002.png"];

        NSArray *spartanAttackTextures = @[f1,f2];

        [spartan runAction:[SKAction animateWithTextures:spartanAttackTextures timePerFrame:0.1f]];
    }
    if ([node.name isEqualToString:@"left"]) {
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"WALK_LEFT"];
        SKTexture *f1 = [atlas textureNamed:@"WAlk_LEFT_001-TEST1.png"];
        SKTexture *f2 = [atlas textureNamed:@"WAlk_LEFT_001-TEST2.png"];
        NSArray *spartanMoveLeft = @[f1];
        SKAction *moveLeft = [SKAction moveByX:-8.5 y:0 duration:0.1];
        [spartan runAction:[SKAction repeatActionForever:moveLeft]];
        [left runAction:[SKAction repeatActionForever:moveLeft]];
        [right runAction:[SKAction repeatActionForever:moveLeft]];
        [spartan runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:spartanMoveLeft timePerFrame:0.1f]]];
    }
}

    
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
        
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"WALK_RIGHT"];
    SKTexture *parado = [atlas textureNamed:@"WALK_RIGHT_006_.png"];
    spartan.texture = parado;
    
    [spartan removeAllActions];
}

@end
