//
//  CircularLoaderView.m
//  CicularImageLoader
//
//  Created by Rohit Yadav on 05/08/16.
//  Copyright © 2016 iAppstreet. All rights reserved.
//

#import "CircularLoaderView.h"

@interface CircularLoaderView()

@property (nonatomic, strong) CAShapeLayer *circlePathLayer;
@property (nonatomic, assign) CGFloat circleRadius;

@end

@implementation CircularLoaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    _circleRadius = 20.0;
    _circlePathLayer = [CAShapeLayer new];
    
    _circlePathLayer.frame = self.bounds;
    _circlePathLayer.lineWidth = 2;
    _circlePathLayer.fillColor = [UIColor clearColor].CGColor;
    _circlePathLayer.strokeColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:_circlePathLayer];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.progress = 0;
}

- (CGRect)cicleFrame
{
    CGRect circleFrame = (CGRect){0,0,2*_circleRadius,2*_circleRadius};
    circleFrame.origin.x = CGRectGetMidX(_circlePathLayer.bounds) - CGRectGetMidX(circleFrame);
    circleFrame.origin.y = CGRectGetMidY(_circlePathLayer.bounds) - CGRectGetMidY(circleFrame);
    return circleFrame;
}

- (UIBezierPath *)circlePath
{
    return [UIBezierPath bezierPathWithOvalInRect:[self cicleFrame]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _circlePathLayer.frame = self.bounds;
    _circlePathLayer.path = [self circlePath].CGPath;
}

- (CGFloat)progress
{
    return _circlePathLayer.strokeEnd;
}

- (void)setProgress:(CGFloat)progress
{
    if (progress > 1) {
        _circlePathLayer.strokeEnd = 1;
    }
    else if (progress < 0){
        _circlePathLayer.strokeEnd = 0;
    }
    else{
        _circlePathLayer.strokeEnd = progress;
    }
}

- (void)reveal
{
    self.backgroundColor = [UIColor clearColor];
    self.progress = 1;
    
    [_circlePathLayer removeAnimationForKey:@"strokeEnd"];
    
    [_circlePathLayer removeFromSuperlayer];
    
    self.superview.layer.mask = _circlePathLayer;
    
    CGPoint center = (CGPoint){CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)};
    CGFloat finalRadius = sqrtf((center.x*center.x) + (center.y*center.y));
    CGFloat radiusInset = finalRadius - _circleRadius;
    
    CGRect outerReach = CGRectInset([self cicleFrame], -radiusInset, -radiusInset);
    
    CGPathRef toPath = [UIBezierPath bezierPathWithOvalInRect:outerReach].CGPath;
    
    CGPathRef fromPath = _circlePathLayer.path;
    CGFloat fromLineWidth = _circlePathLayer.lineWidth;
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    _circlePathLayer.lineWidth = 2* finalRadius;
    _circlePathLayer.path = toPath;
    [CATransaction commit];
    
    CABasicAnimation *lineWidthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    lineWidthAnimation.fromValue = [NSNumber numberWithFloat:fromLineWidth];
    lineWidthAnimation.toValue = [NSNumber numberWithFloat:2*finalRadius];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id _Nullable)(fromPath);
    pathAnimation.toValue = (__bridge id _Nullable)(toPath);
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup new];
    groupAnimation.duration = 1;
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    groupAnimation.animations = @[pathAnimation,lineWidthAnimation];
    groupAnimation.delegate = self;
    
    [_circlePathLayer addAnimation:groupAnimation forKey:@"strokeWidth"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.superview.layer.mask = nil;
}

@end
