//
//  Enemy.h
//  noName
//
//  Created by Guilherme Castro on 20/06/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "Warrior.h"

@interface Enemy : Warrior

-(instancetype)initCreateEnemyWithTexture:(NSArray *)frames inPosition:(CGPoint)pos;

@end
