//
//  ViewController.m
//  searchingAnimateDemo
//
//  Created by sidetang on 2017/5/27.
//  Copyright © 2017年 sidetang. All rights reserved.
//

#import "ViewController.h"
#import "JHChainableAnimations/JHChainableAnimator.h"

#define weakSelf(__TARGET__) __weak typeof(self) __TARGET__=self
#define strongSelf(__TARGET__, __WEAK__) typeof(self) __TARGET__=__WEAK__
#define animateColor [UIColor colorWithRed:105.0/255.0 green:206/255.0 blue:219/255.0 alpha:1];

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (nonatomic, weak) UIView *middleCircleView;
@property (nonatomic, weak) UIView *rippleMiddleView;
@property (nonatomic, weak) UIView *rippleBottomView;
@property (nonatomic, strong) JHChainableAnimator *middleCircleViewAnimator;
@property (nonatomic, strong) JHChainableAnimator *rippleMiddleViewAnimator;
@property (nonatomic, strong) JHChainableAnimator *rippleBottomViewAnimator;
@property (nonatomic) CAShapeLayer *loadingLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIView *middleCircleView = [[UIView alloc] initWithFrame:CGRectMake(self.loadingView.bounds.size.width/2.0 - 25, self.loadingView.bounds.size.height/2.0 - 25, 50, 50)];
    middleCircleView.backgroundColor = animateColor;
    middleCircleView.layer.cornerRadius = 25;
    [middleCircleView setClipsToBounds:YES];
    [self.loadingView addSubview:middleCircleView];
    self.middleCircleView = middleCircleView;
    
    
    UIView *rippleMiddleView = [[UIView alloc] initWithFrame:CGRectMake(self.loadingView.bounds.size.width/2.0 - 25, self.loadingView.bounds.size.height/2.0 - 25, 50, 50)];
    rippleMiddleView.backgroundColor =  animateColor;
    rippleMiddleView.layer.cornerRadius = 25;
    [rippleMiddleView setClipsToBounds:YES];
    rippleMiddleView.alpha = 0.2;
    [self.loadingView addSubview:rippleMiddleView];
    self.rippleMiddleView = rippleMiddleView;
    
    UIView *rippleBottomView = [[UIView alloc] initWithFrame:CGRectMake(self.loadingView.bounds.size.width/2.0 - 25, self.loadingView.bounds.size.height/2.0 - 25, 50, 50)];
    rippleBottomView.backgroundColor =  animateColor;
    rippleBottomView.layer.cornerRadius = 25;
    [rippleBottomView setClipsToBounds:YES];
    rippleBottomView.alpha = 0.2;
    [self.loadingView addSubview:rippleBottomView];
    self.rippleBottomView = rippleBottomView;

}

-(void)viewWillLayoutSubviews
{
    self.widthConstraint.constant = 240;
    [self.loadingView needsUpdateConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CAShapeLayer *)CircleLayer {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    CGSize placeSize = self.loadingView.bounds.size;
    circleLayer.frame = CGRectMake(0,0 , placeSize.width, placeSize.height);
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.lineWidth = 3.0;
    circleLayer.strokeColor = [UIColor colorWithRed:105.0/255.0 green:206/255.0 blue:219/255.0 alpha:1].CGColor;
    
    CGRect frame = CGRectMake(0,0 , placeSize.width, placeSize.height);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:frame];
    
    circleLayer.path = circlePath.CGPath;
    return circleLayer;
}

-(void)circleAnimate
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self circleAnimate];
    }];
    // animtations
    self.loadingLayer.strokeStart = 0.0;
    self.loadingLayer.strokeEnd = 0.0;
    
    CGFloat totalDuration = 0;
    CABasicAnimation *stroke = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    stroke.beginTime = CACurrentMediaTime();
    stroke.fromValue = @(0.0);
    stroke.toValue = @(1.0);
    CGFloat duration = 1.0f;
    stroke.duration = duration;
    stroke.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.loadingLayer addAnimation:stroke forKey:nil];
    
    totalDuration += 0.25;
    CABasicAnimation *stroke3 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    stroke3.beginTime = CACurrentMediaTime() + totalDuration;
    stroke3.fromValue = @(0.0);
    stroke3.toValue = @(1.0);
    CGFloat duration2 = 0.75f;
    stroke3.duration = duration2;
    stroke3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.loadingLayer addAnimation:stroke3 forKey:nil];
    [CATransaction commit];
}

- (void)startCircleAnimate {
    self.loadingLayer = [self CircleLayer];
    [self.loadingView.layer addSublayer:self.loadingLayer];
    
    [self circleAnimate];
}

-(void)startLayerAnimate
{
    weakSelf(target);
    self.middleCircleViewAnimator = [[JHChainableAnimator alloc] initWithView:self.middleCircleView];
    self.middleCircleViewAnimator.transformScale(1.1).thenAfter(0.15).transformIdentity.animateWithCompletion(0.15,^{
        
    });
    
    
    self.rippleMiddleViewAnimator = [[JHChainableAnimator alloc] initWithView:self.rippleMiddleView];
    self.rippleMiddleViewAnimator.transformScale(3.0).makeOpacity(0.0).delay(0.15).easeInOut.animateWithCompletion(0.75, ^{
        strongSelf(strongSelf, target);
        strongSelf.rippleMiddleView.layer.transform = CATransform3DIdentity;
        strongSelf.rippleMiddleView.alpha = 0.2;
    });
    
    self.rippleBottomViewAnimator = [[JHChainableAnimator alloc] initWithView:self.rippleBottomView];
    self.rippleBottomViewAnimator.transformScale(3.0).makeOpacity(0.0).delay(0.4).easeInOut.animateWithCompletion(0.6, ^{
        strongSelf(strongSelf, target);
        strongSelf.rippleBottomView.layer.transform = CATransform3DIdentity;
        strongSelf.rippleBottomView.alpha = 0.2;
        
        [strongSelf startLayerAnimate];
    });
    
}

- (IBAction)action:(id)sender {
    [(UIButton *)sender setEnabled:NO];
    [self startLayerAnimate];
    [self startCircleAnimate];

}



@end
