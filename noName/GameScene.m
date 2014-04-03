//
//  GameScene.m
//  noName
//
//  Created by Guilherme Castro on 31/03/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "GameScene.h"

const uint32_t SPARTAN = 0x1 << 0;
const uint32_t BIRIBINHA = 0x1 << 1;
const uint32_t ROCK = 0x1 << 2;
const uint32_t ENEMY = 0x1 << 4;

@implementation GameScene{
    int width;
    int height;
    int counter;
}

-(void)didMoveToView:(SKView *)view{
    counter = 60;
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
    
    camera = [SKNode node];
    camera.name = @"camera";
    [myWorld addChild:camera];
    
    [myWorld addChild:[self initializeBackground]];
    [camera addChild:[self createCharacter]];
    
    [myWorld addChild:[self platformGG]];
    [self addChild:[self createRightButton]];
    [self addChild:[self createLeftButton]];
    [self addChild:[self createAttackButton]];
    [self addChild:[self creatAtackButton2]];
    
    self.physicsWorld.gravity = CGVectorMake(0.0f, -1.0f);
    
    lancasCount = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    aux = @"Lanças:";
    lancas = 5;
    lancasCount.text = [NSString stringWithFormat:@"%@,%ld",aux,(long)lancas];
    lancasCount.position = CGPointMake(0, height/3);
    lancasCount.fontSize = 20;
    lancasCount.fontColor = [UIColor whiteColor];
    [self addChild:lancasCount];
}

-(SKSpriteNode *)createCharacter{
    spartan = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(width*0.08, height*0.08)];
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"WALK_RIGHT"];
    SKTexture *parado = [atlas textureNamed:@"WALK_RIGHT_006_.png"];
    spartan.texture = parado;
    CGSize hue = CGSizeMake(spartan.size.width, spartan.size.height-15);
    spartan.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hue];
    spartan.name = @"spartan";
    spartan.zPosition = 1;
    spartan.physicsBody.categoryBitMask = SPARTAN;
    spartan.physicsBody.collisionBitMask = SPARTAN | ROCK | ENEMY;
    spartan.physicsBody.contactTestBitMask = ROCK | ENEMY;
    
    return spartan;
}

-(SKSpriteNode *)initializeBackground{
    SKTexture *fundo = [SKTexture textureWithImageNamed:@"grecia.png"];
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
    right = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(width*0.08, width*0.08)];
    right.name = @"right";
    right.position = CGPointMake(width/8-width/2, right.size.height/2-height/2);
    
    return right;
}

-(SKSpriteNode *)createLeftButton{
    left = [[SKSpriteNode alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(width*0.08, width*0.08)];
    left.name = @"left";
    left.position = CGPointMake(left.size.width/2-width/2, left.size.height/2-height/2);
    
    return left;
}

-(SKSpriteNode *)platformGG{
    SKTexture *ground = [SKTexture textureWithImageNamed:@"Ground.png"];
    SKSpriteNode *platform = [[SKSpriteNode alloc] initWithTexture:ground color:[SKColor blackColor] size:CGSizeMake(width, height/7)];
    platform.name = @"platform";
    platform.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:platform.size];
    platform.physicsBody.dynamic = NO;
    platform.physicsBody.categoryBitMask = ROCK;
    platform.physicsBody.collisionBitMask = SPARTAN | BIRIBINHA | ROCK | ENEMY;
    platform.physicsBody.contactTestBitMask = SPARTAN;
    platform.position = CGPointMake(0, -height/2+(platform.size.height/2));
    
    return platform;
}

-(SKSpriteNode *)creatAtackButton2{
    attack2 = [[SKSpriteNode alloc] initWithColor:[UIColor orangeColor]size:CGSizeMake(width*0.08, width*0.08)];
    attack2.name = @"Attack2";
    attack2.position = CGPointMake(attack.position.x-attack.size.width-attack.size.width/2,-(height*0.5)+(attack2.size.height/2));
    return attack2;
}
    
-(SKSpriteNode *)createAttackButton{
    attack = [[SKSpriteNode alloc] initWithColor:[UIColor redColor]size:CGSizeMake(width*0.08, width*0.08)];
    attack.name = @"Attack";
    attack.position = CGPointMake(width*0.5-(attack.size.width/2),-(height*0.5)+(attack.size.height/2));
    return attack;
}

-(SKSpriteNode *)creatorBlock{
    SKSpriteNode *block = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(width/7, height/7)];
    block.name = @"enemy";
    block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block.size];
    block.physicsBody.categoryBitMask = ENEMY;
    block.physicsBody.collisionBitMask = SPARTAN | ROCK;
    block.physicsBody.contactTestBitMask = SPARTAN | BIRIBINHA | ROCK;
    block.position = CGPointMake(width/3, height/3);
    block.zPosition = 1;
    
    return block;
}

-(void)throwBiribinhaRight{
    if(lancas>0){
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"SPEAR"];
        SKTexture *spear = [atlas textureNamed:@"spearToRight.png"];
        projectile = [[SKSpriteNode alloc] initWithTexture:spear];
        projectile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:projectile.size];
        projectile.position = spartan.position;
        projectile.name = @"spear";
        [camera addChild:projectile];
        projectile.zPosition = 1;
        projectile.physicsBody.categoryBitMask = BIRIBINHA;
        projectile.physicsBody.collisionBitMask = BIRIBINHA | ROCK;
        projectile.physicsBody.contactTestBitMask = ROCK;
        [projectile.physicsBody applyImpulse:CGVectorMake(10, 0)];
        lancas--;
    }
    else
        lancasCount.fontColor = [UIColor redColor];
}

