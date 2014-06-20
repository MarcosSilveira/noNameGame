//
//  GameScene.m
//  noName
//
//  Created by Guilherme Castro on 31/03/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"
@import AVFoundation;

const uint32_t ROCK = 0x1 << 0;
const uint32_t SPARTAN = 0x1 << 1;
const uint32_t ENEMY = 0x1 << 2;
const uint32_t BIRIBINHA = 0x1 << 3;
const uint32_t ATTACK = 0x1 << 4;
const uint32_t LOOT = 0x1 << 5;
const uint32_t BOSS = 0x1 << 6;
const uint32_t BOSSBIRIBINHA = 0x1 << 7;
const uint32_t ENEMY2 = 0x1 << 8;


@implementation GameScene{
    int width;
    int height;
    AVAudioPlayer * backgroundMusicPlayer;
    int counter;
    int counter2;
    int counter3;
    int attackCool;
    int stages;
    int score;
    NSString *currentButton;
    int HP;
    SKTexture *texturaAux;
    SKEmitterNode *Fire;
    BOOL noLanca;
    BOOL specialEsquerda;
    BOOL bossAux;
    BOOL bossMovendo;
    int bossHP;
    int bossAttack;
}

#pragma mark - Move to View

-(void)didMoveToView:(SKView *)view{
    
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"back" withExtension:@"mp3"];
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    backgroundMusicPlayer.numberOfLoops = -1;
    [backgroundMusicPlayer prepareToPlay];
    [backgroundMusicPlayer play];
    attackCool = 15;
    counter = 120;
    counter2 = 240;
    counter3 = 120;
    stages = 1;
    width = self.scene.size.width;
    height = self.scene.size.height;
    currentButton = @"";
    HP = 5;
    score = 0;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"especialReady"])
        FOGAREU = YES;
    else
    FOGAREU = NO;
    specialAux = 0;
    bossAux = NO;
    bossHP = 10;
    bossAttack = 0;
    atlas = [SKTextureAtlas atlasNamed:@"SPARTAN"];
    
    self.physicsWorld.contactDelegate = (id)self;
    self.backgroundColor = [SKColor redColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.anchorPoint = CGPointMake (0.5,0.5);
    self.physicsWorld.gravity = CGVectorMake(0.0f, -1.0f);
    [self touchesEnded:nil withEvent:nil];
    mainAtlas = [SKTextureAtlas atlasNamed:@"SPARTAN.atlas"];
    walkFrames = [NSMutableArray array];
    for(int i = 1; i <= 6; i++){
        NSString *textureName = [NSString stringWithFormat:@"wl%d", i];
        SKTexture *temp = [mainAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    myWorld = [SKNode node];
    
    [self addChild:myWorld];
    [self background3];
    
    myWorld.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    myWorld.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(-width/2, -height/2) toPoint:CGPointMake(width/2, -height/2)];
    
    camera = [SKNode node];
    camera.name = @"camera";
    
    [myWorld addChild:camera];
    
    [self addChild:[self background1]];
    [self addChild:[self background2]];
    [camera addChild:[self platformGG]];
    [camera addChild:[self platformGG2]];
    [camera addChild:[self createCharacter]];
    spartanTexture.xScale = -1.0;
    
    [self addChild:[self createRightButton]];
    [self addChild:[self createLeftButton]];
    [self addChild:[self createAttackButton]];
    [self addChild:[self creatAtackButton2]];
    [self addChild:[self createDefenseButton]];
    [self addChild:[self createSpecialButton]];
    
    lancasNode = [[SKSpriteNode alloc] initWithImageNamed:@"lanca_contador.png"];
    lancasNode.size = CGSizeMake(width*0.15, width*0.15);
    lancasNode.position = CGPointMake(width/2-lancasNode.size.width/2, height/2-lancasNode.size.height/2);
    [self addChild:lancasNode];
    
    pause = [[SKSpriteNode alloc] initWithImageNamed:@"pause.png"];
    pause.position = CGPointMake(-width/2+pause.size.width/2, height/2-lancasNode.size.height/2);
    pause.size = CGSizeMake(width*0.06, width*0.06);
    pause.name = @"PauseButton";
    [self addChild:pause];
    
    lancasCount = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    aux = @"Lanças:";
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"10lancas"]) {
        lancas = 10;
    }
    else
    lancas = 5;
    lancasCount.text = [NSString stringWithFormat:@"%ld",(long)lancas];
    lancasCount.position = CGPointMake(width/2-lancasNode.size.width/2+lancasNode.size.width*0.2, height/3+lancasNode.size.width*0.072);
    lancasCount.fontSize = 20;
    lancasCount.fontColor = [UIColor whiteColor];
    [self addChild:lancasCount];
    
    pontosCount = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    auxPontos = @"Lanças:";
    pontosCount.text = [NSString stringWithFormat:@"%ld",(long)score];
    pontosCount.position = CGPointMake(0,(height*3)/9);
    pontosCount.fontSize = 20;
    pontosCount.fontColor = [UIColor whiteColor];
    [self addChild:pontosCount];
    
    texturaAux = [atlas textureNamed:@"heart5.png"];
    vidas = [[SKSpriteNode alloc] initWithTexture:texturaAux color:nil size:CGSizeMake(width*0.17, height*0.06)];
    vidas.position = CGPointMake(0, lancasCount.position.y+height*0.05);
    [self addChild:vidas];
}

#pragma mark - Create Particles

- (SKEmitterNode *) newFire: (float)posX : (float) posY
{
    SKEmitterNode *emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Fire" ofType:@"sks"]];
    emitter.position = CGPointMake(posX,posY);
    emitter.name = @"explosion";
    emitter.targetNode = self.scene;
    emitter.numParticlesToEmit = 1000;
    emitter.zPosition=2.0;
    return emitter;
}


#pragma mark - Create Sparta

-(SKSpriteNode *)createCharacter{
    spartan = [[SKSpriteNode alloc] initWithColor:[SKColor clearColor] size:CGSizeMake(width*0.08, height*0.08)];
    SKTexture *parado = [atlas textureNamed:@"wl6.png"];
    spartanTexture = [[SKSpriteNode alloc] initWithTexture:parado];
    [spartan addChild:spartanTexture];
    CGSize hue = CGSizeMake(spartan.size.width/2, spartan.size.height);
    spartan.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hue];
    spartan.position = CGPointMake(0, -height/2.15+(platform.size.height));
    spartan.name = @"spartan";
    spartanTexture.size = spartan.size;
    spartan.zPosition = 1;
    spartan.physicsBody.categoryBitMask = SPARTAN;
    spartan.physicsBody.collisionBitMask = ROCK | ENEMY | BOSS;
    spartan.physicsBody.contactTestBitMask = ROCK | ENEMY | LOOT | BOSSBIRIBINHA | ENEMY2;
    
    return spartan;
}

