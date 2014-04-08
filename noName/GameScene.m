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
const uint32_t ATTACK = 0x1 << 8;

@implementation GameScene{
    int width;
    int height;
    int counter;
    int stages;
}

-(void)didMoveToView:(SKView *)view{
    counter = 60;
    stages = 1;
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
    myWorld.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(-width/2, -height/2) toPoint:CGPointMake(width/2, -height/2)];
    
    camera = [SKNode node];
    camera.name = @"camera";
    [myWorld addChild:camera];
    
    [camera addChild:[self background1]];
    [camera addChild:[self background2]];
    [camera addChild:[self createCharacter]];
    
    [camera addChild:[self platformGG]];
    [camera addChild:[self platformGG2]];
    [self addChild:[self createRightButton]];
    [self addChild:[self createLeftButton]];
    [self addChild:[self createAttackButton]];
    [self addChild:[self creatAtackButton2]];
    [self addChild:[self createDefenseButton]];
    
    
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
    CGSize hue = CGSizeMake(spartan.size.width-15, spartan.size.height-15);
    spartan.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hue];
    spartan.name = @"spartan";
    spartan.zPosition = 1;
    spartan.physicsBody.categoryBitMask = SPARTAN;
    spartan.physicsBody.collisionBitMask = SPARTAN | ROCK | ENEMY;
    spartan.physicsBody.contactTestBitMask = ROCK | ENEMY;
    
    return spartan;
}

-(SKSpriteNode *)background1{
    SKTexture *fundoTexture = [SKTexture textureWithImageNamed:@"prebackground1.png"];
    fundo = [[SKSpriteNode alloc] initWithTexture:fundoTexture color:nil size:CGSizeMake(self.scene.size.width, self.scene.size.height)];
    fundo.anchorPoint = CGPointMake (0.5,0.5);
    return fundo;
}

-(SKSpriteNode *)background2{
    SKTexture *fundoTexture = [SKTexture textureWithImageNamed:@"prebackground2.png"];
    fundo2 = [[SKSpriteNode alloc] initWithTexture:fundoTexture color:nil size:CGSizeMake(self.scene.size.width, self.scene.size.height)];
    fundo2.anchorPoint = CGPointMake (0.5,0.5);
    fundo2.position = CGPointMake(fundo.position.x+fundo2.size.width, fundo.position.y);
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
    platform = [[SKSpriteNode alloc] initWithTexture:ground color:[SKColor blackColor] size:CGSizeMake(width, height/7)];
    platform.name = @"platform";
    platform.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:platform.size];
    platform.physicsBody.dynamic = NO;
    platform.physicsBody.categoryBitMask = ROCK;
    platform.physicsBody.collisionBitMask = SPARTAN | BIRIBINHA | ROCK | ENEMY;
    platform.physicsBody.contactTestBitMask = SPARTAN;
    platform.position = CGPointMake(0, -height/2+(platform.size.height/2));
    
    return platform;
}

-(SKSpriteNode *)platformGG2{
    SKTexture *ground = [SKTexture textureWithImageNamed:@"Ground.png"];
    platform2 = [[SKSpriteNode alloc] initWithTexture:ground color:[SKColor blackColor] size:CGSizeMake(width, height/7)];
    platform2.name = @"platform2";
    platform2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:platform2.size];
    platform2.physicsBody.dynamic = NO;
    platform2.physicsBody.categoryBitMask = ROCK;
    platform2.physicsBody.collisionBitMask = SPARTAN | BIRIBINHA | ROCK | ENEMY;
    platform2.physicsBody.contactTestBitMask = SPARTAN;
    platform2.position = CGPointMake(platform.position.x+platform.size.width, -height/2+(platform2.size.height/2));
    
    return platform2;
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

-(SKSpriteNode *)createDefenseButton{
    defense = [[SKSpriteNode alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(width*0.08,width*0.08)];
    defense.name = @"defense";
    defense.position = CGPointMake(attack2.position.x-attack2.size.width-attack2.size.width/2,-(height*0.5)+(defense.size.height/2));
    
    return defense;
}

-(SKSpriteNode *)creatorBlock{
    SKSpriteNode *block = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(width*0.08, height*0.08)];
    block.name = @"enemy";
    block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block.size];
    block.physicsBody.categoryBitMask = ENEMY;
    block.physicsBody.collisionBitMask = SPARTAN | ROCK;
    block.physicsBody.contactTestBitMask = SPARTAN | BIRIBINHA | ROCK | ATTACK;
    block.position = CGPointMake(width/3, height/3);
    block.zPosition = 1;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"ENEMY_LEFT.atlas"];
    SKTexture *enemyLT = [atlas textureNamed:@"inimigo1_03_L_parado.png"];
    block.texture = enemyLT;
    
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

