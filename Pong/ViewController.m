//
//  ViewController.m
//  Pong
//
//  Created by Kamil Kowalski on 23.10.2015.
//  Copyright © 2015 Kamil Kowalski. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

// Game settings
UIColor* backgroundColor;
UIColor* boardColor;
UIColor* ballColor;
CGRect boardFrame;
CGRect ballFrame;
CGFloat ballRadius;
CGFloat boardThickness;
CGFloat boardWidth;

// Game views
UIView* board;
UIView* ball;

// Animation
UIDynamicAnimator* animator;
UIGravityBehavior* gravity;
UICollisionBehavior* collisions;
UIDynamicItemBehavior* ballDynamics;
UIDynamicItemBehavior* boardDynamics;
UIPushBehavior* initialPush;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSettings];
    [self initViews];
    [self initAnimations];
}

- (void)initSettings {
    backgroundColor = [self getBackgroundColor];
    
    boardWidth = 100;
    boardThickness = 20;
    boardFrame = [self getBoardFrame];
    boardColor = [self getBoardColor];

    ballRadius = 10;
    ballFrame = [self getBallFrame];
    ballColor = [self getBallColor];
}

- (void)initViews {
    // Set background color
    [self.view setBackgroundColor:backgroundColor];
    
    // Init view objects and set their properties
    board = [[UIView alloc] initWithFrame:boardFrame];
    [board setBackgroundColor:boardColor];
    
    ball = [[UIView alloc] initWithFrame:ballFrame];
    [ball setBackgroundColor:ballColor];
    [ball.layer setCornerRadius:ballRadius];
    
    // Add views to scene
    [self.view addSubview:board];
    [self.view addSubview:ball];
}

- (void)initAnimations {
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    collisions = [[UICollisionBehavior alloc] initWithItems:@[ball, board]];
    ballDynamics = [[UIDynamicItemBehavior alloc] initWithItems:@[ball]];
    boardDynamics = [[UIDynamicItemBehavior alloc] initWithItems:@[board]];
    initialPush = [[UIPushBehavior alloc] initWithItems:@[ball] mode:UIPushBehaviorModeInstantaneous];
    
    [ballDynamics setElasticity:1];
    [ballDynamics setFriction:0];
    [ballDynamics setResistance:0];
    
    [boardDynamics setDensity:1000];
    
    [initialPush setAngle:0.4 magnitude:0.2];
    
    // Boundaries
    CGPoint topLeft = self.view.frame.origin;
    CGPoint bottomLeft = CGPointMake(0, self.view.frame.size.height);
    CGPoint topRight = CGPointMake(self.view.frame.size.width, 0);
    CGPoint bottomRight = CGPointMake(self.view.frame.size.width, self.view.frame.size.height);
    
    [collisions addBoundaryWithIdentifier:@"left" fromPoint:topLeft toPoint:bottomLeft];
    [collisions addBoundaryWithIdentifier:@"top" fromPoint:topLeft toPoint:topRight];
    [collisions addBoundaryWithIdentifier:@"right" fromPoint:topRight toPoint:bottomRight];
    
    [animator addBehavior:initialPush];
    [animator addBehavior:collisions];
    [animator addBehavior:ballDynamics];
    [animator addBehavior:boardDynamics];
}

- (CGRect)getBoardFrame {
    return CGRectMake(
        self.view.frame.size.width / 2 - boardWidth / 2,
        self.view.frame.size.height - boardThickness,
        boardWidth,
        boardThickness
    );
}

- (CGRect)getBallFrame {
    return CGRectMake(
        self.view.frame.size.width / 2 - ballRadius,
        self.view.frame.size.height / 2 - ballRadius,
        ballRadius * 2,
        ballRadius * 2
    );
}

- (UIColor*)getBackgroundColor {
    return [UIColor colorWithRed:0.1 green:0.1 blue:0.2 alpha:1];
}

- (UIColor*)getBoardColor {
    return [UIColor colorWithRed:0.1 green:0.8 blue:1 alpha:1];
}

- (UIColor*)getBallColor {
    return [UIColor colorWithRed:0.8 green:0.1 blue:0.2 alpha:1];
}
@end