-(SKSpriteNode *)createBoss{
    boss = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(width*0.08, height*0.08)];
    SKTexture *parado = [atlas textureNamed:@"ARCHER1_000.png"];
    boss.texture = parado;
    CGSize hue = CGSizeMake(spartan.size.width/2, spartan.size.height);
    boss.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hue];
    boss.position = CGPointMake(-camera.position.x+width/3, -height/2+(platform.size.height));;
    boss.name = @"boss";
    boss.zPosition = 1;
    boss.physicsBody.categoryBitMask = BOSS;
    boss.physicsBody.collisionBitMask = SPARTAN | ROCK;
    boss.physicsBody.contactTestBitMask = SPARTAN | BIRIBINHA | ROCK | ATTACK;
    
    return boss;
}

#pragma mark - Background / Stage

-(SKSpriteNode *)background1{
    SKTexture *fundoTexture = [SKTexture textureWithImageNamed:@"nuvem1.png"];
    fundo = [[SKSpriteNode alloc] initWithTexture:fundoTexture color:nil size:CGSizeMake(self.scene.size.width, self.scene.size.height)];
    fundo.anchorPoint = CGPointMake (0.5,0.5);
    return fundo;
}

-(SKSpriteNode *)background2{
    SKTexture *fundoTexture = [SKTexture textureWithImageNamed:@"nuvem2.png"];
    fundo2 = [[SKSpriteNode alloc] initWithTexture:fundoTexture color:nil size:CGSizeMake(self.scene.size.width, self.scene.size.height)];
    fundo2.anchorPoint = CGPointMake (0.5,0.5);
    fundo2.position = CGPointMake(fundo.position.x+fundo2.size.width, fundo.position.y);
    return fundo2;
}

-(void)background3{
    SKTexture *fundoTexture = [SKTexture textureWithImageNamed:@"backgroundfixo.png"];
    SKSpriteNode *fundoF = [[SKSpriteNode alloc] initWithTexture:fundoTexture color:nil size:CGSizeMake(self.scene.size.width, self.scene.size.height)];
    fundoF.anchorPoint = CGPointMake (0.5,0.5);
    [self addChild:fundoF];
    fundoF.zPosition = -1;
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

#pragma mark - Buttons

-(SKSpriteNode *)createRightButton{
    right = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(width*0.08, width*0.08)];
    right.name = @"right";
    right.position = CGPointMake(width/8-width/2, right.size.height/2-height/2);
    right.texture = [SKTexture textureWithImageNamed:@"botao_direcao_R.png"];
    
    return right;
}


-(SKSpriteNode *)createLeftButton{
    left = [[SKSpriteNode alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(width*0.08, width*0.08)];
    left.name = @"left";
    left.position = CGPointMake(left.size.width/2-width/2, left.size.height/2-height/2);
    left.texture = [SKTexture textureWithImageNamed:@"botao_direcao_L.png"];
    
    return left;
}


-(SKSpriteNode *)creatAtackButton2{
    attack2 = [[SKSpriteNode alloc] initWithColor:[UIColor orangeColor]size:CGSizeMake(width*0.08, width*0.08)];
    attack2.name = @"Attack2";
    attack2.position = CGPointMake(attack.position.x-attack.size.width-attack.size.width/2,-(height*0.5)+(attack2.size.height/2));
    attack2.texture = [SKTexture textureWithImageNamed:@"botao_atira_lanca_disponivel"];
    
    return attack2;
}

-(SKSpriteNode *)createAttackButton{
    attack = [[SKSpriteNode alloc] initWithColor:[UIColor redColor]size:CGSizeMake(width*0.08, width*0.08)];
    attack.name = @"Attack";
    attack.position = CGPointMake(width*0.5-(attack.size.width/2),-(height*0.5)+(attack.size.height/2));
    attack.texture = [SKTexture textureWithImageNamed:@"botao_lanca.png"];
    
    return attack;
}
-(SKSpriteNode *)createSpecialButton{
    special = [[SKSpriteNode alloc] initWithColor:[UIColor purpleColor] size:CGSizeMake(width*0.08, width*0.08)];
    special.name = @"Special";
    special.position = CGPointMake(attack2.position.x , -(height*0.5)+(defense.size.height/2)+attack.size.height);
    special.texture = [SKTexture textureWithImageNamed:@"special_unavailable.png"];
    return special;
}

-(SKSpriteNode *)createDefenseButton{
    defense = [[SKSpriteNode alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(width*0.08,width*0.08)];
    defense.name = @"defense";
    defense.position = CGPointMake(attack.position.x , -(height*0.5)+(defense.size.height/2)+attack.size.height);
    defense.texture = [SKTexture textureWithImageNamed:@"botao_escudo.png"];
    
    return defense;
}


#pragma mark - Actions

-(void)throwFiremodafockaRight{
    
    especial = [[SKSpriteNode alloc] init];
    especial.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100, 10)];
    especial.position = spartan.position;
    especial.name = @"specialspear";
    Fire = [self newFire:especial.position.x :especial.position.y];
    Fire.position = especial.position;
    [camera addChild:especial];
    [camera addChild:Fire];
    especial.zPosition = 1;
    especial.physicsBody.categoryBitMask = BIRIBINHA;
    especial.physicsBody.collisionBitMask = BIRIBINHA | ROCK;
    especial.physicsBody.contactTestBitMask = ENEMY;
    especial.physicsBody.dynamic=NO;
    specialEsquerda = NO;
}

-(void)throwFiremodafockaLeft{
    
    especial = [[SKSpriteNode alloc] init];
    especial.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100, 10)];
    especial.position = spartan.position;
    especial.name = @"specialspear";
    Fire = [self newFire:especial.position.x :especial.position.y];
    Fire.position = especial.position;
    [camera addChild:especial];
    [camera addChild:Fire];
    especial.zPosition = 1;
    especial.physicsBody.categoryBitMask = BIRIBINHA;
    especial.physicsBody.collisionBitMask = BIRIBINHA | ROCK;
    especial.physicsBody.contactTestBitMask = ENEMY;
    especial.physicsBody.dynamic=NO;
    specialEsquerda = YES;
}

