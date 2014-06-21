//
//  Warrior.m
//  noName
//
//  Created by Guilherme Castro on 29/04/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "Warrior.h"

@implementation Warrior

-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size{
    self = [super initWithColor:color size:size];
    self.walkFrames = [[NSMutableArray alloc]init];
    self.frames = [[NSMutableArray alloc]init];
    self.attackFrames = [[NSMutableArray alloc]init];
    
    return self;
}

-(void)takeDamage{
    self.hp--;
    if(self.hp == 0) [self die];
}

-(void)die{
    [self removeFromParent];
}

@end