-(void)attackActionRight{
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"SPEAR"];
    SKTexture *spear = [atlas textureNamed:@"spearToRight.png"];
    attackRegion = [[SKSpriteNode alloc] initWithTexture:spear];
    attackRegion.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(spartan.size.width*2, spartan.size.height*2)];
    attackRegion.position = CGPointMake(spartan.position.x+spartan.size.width/2, spartan.position.y);
    attackRegion.name = @"attack";
    [camera addChild:attackRegion];
    attackRegion.zPosition = 1;
    projectile.physicsBody.categoryBitMask = ATTACK;
    projectile.physicsBody.collisionBitMask = ATTACK | ROCK;
    projectile.physicsBody.contactTestBitMask = ROCK;
    
}

-(void)attackActionLeft{
    
}


- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    NSLog(@"toq");
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    for (UITouch *touch in touches) {
//        CGPoint touchLocation = [touch locationInNode:self];
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
            
            [spartan runAction:[SKAction repeatActionForever:moveRight ] withKey:@"WalkRAction1"];
            [spartan runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:monsterWalkTextures timePerFrame:0.1f]] withKey:@"WalkRAction2"];
            
        }
        else if ([node.name isEqualToString:@"Attack2"]){
            if (esquerda) {
                SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"SPEARLAUNCH"];
                SKTexture *f1 = [atlas textureNamed:@"lancandoSpear-LEFT.png"];
                NSArray *spartanAttackTextures = @[f1];
                [self throwBiribinhaLeft];
                if (lancas>0)
                [spartan runAction:[SKAction animateWithTextures:spartanAttackTextures timePerFrame:0.01f]withKey:@"AttackLAction2"];
                else attack2.color = [UIColor grayColor];
            }
            else{
                SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"SPEARLAUNCH"];
                SKTexture *f1 = [atlas textureNamed:@"lancandoSpear-RIGHT.png"];
                NSArray *spartanAttackTextures = @[f1];
                [self throwBiribinhaRight];
                if (lancas>0)
                [spartan runAction:[SKAction animateWithTextures:spartanAttackTextures timePerFrame:0.01f]withKey:@"AttackRAction2"];
                else attack2.color = [UIColor grayColor];
            }
        }
        
        
        
        else if ([node.name isEqualToString:@"Attack"]) {
            if(esquerda)
            {
                SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"ATTACK_LEFT"];
                SKTexture *f1 = [atlas textureNamed:@"ATTACK_LEFT_001.png"];
                SKTexture *f2 = [atlas textureNamed:@"ATTACK_LEFT_002.png"];
                NSArray *spartanAttackTextures = @[f1, f2];
               // [self throwBiribinhaLeft];
                    [spartan runAction:[SKAction animateWithTextures:spartanAttackTextures timePerFrame:0.01f]withKey:@"AttackLAction1"];
                
            }
            else{
                SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"ATACK_RIGHT"];
                SKTexture *f1 = [atlas textureNamed:@"ATTACK_RIGHT_001.png"];
                SKTexture *f2 = [atlas textureNamed:@"ATTACK_RIGHT_002.png"];
                NSArray *spartanAttackTextures = @[f1, f2];
                
                [self attackActionRight];
                    [spartan runAction:[SKAction animateWithTextures:spartanAttackTextures timePerFrame:0.01f]withKey:@"AttackRAction1"];
                
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
            [spartan runAction:[SKAction repeatActionForever:moveLeft]withKey:@"WalkLAction1"];
            [spartan runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:spartanMoveLeft timePerFrame:0.1f]]withKey:@"WalkLAction2"];
        }
        else if([node.name isEqualToString:@"defense"]){
            if (esquerda) {
                SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"SPARTAN_DEF"];
                SKTexture *f1 = [atlas textureNamed:@"DEF_LEFT.png"];
                NSArray *spartanDefenseRight = @[f1];
                [spartan runAction:[SKAction animateWithTextures:spartanDefenseRight timePerFrame:0.01f]withKey:@"DefenseLAction1"];
                defendendo = YES;
                
            }
            else{
                SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"SPARTAN_DEF"];
                SKTexture *f1 = [atlas textureNamed:@"DEF_RIGHT.png"];
                NSArray *spartanDefenseLeft = @[f1];
                [spartan runAction:[SKAction animateWithTextures:spartanDefenseLeft timePerFrame:0.01f]withKey:@"DefenseRAction1"];
                defendendo = YES;
                
            }
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
    if(camera.position.x <= -width*stages){
        if(stages%2!=0){
            platform.position = CGPointMake(platform2.position.x+platform.size.width, platform.position.y);
            fundo.position = CGPointMake(fundo2.position.x+fundo.size.width, fundo.position.y);
        }
        else{
            platform2.position = CGPointMake(platform.position.x+platform.size.width, platform.position.y);
            fundo2.position = CGPointMake(fundo.position.x+fundo.size.width, fundo.position.y);
        }
        stages++;
    }