-(void)BossthrowBiribinhaLeft{
        SKTexture *spear = [atlas textureNamed:@"spearToLeft.png"];
        projectile = [[SKSpriteNode alloc] initWithTexture:spear];
        projectile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:projectile.size];
        projectile.position = CGPointMake(boss.position.x, boss.position.y);
        projectile.name = @"Bspear";
        [camera addChild:projectile];
        projectile.zPosition = 1;
        projectile.physicsBody.categoryBitMask = BOSSBIRIBINHA;
        projectile.physicsBody.collisionBitMask = ROCK;
        projectile.physicsBody.contactTestBitMask = SPARTAN | ROCK;
        [projectile.physicsBody applyImpulse:CGVectorMake(-10, 0)];
    
    SKTexture *f1 = [atlas textureNamed:@"ARCHER1_ATACK_001.png"];
    SKTexture *f2 = [atlas textureNamed:@"ARCHER1_ATACK_002.png"];
    NSArray *enemyLeftWalk = @[f1,f2];
    [boss runAction:[SKAction animateWithTextures:enemyLeftWalk timePerFrame:0.1f]completion:^{
        bossAttack++;
    }];
}

-(void)throwBiribinhaRight{
    if(lancas>0){
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
}

-(void)throwBiribinhaLeft{
    if(lancas>0){
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
    attackRegion = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(width*0.04, height*0.05)];
    attackRegion.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(width*0.03, height*0.04)];
    attackRegion.position = CGPointMake(spartan.position.x, spartan.position.y);
    attackRegion.name = @"attack";
    attackRegion.physicsBody.categoryBitMask = ATTACK;
    attackRegion.physicsBody.collisionBitMask = 0;
    attackRegion.physicsBody.contactTestBitMask = ROCK;
    SKAction *moveRight = [SKAction moveByX:attackRegion.size.width y:0 duration:0.1];
    attackRegion.hidden = YES;
    [camera addChild:attackRegion];
    [attackRegion runAction:moveRight completion:^{
        [attackRegion removeFromParent];
    }];
}

-(void)attackActionLeft{
    attackRegion = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(width*0.04, height*0.05)];
    attackRegion.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(width*0.03, height*0.04)];
    attackRegion.position = CGPointMake(spartan.position.x, spartan.position.y);
    attackRegion.name = @"attack";
    attackRegion.physicsBody.categoryBitMask = ATTACK;
    attackRegion.physicsBody.collisionBitMask = 0;
    attackRegion.physicsBody.contactTestBitMask = ROCK;
    SKAction *moveLeft = [SKAction moveByX:-attackRegion.size.width y:0 duration:0.1];
    attackRegion.hidden = YES;
    [camera addChild:attackRegion];
    [attackRegion runAction:moveLeft completion:^{
        [attackRegion removeFromParent];
    }];
}

#pragma mark - Enemy

//Left_____________________________________

-(Enemy *)createEnemyintPosition:(CGPoint)pos{
    enemy.width = width;
    enemy.height = height;
    NSMutableArray *frames = [[NSMutableArray alloc]init];
    for(int i = 1; i <= 10; i++){
        NSString *textureName = [NSString stringWithFormat:@"en%d", i];
        SKTexture *temp = [mainAtlas textureNamed:textureName];
        [frames addObject:temp];
    }
    enemy = [[Enemy alloc]initCreateEnemyWithTexture:frames inPosition:pos];
    
    return enemy;
}

-(SKSpriteNode *)creatorBlockLeft{
    block = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(width*0.08, height*0.08)];
    block.name = @"enemy";
    block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block.size];
    block.physicsBody.categoryBitMask = ENEMY;
    block.physicsBody.collisionBitMask = SPARTAN | ROCK;
    block.physicsBody.contactTestBitMask = SPARTAN | BIRIBINHA | ROCK | ATTACK;
    block.position = CGPointMake(-camera.position.x+width/2, -height/2+(platform.size.height));
    block.zPosition = 1;
    SKTexture *enemyLT = [atlas textureNamed:@"inimigo1_03_L_parado.png"];
    block.texture = enemyLT;
    [self enemyMovingLeft];
    
    return block;
}

-(void)enemyMovingLeft{
    SKAction *moveLeft = [SKAction moveByX:-400 y:0 duration:5];
    SKTexture *f1 = [atlas textureNamed:@"inimigo1_05_L_correndo.png"];
    SKTexture *f2 = [atlas textureNamed:@"inimigo1_06_L_correndo.png"];
    SKTexture *f3 = [atlas textureNamed:@"inimigo1_07_L_correndo.png"];
    SKTexture *f4 = [atlas textureNamed:@"inimigo1_08_L_correndo.png"];
    SKTexture *f5 = [atlas textureNamed:@"inimigo1_09_L_correndo.png"];
    SKTexture *f6 = [atlas textureNamed:@"inimigo1_10_L_correndo.png"];
    NSArray *enemyLeftWalk = @[f1,f2,f3,f4,f5,f6];
    [block runAction:[SKAction repeatActionForever:moveLeft ] withKey:@"EnemyWalkLAction1"];
    [block runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:enemyLeftWalk timePerFrame:0.1f]] withKey:@"EnemyWalkLAction2"];
    [block runAction:moveLeft];
}


-(void)enemyMovingLeftAfterContact:(SKNode*) enemy{
    SKAction *moveLeft = [SKAction moveByX:-400 y:0 duration:5];
    SKTexture *f1 = [atlas textureNamed:@"inimigo1_05_L_correndo.png"];
    SKTexture *f2 = [atlas textureNamed:@"inimigo1_06_L_correndo.png"];
    SKTexture *f3 = [atlas textureNamed:@"inimigo1_07_L_correndo.png"];
    SKTexture *f4 = [atlas textureNamed:@"inimigo1_08_L_correndo.png"];
    SKTexture *f5 = [atlas textureNamed:@"inimigo1_09_L_correndo.png"];
    SKTexture *f6 = [atlas textureNamed:@"inimigo1_10_L_correndo.png"];
    NSArray *enemyLeftWalk = @[f1,f2,f3,f4,f5,f6];
    [enemy runAction:[SKAction repeatActionForever:moveLeft ] withKey:@"EnemyWalkLAction1"];
    [enemy runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:enemyLeftWalk timePerFrame:0.1f]] withKey:@"EnemyWalkLAction2"];
    [enemy runAction:moveLeft];
}