-(void)throwBiribinhaLeft{
    if(lancas>0){
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"SPEAR"];
        SKTexture *spear = [atlas textureNamed:@"spearToLeft.png"];
        projectile = [[SKSpriteNode alloc] initWithTexture:spear];
        projectile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:projectile.size];
        projectile.position = spartan.position;
        projectile.name = @"spear";
        [camera addChild:projectile];
        projectile.zPosition = 1;
        projectile.physicsBody.categoryBitMask = BIRIBINHA;
        projectile.physicsBody.collisionBitMask = BIRIBINHA | ROCK;
        projectile.physicsBody.contactTestBitMask = ROCK;
        [projectile.physicsBody applyImpulse:CGVectorMake(-10, 0)];
        lancas--;
    }
    else
        lancasCount.fontColor = [UIColor redColor];
}


- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    NSLog(@"toq");
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self];
        if([node.name isEqualToString:(@"right")]){
            esquerda = NO;
            SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"WALK_RIGHT"];
            //        SKTexture *f1 = [atlas textureNamed:@"WALK_RIGHT_000_.png"];
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
        else if ([node.name isEqualToString:@"Attack2"]){
            if (esquerda) {
                SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"SPEARLAUNCH"];
                SKTexture *f1 = [atlas textureNamed:@"lancandoSpear-LEFT.pbg"];
                NSArray *spartanAttackTextures = @[f1];
                [self throwBiribinhaLeft];
                [spartan runAction:[SKAction animateWithTextures:spartanAttackTextures timePerFrame:0.01f]];
            }
        }
        
        
        else if ([node.name isEqualToString:@"Attack"]) {
            if(esquerda)
            {
                SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"ATTACK_LEFT"];
                SKTexture *f1 = [atlas textureNamed:@"ATTACK_LEFT_001.png"];
                SKTexture *f2 = [atlas textureNamed:@"ATTACK_LEFT_002.png"];
                NSArray *spartanAttackTextures = @[f1, f2];
                
                [self throwBiribinhaLeft];
                [spartan runAction:[SKAction animateWithTextures:spartanAttackTextures timePerFrame:0.01f]];
                
            }
            else{
                SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"ATACK_RIGHT"];
                SKTexture *f1 = [atlas textureNamed:@"ATTACK_RIGHT_001.png"];
                SKTexture *f2 = [atlas textureNamed:@"ATTACK_RIGHT_002.png"];
                NSArray *spartanAttackTextures = @[f1, f2];
                
                [self throwBiribinhaRight];
                [spartan runAction:[SKAction animateWithTextures:spartanAttackTextures timePerFrame:0.01f]];
            }
            
            
        }
        
        else if ([node.name isEqualToString:@"left"]) {
            esquerda = YES;
            SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"WALK_LEFT"];
            SKTexture *f1 = [atlas textureNamed:@"WALK_LEFT_001.png"];
            SKTexture *f2 = [atlas textureNamed:@"WALK_LEFT_002.png"];
            SKTexture *f3 = [atlas textureNamed:@"WALK_LEFT_003.png"];
            SKTexture *f4 = [atlas textureNamed:@"WALK_LEFT_004.png"];
            SKTexture *f5 = [atlas textureNamed:@"WALK_LEFT_005.png"];
            SKTexture *f6 = [atlas textureNamed:@"WALK_LEFT_006.png"];
            NSArray *spartanMoveLeft = @[f1,f2,f3,f4,f5,f6];
            SKAction *moveLeft = [SKAction moveByX:-8.5 y:0 duration:0.1];
            [spartan runAction:[SKAction repeatActionForever:moveLeft]];
            [spartan runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:spartanMoveLeft timePerFrame:0.1f]]];
        }
    }
    
}

-(void)update:(NSTimeInterval)currentTime{
    lancasCount.text = [NSString stringWithFormat:@"%@ %ld",aux, (long)lancas];
    counter--;
    if(counter == 0){
        [camera addChild:[self creatorBlock]];
        counter = 60;
    }
}

    
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (esquerda) {
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"WALK_LEFT"];
        SKTexture *parado = [atlas textureNamed:@"WALK_LEFT_006.png"];
        spartan.texture = parado;
    }
    else{
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"WALK_RIGHT"];
    SKTexture *parado = [atlas textureNamed:@"WALK_RIGHT_006_.png"];
    spartan.texture = parado;
    }
    
    [spartan removeAllActions];
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"body A %@",contact.bodyA.node.name);
    NSLog(@"body B %@",contact.bodyB.node.name);
    if([contact.bodyA.node.name isEqualToString:@"enemy"] && [contact.bodyB.node.name isEqualToString:@"spear"]){
        [contact.bodyA.node removeFromParent];
    }
    if([contact.bodyB.node.name isEqualToString:@"enemy"] && [contact.bodyA.node.name isEqualToString:@"spear"]){
        [contact.bodyB.node removeFromParent];
    }
    if([contact.bodyB.node.name isEqualToString:@"spear"]){
        [contact.bodyB.node removeFromParent];
    }
    if([contact.bodyA.node.name isEqualToString:@"spear"]){
        [contact.bodyA.node removeFromParent];
    }
    
}

@end