//    NSLog(@"%f",camera.position.x);
}

//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//
//    for (UITouch *touch in touches) {
//        
//        float halfWidth = self.size.width / 2.0;
//        CGPoint touchLocation = [touch locationInNode:self];
//        
//        //get previous touch and convert it to node space
//        CGPoint previousTouchLocation = [touch previousLocationInNode:self];
//        
//        if (touchLocation.x > halfWidth && previousTouchLocation.x <= halfWidth) {
//            [self attackActionRight];
//    
//        } else if (previousTouchLocation.x > halfWidth && touchLocation.x <= halfWidth) {
//            [self attackActionLeft];
//            
//        }
//    }
//}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
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
    defendendo = NO;
    
    if([node.name isEqualToString:@"defense"]){
        if (esquerda) {
            [spartan removeActionForKey:@"DefenseLAction1"];
        }
       else [spartan removeActionForKey:@"DefenseRAction1"];
    }
    
    else if([node.name isEqualToString:@"left"]){
        if (esquerda) {
            [spartan removeActionForKey:@"WalkLAction1"];
            [spartan removeActionForKey:@"WalkLAction2"];
        }
    }
    
    else if([node.name isEqualToString:@"right"]){
        [spartan removeActionForKey:@"WalkRAction1"];
        [spartan removeActionForKey:@"WalkRAction2"];
    }
    
    else if([node.name isEqualToString:@"Attack"]){
        if (esquerda) {
            [spartan removeActionForKey:@"AttackLAction1"];
        }
        else [spartan removeActionForKey:@"AttackRAction1"];}
    
    else if([node.name isEqualToString:@"Attack2"]){
        if (esquerda) {
            [spartan removeActionForKey:@"AttackLAction2"];
        }
       else [spartan removeActionForKey:@"AttackRAction2"];}
}
-(void)update:(NSTimeInterval)currentTime{
    lancasCount.text = [NSString stringWithFormat:@"%@ %ld",aux, (long)lancas];
    counter--;
    if(counter == 0){
        [camera addChild:[self creatorBlock]];
        counter = 60;
    }
}
-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"body A %@",contact.bodyA.node.name);
    NSLog(@"body B %@",contact.bodyB.node.name);
    if(([contact.bodyA.node.name isEqualToString:@"enemy"] && [contact.bodyB.node.name isEqualToString:@"spear"]) || ([contact.bodyA.node.name isEqualToString:@"enemy"] && [contact.bodyB.node.name isEqualToString:@"attack"])){
        [contact.bodyA.node removeFromParent];
    }
    if(([contact.bodyB.node.name isEqualToString:@"enemy"] && [contact.bodyA.node.name isEqualToString:@"spear"]) || ([contact.bodyB.node.name isEqualToString:@"enemy"] && [contact.bodyA.node.name isEqualToString:@"attack"])){
        [contact.bodyB.node removeFromParent];
    }
    if([contact.bodyB.node.name isEqualToString:@"spear"] || [contact.bodyB.node.name isEqualToString:@"attack"]){
        [contact.bodyB.node removeFromParent];
    }
    if([contact.bodyA.node.name isEqualToString:@"spear"] || [contact.bodyA.node.name isEqualToString:@"attack"]){
        [contact.bodyA.node removeFromParent];
    }
    
}

@end