//Right_____________________________________

-(SKSpriteNode *)creatorBlockRight{
    block2 = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(width*0.08, height*0.08)];
    block2.name = @"enemy2";
    block2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block2.size];
    block2.physicsBody.categoryBitMask = ENEMY2;
    block2.physicsBody.collisionBitMask = SPARTAN | ROCK;
    block2.physicsBody.contactTestBitMask = SPARTAN | BIRIBINHA | ROCK | ATTACK;
    block2.position = CGPointMake(-camera.position.x-width/2, -height/2+(platform.size.height));
    block2.zPosition = 1;
    SKTexture *enemyLT = [atlas textureNamed:@"inimigo1_03_R_parado.png"];
    block2.texture = enemyLT;
    [self enemyMovingRight];
    
    return block2;
}

-(void)BossMovingRight{
    if (bossMovendo) {
        
    }
    else{
    
    SKAction *moveRight = [SKAction moveByX:500 y:0 duration:5];
    SKTexture *f1 = [atlas textureNamed:@"ARCHER1_000.png"];
    SKTexture *f2 = [atlas textureNamed:@"ARCHER1_001.png"];
    SKTexture *f3 = [atlas textureNamed:@"ARCHER1_002.png"];
    SKTexture *f4 = [atlas textureNamed:@"ARCHER1_003.png"];
    SKTexture *f5 = [atlas textureNamed:@"ARCHER1_004.png"];
    SKTexture *f6 = [atlas textureNamed:@"ARCHER1_005.png"];
    SKTexture *f7 = [atlas textureNamed:@"ARCHER1_006.png"];
    NSArray *enemyRightWalk = @[f1,f2,f3,f4,f5,f6,f7];
    [boss runAction:[SKAction repeatActionForever:moveRight] withKey:@"BossMovingRight"];
    [boss runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:enemyRightWalk timePerFrame:0.1f]] withKey:@"BossMovingRight2"];
  //  [boss runAction:moveRight];
    }
}

-(void)enemyMovingRight{
    SKAction *moveRight = [SKAction moveByX:400 y:0 duration:5];
    SKTexture *f1 = [atlas textureNamed:@"inimigo1_05_R_correndo.png"];
    SKTexture *f2 = [atlas textureNamed:@"inimigo1_06_R_correndo.png"];
    SKTexture *f3 = [atlas textureNamed:@"inimigo1_07_R_correndo.png"];
    SKTexture *f4 = [atlas textureNamed:@"inimigo1_08_R_correndo.png"];
    SKTexture *f5 = [atlas textureNamed:@"inimigo1_09_R_correndo.png"];
    SKTexture *f6 = [atlas textureNamed:@"inimigo1_10_R_correndo.png"];
    NSArray *enemyRightWalk = @[f1,f2,f3,f4,f5,f6];
    [block2 runAction:[SKAction repeatActionForever:moveRight] withKey:@"EnemyWalkLAction1"];
    [block2 runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:enemyRightWalk timePerFrame:0.1f]] withKey:@"EnemyWalkLAction2"];
    [block2 runAction:moveRight];
}


-(void)enemyMovingRightAfterContact:(SKNode*) enemy{
    SKAction *moveLeft = [SKAction moveByX:400 y:0 duration:5];
    SKTexture *f1 = [atlas textureNamed:@"inimigo1_05_R_correndo.png"];
    SKTexture *f2 = [atlas textureNamed:@"inimigo1_06_R_correndo.png"];
    SKTexture *f3 = [atlas textureNamed:@"inimigo1_07_R_correndo.png"];
    SKTexture *f4 = [atlas textureNamed:@"inimigo1_08_R_correndo.png"];
    SKTexture *f5 = [atlas textureNamed:@"inimigo1_09_R_correndo.png"];
    SKTexture *f6 = [atlas textureNamed:@"inimigo1_10_R_correndo.png"];
    NSArray *enemyLeftWalk = @[f1,f2,f3,f4,f5,f6];
    [enemy runAction:[SKAction repeatActionForever:moveLeft ] withKey:@"EnemyWalkLAction1"];
    [enemy runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:enemyLeftWalk timePerFrame:0.1f]] withKey:@"EnemyWalkLAction2"];
    [enemy runAction:moveLeft];
}


#pragma mark - Touch Control

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //__________________________________________Move Right_______________________________
    
    if([node.name isEqualToString:(@"right")]){
        esquerda = NO;
        spartanTexture.xScale = -1.0;
        SKAction *moveLeft = [SKAction moveByX:8.5 y:0 duration:0.1];
        [spartan runAction:[SKAction repeatActionForever:moveLeft]withKey:@"WalkLAction1"];
        [spartanTexture runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:walkFrames timePerFrame:0.1f]]withKey:@"WalkLAction2"];
        
    }
    
    //__________________________________________Ranged Attack_______________________________
    
    
    else if ([node.name isEqualToString:@"Attack2"]){
        SKTexture *f1 = [atlas textureNamed:@"lancandoSpear-LEFT.png"];
        NSArray *spartanAttackTextures = @[f1];
        if (esquerda) [self throwBiribinhaLeft];
        else [self throwBiribinhaRight];
        if (lancas>0){
            [spartanTexture runAction:[SKAction animateWithTextures:spartanAttackTextures timePerFrame:0.01f]withKey:@"AttackLAction2"];
            [self runAction:[SKAction playSoundFileNamed:@"spearT.wav" waitForCompletion:NO]];
        }
        else attack2.color = [UIColor grayColor];
    }
    else if ([node.name isEqualToString:@"Special"]){
        if(esquerda)
        {
            if (FOGAREU) {
                
                [self throwFiremodafockaLeft];
                FOGAREU = NO;
                specialAux = 0;
            }
            
        }
        else{
            if (FOGAREU) {
                
                [self throwFiremodafockaRight];
                FOGAREU = NO;
                specialAux = 0;
            }
        }
    }
    
    //__________________________________________Pause_______________________________
    
    
    else if ([node.name isEqualToString:@"PauseButton"]) {
        if (self.paused){
            pause.texture = [SKTexture textureWithImageNamed:@"pause.png"];
        }
        else{
            pause.texture = [SKTexture textureWithImageNamed:@"play.png"];
        }
    }
    
    //__________________________________________Move Left_______________________________
    
    
    else if ([node.name isEqualToString:@"left"]) {
        esquerda = YES;
        spartanTexture.xScale = 1.0;
        SKAction *moveLeft = [SKAction moveByX:-8.5 y:0 duration:0.1];
        [spartan runAction:[SKAction repeatActionForever:moveLeft]withKey:@"WalkLAction1"];
        [spartanTexture runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:walkFrames timePerFrame:0.1f]]withKey:@"WalkLAction2"];
    }
    
    //__________________________________________Defense_______________________________
    
    
    else if([node.name isEqualToString:@"defense"]){
//        SKTexture *f1 = [atlas textureNamed:@"def.png"];
        SKTexture *f1 = [atlas textureNamed:@"ATTACK_LEFT_001.png"];
//        NSArray *spartanDefenseRight = @[f1];
//        [spartanTexture runAction:[SKAction animateWithTextures:spartanDefenseRight timePerFrame:0.01f]withKey:@"DefenseLAction1"];
        spartanTexture.texture = f1;
        defendendo = YES;
            
    }
    
    //__________________________________________Melee Attack_______________________________
    
    else if(attackCool <=0){
        if ([node.name isEqualToString:@"Attack"]) {
            SKTexture *parado = [atlas textureNamed:@"WALK_LEFT_006.png"];
            spartanTexture.texture = parado;
            SKTexture *f1 = [atlas textureNamed:@"ATTACK_LEFT_001.png"];
            SKTexture *f2 = [atlas textureNamed:@"ATTACK_LEFT_002.png"];
            NSArray *spartanAttackTextures = @[f1, f2, parado];
            if(esquerda) [self attackActionLeft];
            else [self attackActionRight];
            [self runAction:[SKAction playSoundFileNamed:@"attack.mp3" waitForCompletion:NO]];
            [spartanTexture runAction:[SKAction animateWithTextures:spartanAttackTextures timePerFrame:0.1f] completion:^{
                attackCool = 15;
            }];
        }
    }
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"left"]) {
        [spartan removeAllActions];
        
        esquerda = YES;
        spartanTexture.xScale = 1.0;
        SKAction *moveLeft = [SKAction moveByX:-8.5 y:0 duration:0.1];
        [spartan runAction:[SKAction repeatActionForever:moveLeft]withKey:@"WalkLAction1"];
        [spartanTexture runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:walkFrames timePerFrame:0.1f]]withKey:@"WalkLAction2"];

    }
    
    if([node.name isEqualToString:(@"right")]){
        [spartan removeAllActions];
        
        esquerda = NO;
        spartanTexture.xScale = -1.0;
        SKAction *moveLeft = [SKAction moveByX:8.5 y:0 duration:0.1];
        [spartan runAction:[SKAction repeatActionForever:moveLeft]withKey:@"WalkLAction1"];
        [spartanTexture runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:walkFrames timePerFrame:0.1f]]withKey:@"WalkLAction2"];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    
    if ([node.name isEqualToString:@"PauseButton"]) {
        if (self.paused){
            self.view.paused = NO;
            pause.texture = [SKTexture textureWithImageNamed:@"pause.png"];
        }
        else{
            self.view.paused = YES;
        }
        
    }
    
    if([node.name isEqualToString:@"defense"]){
        [spartanTexture removeActionForKey:@"DefenseLAction1"];
        defendendo = NO;
    }
    
    if([node.name isEqualToString:@"left"]){
        [spartanTexture removeAllActions];
        [spartan removeAllActions];
    }
    
    if([node.name isEqualToString:@"right"]){
        [spartanTexture removeAllActions];
        [spartan removeAllActions];
    }
    
    if(node.name == NULL){
        [spartanTexture removeAllActions];
        [spartan removeAllActions];
        defendendo = NO;
    }
    
    if(!defendendo){
        SKTexture *parado = [atlas textureNamed:@"WALK_LEFT_006.png"];
        spartanTexture.texture = parado;
    }
    
    if([node.name isEqualToString:@"Attack"]){
        return;
    }
    
    if([node.name isEqualToString:@"Attack2"]){
        return;
    }
}


#pragma mark - Update

-(void)update:(NSTimeInterval)currentTime{
    
    //--------BOSS--------//
    if(stages>1 && bossAux==NO){
        [camera addChild:[self createBoss]];
        counter3 = 120;
        bossAux=YES;
        NSLog(@"**BOSS**");
    }
    
    if (counter3<0 && bossAux) {
        
        if (bossAttack<3) {
            
            [self BossthrowBiribinhaLeft];
//            bossAttack++;
            counter3 = 120;
        }
        
    }
    counter3--;
    
    CGPoint pointTranslated = [camera convertPoint:boss.position toNode:myWorld];

    
    if (bossAttack>=3) {
        if (pointTranslated.x<(width/2)*0.9){
            [self BossMovingRight];
            bossMovendo = YES;
        }
        else{
            [boss removeAllActions];
            bossAttack=-1;
            bossMovendo = NO;
        }
    }
    
    
    //------ENDBOSS-------//
    Fire.position = especial.position;
    pontosCount.text = [NSString stringWithFormat:@"Pontos: %ld",(long)score];
    
    
    if(FOGAREU){
        special.texture = [SKTexture textureWithImageNamed:@"special_available.png"];
    }
    else{
        special.texture = [SKTexture textureWithImageNamed:@"special_unavailable.png"];
    }
    
    if (specialEsquerda) {
        [especial runAction:[SKAction moveByX:-30 y:0 duration:1]];
    }
    else
        [especial runAction:[SKAction moveByX:30 y:0 duration:1]];
    
    lancasCount.text = [NSString stringWithFormat:@"%ld", (long)lancas];
    if (specialAux>9) {
        FOGAREU = YES;
    }
    
    if(lancas < 1){
        lancasCount.fontColor = [UIColor redColor];
        attack2.texture = [SKTexture textureWithImageNamed:@"botao_atira_lanca_indisponivel"];
        noLanca = YES;
    }
    else if(lancas >=1 && noLanca){
        lancasCount.fontColor = [UIColor whiteColor];
        attack2.texture = [SKTexture textureWithImageNamed:@"botao_atira_lanca_disponivel"];
        noLanca = NO;
    }
    
    counter--;
    counter2--;
    attackCool--;
    
    if (counter==0) {
        CGPoint leftPos = CGPointMake(-camera.position.x+width/2, -height/2+(platform.size.height));
        [camera addChild:[self createEnemyintPosition:leftPos]];
        [enemy walkWithDistance:-400 toTheLeft:YES withDuration:5];
        counter = 480/stages;
    }
    
    if(counter2 == 0){
        [camera addChild:[self creatorBlockRight]];
        counter2 = 960/stages;
    }
    
    fundo.position = CGPointMake(fundo.position.x-width*0.0007, fundo.position.y);
    fundo2.position = CGPointMake(fundo2.position.x-width*0.0007, fundo2.position.y);
    
    if (fundo.position.x < -fundo.size.width){
        fundo.position = CGPointMake(fundo2.position.x + fundo2.size.width, fundo.position.y);
    }
    
    if (fundo2.position.x < -fundo2.size.width){
        fundo2.position = CGPointMake(fundo.position.x + fundo.size.width, fundo2.position.y);
    }
    
    if(camera.position.x <= -width*stages){
        if(stages%2!=0){
            platform.position = CGPointMake(platform2.position.x+platform.size.width, platform.position.y);
        }
        else{
            platform2.position = CGPointMake(platform.position.x+platform.size.width, platform.position.y);
        }
        stages++;
        [self enemyMovingLeft];
    }
}


#pragma mark - Physics

- (void)didSimulatePhysics{
    [self centerOnNode: [self childNodeWithName: @"//spartan"]];
}

- (void) centerOnNode: (SKNode *) node{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x-width/4, node.parent.position.y);
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    //Attack in boss
    if((contact.bodyA.categoryBitMask == SPARTAN && [contact.bodyB.node.name isEqualToString:@"Bspear"]) || ([contact.bodyA.node.name isEqualToString:@"spartan"] && [contact.bodyB.node.name isEqualToString:@"battack"])){
        
        if (defendendo) {
            [self runAction:[SKAction playSoundFileNamed:@"hitS.wav" waitForCompletion:NO]];
            [contact.bodyB.node removeFromParent];
        }
        else{
            [self runAction:[SKAction playSoundFileNamed:@"hitC.mp3" waitForCompletion:NO]];
            if (HP<=0) {
                SKScene *GO = [[GameOverScene alloc] initWithSize:self.size andScore:score];
                SKTransition *troca = [SKTransition fadeWithDuration:0.5];
                [self.view presentScene:GO transition:troca];
            }
            HP--;
            NSString *textureName = [NSString stringWithFormat:@"heart%d",HP];
            vidas.texture = [atlas textureNamed:textureName];
            [contact.bodyB.node removeFromParent];
        }
    }
    
    if(([contact.bodyB.node.name isEqualToString:@"spartan"] && [contact.bodyA.node.name isEqualToString:@"Bspear"]) || ([contact.bodyB.node.name isEqualToString:@"spartan"] && [contact.bodyA.node.name isEqualToString:@"battack"])){
        [self runAction:[SKAction playSoundFileNamed:@"hitC.mp3" waitForCompletion:NO]];
        
        if (defendendo) {
            [self runAction:[SKAction playSoundFileNamed:@"hitS.wav" waitForCompletion:NO]];
            [contact.bodyA.node removeFromParent];
        }
        else{
            [self runAction:[SKAction playSoundFileNamed:@"hitC.mp3" waitForCompletion:NO]];
            if (HP<=0) {
                SKScene *GO = [[GameOverScene alloc] initWithSize:self.size andScore:score];
                SKTransition *troca = [SKTransition fadeWithDuration:0.5];
                [self.view presentScene:GO transition:troca];
            }
            HP--;
            NSString *textureName = [NSString stringWithFormat:@"heart%d",HP];
            vidas.texture = [atlas textureNamed:textureName];
            [contact.bodyA.node removeFromParent];
            
        }
        
    }
    if(([contact.bodyA.node.name isEqualToString:@"boss"] && [contact.bodyB.node.name isEqualToString:@"spear"]) || ([contact.bodyA.node.name isEqualToString:@"boss"] && [contact.bodyB.node.name isEqualToString:@"attack"])){
        
        [self runAction:[SKAction playSoundFileNamed:@"hitC.mp3" waitForCompletion:NO]];
        
        if (bossHP>0) {
            bossHP--;
        }
        else
            [contact.bodyA.node removeFromParent];
        score = score+stages+100;
        specialAux++;
    }
    
    if(([contact.bodyB.node.name isEqualToString:@"boss"] && [contact.bodyA.node.name isEqualToString:@"spear"]) || ([contact.bodyB.node.name isEqualToString:@"boss"] && [contact.bodyA.node.name isEqualToString:@"attack"])){
        [self runAction:[SKAction playSoundFileNamed:@"hitC.mp3" waitForCompletion:NO]];
        
        if (bossHP>0) {
            bossHP--;
        }
        else
            [contact.bodyA.node removeFromParent];
        score = score+stages+100;
        specialAux++;
        
    }
    if(([contact.bodyB.node.name isEqualToString:@"boss"] && [contact.bodyA.node.name isEqualToString:@"specialspear"])){
        [self runAction:[SKAction playSoundFileNamed:@"hitC.mp3" waitForCompletion:NO]];
        
        if (bossHP>0) {
            bossHP=bossHP-3;
        }
        else
            [contact.bodyA.node removeFromParent];
        score = score+stages+100;
        specialAux++;
        
    }
    if([contact.bodyA.node.name isEqualToString:@"specialspear"] && [contact.bodyB.node.name isEqualToString:@"boss"]){
        [self runAction:[SKAction playSoundFileNamed:@"hitC.mp3" waitForCompletion:NO]];
        
        if (bossHP>0) {
            bossHP=bossHP-3;
        }
        else{
            [contact.bodyB.node removeFromParent];
            score = score+stages+100;
            specialAux++;
        }
    }

    //end attack in boss
    
    //Attack melee / ranged, remove enemy
    if((contact.bodyA.categoryBitMask == ENEMY && contact.bodyB.categoryBitMask == BIRIBINHA) || (contact.bodyA.categoryBitMask == ENEMY && contact.bodyB.categoryBitMask == ATTACK)){
        
        [self runAction:[SKAction playSoundFileNamed:@"hitC.mp3" waitForCompletion:NO]];
        
        //Drop random loot
        int random = arc4random_uniform(5);
        if(random == 3){
            SKTexture *drop1 = [SKTexture textureWithImageNamed:@"lanca_diagonal.png"];
            drop = [[SKSpriteNode alloc] initWithTexture:drop1 color:[SKColor blackColor] size:spartan.size];
            drop.position = contact.contactPoint;
            drop.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spartan.size];
            drop.name = @"loot";
            drop.physicsBody.categoryBitMask = LOOT;
            drop.physicsBody.collisionBitMask = ROCK;
            drop.physicsBody.contactTestBitMask = SPARTAN;
            [camera addChild:drop];
        }
        
        [contact.bodyA.node removeFromParent];
        score = score+stages;
        specialAux++;
    }
    
    if((contact.bodyB.categoryBitMask == ENEMY && contact.bodyA.categoryBitMask == BIRIBINHA) || (contact.bodyB.categoryBitMask == ENEMY && contact.bodyA.categoryBitMask == ATTACK)){
        
        [self runAction:[SKAction playSoundFileNamed:@"hitC.mp3" waitForCompletion:NO]];
        
        //Drop random loot
        int random = arc4random_uniform(5);
        if(random == 3){
            SKTexture *drop1 = [SKTexture textureWithImageNamed:@"lanca_diagonal.png"];
            drop = [[SKSpriteNode alloc] initWithTexture:drop1 color:[SKColor blackColor] size:spartan.size];
            drop.position = contact.contactPoint;
            drop.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spartan.size];
            drop.physicsBody.categoryBitMask = LOOT;
            drop.physicsBody.collisionBitMask = ROCK;
            drop.physicsBody.contactTestBitMask = SPARTAN;
            drop.name = @"loot";
            [camera addChild:drop];
        }
        
        
        [contact.bodyB.node removeFromParent];
        score = score+stages;
        specialAux++;
    }

    if((contact.bodyA.categoryBitMask == ENEMY2 && contact.bodyB.categoryBitMask == BIRIBINHA) || (contact.bodyA.categoryBitMask == ENEMY2 && contact.bodyB.categoryBitMask == ATTACK)){
        
        [self runAction:[SKAction playSoundFileNamed:@"hitC.mp3" waitForCompletion:NO]];
        
        //Drop random loot
        int random = arc4random_uniform(5);
        if(random == 3){
            SKTexture *drop1 = [SKTexture textureWithImageNamed:@"lanca_diagonal.png"];
            drop = [[SKSpriteNode alloc] initWithTexture:drop1 color:[SKColor blackColor] size:spartan.size];
            drop.position = contact.contactPoint;
            drop.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spartan.size];
            drop.name = @"loot";
            drop.physicsBody.categoryBitMask = LOOT;
            drop.physicsBody.collisionBitMask = ROCK;
            drop.physicsBody.contactTestBitMask = SPARTAN;
            [camera addChild:drop];
        }
        
        [contact.bodyA.node removeFromParent];
        score = score+stages;
        specialAux++;
    }
    
    if((contact.bodyB.categoryBitMask == ENEMY2 && contact.bodyA.categoryBitMask == BIRIBINHA) || (contact.bodyB.categoryBitMask == ENEMY2 && contact.bodyA.categoryBitMask == ATTACK)){
        [self runAction:[SKAction playSoundFileNamed:@"hitC.mp3" waitForCompletion:NO]];
        
        //Drop random loot
        int random = arc4random_uniform(5);
        if(random == 3){
            SKTexture *drop1 = [SKTexture textureWithImageNamed:@"lanca_diagonal.png"];
            drop = [[SKSpriteNode alloc] initWithTexture:drop1 color:[SKColor blackColor] size:spartan.size];
            drop.position = contact.contactPoint;
            drop.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spartan.size];
            drop.physicsBody.categoryBitMask = LOOT;
            drop.physicsBody.collisionBitMask = ROCK;
            drop.physicsBody.contactTestBitMask = SPARTAN;
            drop.name = @"loot";
            [camera addChild:drop];
        }
        
        
        [contact.bodyB.node removeFromParent];
        score = score+stages;
        specialAux++;
    }
    
    //Grecules touches loot
    if((contact.bodyB.categoryBitMask == SPARTAN) && (contact.bodyA.categoryBitMask == LOOT)){
        [contact.bodyA.node removeFromParent];
        lancas++;
    }
    if((contact.bodyA.categoryBitMask == SPARTAN) && (contact.bodyB.categoryBitMask == LOOT)){
        [contact.bodyB.node removeFromParent];
        lancas++;
    }
    
    //Remove attack / spear node
    if((contact.bodyB.categoryBitMask == BIRIBINHA) || (contact.bodyB.categoryBitMask == ATTACK)){
        [projectile removeFromParent];
        [attackRegion removeFromParent];
    }
    if((contact.bodyA.categoryBitMask == BIRIBINHA) || (contact.bodyA.categoryBitMask == ATTACK)){
        [projectile removeFromParent];
        [attackRegion removeFromParent];
    }
    
    //Inflict damage on Grecules
    //Left
    if((contact.bodyB.categoryBitMask == SPARTAN) && (contact.bodyA.categoryBitMask == ENEMY)){
        
        if(defendendo) [self runAction:[SKAction playSoundFileNamed:@"hitS.wav" waitForCompletion:NO]];
        else [self runAction:[SKAction playSoundFileNamed:@"hitC.mp3" waitForCompletion:NO]];
        if(HP == 0){
            if(!defendendo){
                [contact.bodyB.node removeFromParent];
                SKScene *GO = [[GameOverScene alloc] initWithSize:self.size andScore:score];
                SKTransition *troca = [SKTransition fadeWithDuration:0.5];
                [self.view presentScene:GO transition:troca];
            }
        }
        
        else{
            if (!defendendo) {
                SKTexture *f1 = [atlas textureNamed:@"inimigo1_01_L_parado.png"];
                SKTexture *f2 = [atlas textureNamed:@"inimigo1_02_L_attack.png"];
                NSArray *enemyLeftWalk = @[f1,f2];
                [contact.bodyA.node removeAllActions];
                [contact.bodyA.node runAction:[SKAction animateWithTextures:enemyLeftWalk timePerFrame:0.5] completion:^{
                    
                    [self enemyMovingLeftAfterContact:contact.bodyA.node];
                }];
                
                
                HP--;
                NSString *textureName = [NSString stringWithFormat:@"heart%d",HP];
                vidas.texture = [atlas textureNamed:textureName];
            }
            else{
                SKTexture *f1 = [atlas textureNamed:@"inimigo1_01_L_parado.png"];
                SKTexture *f2 = [atlas textureNamed:@"inimigo1_02_L_attack.png"];   NSArray *enemyLeftWalk = @[f1,f2];
                [contact.bodyA.node removeAllActions];
                [contact.bodyA.node runAction:[SKAction animateWithTextures:enemyLeftWalk timePerFrame:0.5] completion:^{
                    [self enemyMovingLeftAfterContact:contact.bodyA.node];
                }];
            }
        }
    }
    
    if((contact.bodyA.categoryBitMask == SPARTAN) && (contact.bodyB.categoryBitMask == ENEMY)){
        if(defendendo) [self runAction:[SKAction playSoundFileNamed:@"hitS.wav" waitForCompletion:NO]];
        else [self runAction:[SKAction playSoundFileNamed:@"hitC.mp3" waitForCompletion:NO]];
        if(HP == 0){
            if(!defendendo){
                [contact.bodyA.node removeFromParent];
                SKScene *GO = [[GameOverScene alloc] initWithSize:self.size andScore:score];
                SKTransition *troca = [SKTransition fadeWithDuration:0.5];
                [self.view presentScene:GO transition:troca];
            }
        }
        else{
            if (!defendendo) {
                SKTexture *f1 = [atlas textureNamed:@"inimigo1_01_L_parado.png"];
                SKTexture *f2 = [atlas textureNamed:@"inimigo1_02_L_attack.png"];   NSArray *enemyLeftWalk = @[f1,f2];
                [contact.bodyB.node removeAllActions];
                [contact.bodyB.node runAction:[SKAction animateWithTextures:enemyLeftWalk timePerFrame:0.5] completion:^{
                    [self enemyMovingLeftAfterContact:contact.bodyB.node];
                }];
                
                
                HP--;
                NSString *textureName = [NSString stringWithFormat:@"heart%d",HP];
                vidas.texture = [atlas textureNamed:textureName];
            }
            else{
                SKTexture *f1 = [atlas textureNamed:@"inimigo1_01_L_parado.png"];
                SKTexture *f2 = [atlas textureNamed:@"inimigo1_02_L_attack.png"];   NSArray *enemyLeftWalk = @[f1,f2];
                [contact.bodyB.node removeAllActions];
                [contact.bodyB.node runAction:[SKAction animateWithTextures:enemyLeftWalk timePerFrame:0.5] completion:^{
                    [self enemyMovingLeftAfterContact:contact.bodyB.node];
                }];
            }
        }
    }
    
    //Right
    if((contact.bodyB.categoryBitMask == SPARTAN) && (contact.bodyA.categoryBitMask == ENEMY2)){
        if(defendendo) [self runAction:[SKAction playSoundFileNamed:@"hitS.wav" waitForCompletion:NO]];
        else [self runAction:[SKAction playSoundFileNamed:@"hitC.mp3" waitForCompletion:NO]];
        if(HP == 0){
            if(!defendendo){
                [contact.bodyB.node removeFromParent];
                SKScene *GO = [[GameOverScene alloc] initWithSize:self.size andScore:score];
                SKTransition *troca = [SKTransition fadeWithDuration:0.5];
                [self.view presentScene:GO transition:troca];
            }
        }
        
        else{
            if (!defendendo) {
                SKTexture *f1 = [atlas textureNamed:@"inimigo1_01_R_parado.png"];
                SKTexture *f2 = [atlas textureNamed:@"inimigo1_02_R_attack.png"];
                NSArray *enemyLeftWalk = @[f1,f2];
                [contact.bodyA.node removeAllActions];
                [contact.bodyA.node runAction:[SKAction animateWithTextures:enemyLeftWalk timePerFrame:0.5] completion:^{
                    
                    [self enemyMovingRightAfterContact:contact.bodyA.node];
                }];
                
                
                HP--;
                NSString *textureName = [NSString stringWithFormat:@"heart%d",HP];
                vidas.texture = [atlas textureNamed:textureName];
            }
            else{
                SKTexture *f1 = [atlas textureNamed:@"inimigo1_01_R_parado.png"];
                SKTexture *f2 = [atlas textureNamed:@"inimigo1_02_R_attack.png"];   NSArray *enemyLeftWalk = @[f1,f2];
                [contact.bodyA.node removeAllActions];
                [contact.bodyA.node runAction:[SKAction animateWithTextures:enemyLeftWalk timePerFrame:0.5] completion:^{
                    [self enemyMovingRightAfterContact:contact.bodyA.node];
                }];
            }
        }
    }
    
    if((contact.bodyA.categoryBitMask == SPARTAN) && (contact.bodyB.categoryBitMask == ENEMY2)){
        if(defendendo) [self runAction:[SKAction playSoundFileNamed:@"hitS.wav" waitForCompletion:NO]];
        else [self runAction:[SKAction playSoundFileNamed:@"hitC.mp3" waitForCompletion:NO]];
        if(HP == 0){
            if(!defendendo){
                [contact.bodyA.node removeFromParent];
                SKScene *GO = [[GameOverScene alloc] initWithSize:self.size andScore:score];
                SKTransition *troca = [SKTransition fadeWithDuration:0.5];
                [self.view presentScene:GO transition:troca];
            }
        }
        else{
            if (!defendendo) {
                SKTexture *f1 = [atlas textureNamed:@"inimigo1_01_R_parado.png"];
                SKTexture *f2 = [atlas textureNamed:@"inimigo1_02_R_attack.png"];   NSArray *enemyLeftWalk = @[f1,f2];
                [contact.bodyB.node removeAllActions];
                [contact.bodyB.node runAction:[SKAction animateWithTextures:enemyLeftWalk timePerFrame:0.5] completion:^{
                    [self enemyMovingRightAfterContact:contact.bodyB.node];
                }];
                
                
                HP--;
                NSString *textureName = [NSString stringWithFormat:@"heart%d",HP];
                vidas.texture = [atlas textureNamed:textureName];
            }
            else{
                SKTexture *f1 = [atlas textureNamed:@"inimigo1_01_R_parado.png"];
                SKTexture *f2 = [atlas textureNamed:@"inimigo1_02_R_attack.png"];   NSArray *enemyLeftWalk = @[f1,f2];
                [contact.bodyB.node removeAllActions];
                [contact.bodyB.node runAction:[SKAction animateWithTextures:enemyLeftWalk timePerFrame:0.5] completion:^{
                    [self enemyMovingRightAfterContact:contact.bodyB.node];
                }];
            }
        }
    }
}

@end

