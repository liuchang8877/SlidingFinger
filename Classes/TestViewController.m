//
//  TestViewController.m
//  DroppableViewTest
//
//  Created by liu on 12-11-21.
//
#import <QuartzCore/QuartzCore.h>
#import "TestViewController.h"
#import "JDDroppableView.h"
#import "UserScore.h"
#import "JDGroupedFlipNumberView.h"

// setup view vars
static NSInteger sDROPVIEW_MARGIN = 3.8;                   // margin
static CGFloat   sCOUNT_OF_VIEWS_HORICONTALLY = 4.0;
static CGFloat   sCOUNT_OF_VIEWS_VERTICALLY   = 2.7;


@implementation TestViewController


- (void)loadView
{
	[super loadView];
    //self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    // increase viewcount on ipad
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        sCOUNT_OF_VIEWS_HORICONTALLY = 5.9;
        sCOUNT_OF_VIEWS_VERTICALLY   = 4.3;
    } 
    
    //add the FlipNumber  for the time
    flipViewTime = [[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: 4];
    flipViewTime.intValue = 500;
    flipViewTime.tag = 99;
    //[flipView setDirection:0];
    [self.view addSubview: flipViewTime];
    //set the FlipNumber size and location
    UIView* viewTime = [[self.view subviews] objectAtIndex: 0];
    viewTime.frame = CGRectMake(0, 0, 200, 200);
    viewTime.center = CGPointMake(self.view.frame.size.width /2+220,
                              (self.view.frame.size.height/9)+790);
    [flipViewTime animateDownWithTimeInterval: 1.0];
    //[flipView animateUpWithTimeInterval: 1];
    
    //add the FlipNumber for the score
    flipViewScore = [[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: 4];
    flipViewScore.intValue = 0;
    flipViewScore.tag = 99;
    //[flipView setDirection:0];
    [self.view addSubview: flipViewScore];
    //set the FlipNumber size and location
    UIView* viewScore = [[self.view subviews] objectAtIndex: 1];
    viewScore.frame = CGRectMake(0, 0, 200, 200);
    viewScore.center = CGPointMake(self.view.frame.size.width /2-160,
                              (self.view.frame.size.height/9)+790);
    //[flipViewScore animateDownWithTimeInterval: 1.0];
    //[flipViewScore animateUpWithTimeInterval: 1.0];
    //[flipViewScore animateUp];
    
    
    // add button
    UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [button setTitle: @"Out" forState: UIControlStateNormal];
    [button addTarget: self action: @selector(exitAll) forControlEvents: UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWithRed: 0.75 green: 0.2 blue: 0 alpha: 1.0];
    button.layer.cornerRadius = 5.0;
    button.showsTouchWhenHighlighted = YES;
    button.adjustsImageWhenHighlighted = YES;
    button.frame = CGRectMake(12,
                              self.view.frame.size.height - 52,
                              self.view.frame.size.width - 40, // width
                              32); // height
    [self.view addSubview: button];
	
    
	// drop target
	mDropTarget = [[UIView alloc] init];
    mDropTarget.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	mDropTarget.backgroundColor = [UIColor orangeColor];
	mDropTarget.frame = CGRectMake(0, 0, 30, 30);
	mDropTarget.center = CGPointMake(self.view.frame.size.width/2, button.frame.origin.y - 50);
    mDropTarget.layer.cornerRadius = 15;
	[self.view addSubview: mDropTarget];

    [mDropTarget release];
	
	// scrollview
	mScrollView = [[UIScrollView alloc] init];
    mScrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	mScrollView.backgroundColor = [UIColor colorWithRed: 0.75 green: 0.2 blue: 0 alpha: 1.0];
	mScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	mScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 5, 5, 5);
	mScrollView.contentInset = UIEdgeInsetsMake(6, 6, 6, 6);
    mScrollView.layer.cornerRadius = 5.0;
	mScrollView.frame = CGRectMake(20,20, self.view.frame.size.width - 40, mDropTarget.center.y - 70);
    mScrollView.userInteractionEnabled = NO;
	mScrollView.canCancelContentTouches = NO;

    //add the main backgroundImage to the mScrollView
    UIImage *image = [UIImage imageNamed:@"main.png"];
    mScrollView.layer.contents = (id)image.CGImage;
    
	[self.view addSubview: mScrollView];
    [mScrollView release];
	
	// animate some draggable views in
    int numberOfViews            = (sCOUNT_OF_VIEWS_HORICONTALLY*floor(sCOUNT_OF_VIEWS_VERTICALLY)/2)-2;
    CGFloat animationTimePerView = 0.15;
	for (int i = 0; i < numberOfViews; i++) {
		[self performSelector: @selector(addAllView:) withObject:[NSNumber  numberWithInt:i] afterDelay: i*animationTimePerView];
        if (i%(int)(sCOUNT_OF_VIEWS_HORICONTALLY)==0) {
            [self performSelector: @selector(scrollToBottomAnimated:) withObject: [NSNumber numberWithBool: YES] afterDelay: i*animationTimePerView];
        }
	}
    
    // reenable userinteraction after animation ended
    [mScrollView performSelector: @selector(setUserInteractionEnabled:) withObject: [NSNumber numberWithBool: YES] afterDelay: numberOfViews*animationTimePerView];
    //set the flag of change size
    mSmall = YES;
    [self performSelector: @selector(makeSmall) withObject:nil afterDelay: numberOfViews*animationTimePerView+0.5];
    
    //add the scoreLabel
    scoreLabel = [[UILabel alloc]init];
    scoreLabel.frame = CGRectMake(0, 0, 100, 50);
    scoreLabel.text  = @"YourScore:";
    scoreLabel.textAlignment = UITextAlignmentCenter;
    scoreLabel.center = CGPointMake(self.view.frame.size.width/2-310, button.frame.origin.y - 50);
    scoreLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scoreLabel];
    
    //add the timeLabel
    timeLabel = [[UILabel alloc]init];
    timeLabel.frame = CGRectMake(0, 0, 80, 50);
    timeLabel.text  = @"LeftTime:";
    timeLabel.textAlignment = UITextAlignmentCenter;
    timeLabel.center = CGPointMake(self.view.frame.size.width/2+70, button.frame.origin.y - 50);
    timeLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:timeLabel];
    
    //init the myScore
    newScore = 0;
    myScore = [[UserScore alloc]init];
    [myScore setScore:newScore];
    NSLog(@"=================myScore:%d",[myScore Score]);
    
    //init timer
    NSTimer * myLeftTime;
    myLeftTime = [NSTimer scheduledTimerWithTimeInterval:1
                        target:self
                        selector:@selector(handleTimer)
                        userInfo:nil
                        repeats:YES];
    leftTime = 500;
    //init flagwin
    flagWin = NO;

}

#pragma layout

- (void) relayout
{
    // cancel all animations
    [mScrollView.layer removeAllAnimations];
	for (UIView* subview in mScrollView.subviews)
        [subview.layer removeAllAnimations];
    
    // setup new animation
	[UIView beginAnimations: @"drag" context: nil];
    
    // init calculation vars
	float posx = 0;
	float posy = 0;
	CGRect frame = CGRectZero;
    mLastPosition = CGPointMake(0, -100);
    CGFloat contentWidth = mScrollView.contentSize.width - mScrollView.contentInset.left - mScrollView.contentInset.right;
	
    // iterate through all subviews
	for (UIView* subview in mScrollView.subviews)
    {
        // ignore scroll indicators
        if (!subview.userInteractionEnabled) {
            continue;
        }
        
        // create new position
		frame = subview.frame;
        frame.origin.x = posx;
        frame.origin.y = posy;
        
        // update frame (if it did change)
        if (frame.origin.x != subview.frame.origin.x ||
            frame.origin.y != subview.frame.origin.y) {
            subview.frame = frame;
        }
        
        // save last position
        mLastPosition = CGPointMake(posx, posy);
		
        // add size and margin
		posx += frame.size.width + sDROPVIEW_MARGIN;
		
        // goto next row if needed
		if (posx > mScrollView.frame.size.width - mScrollView.contentInset.left - mScrollView.contentInset.right)
        {
			posx = 0;
			posy += frame.size.height + sDROPVIEW_MARGIN;
		}
	}
    
    // fix last posy for correct contentSize
    if (posx != 0) {
        posy += frame.size.height;
    } else {
        posy -= sDROPVIEW_MARGIN;
    }
    
    // update content size
    mScrollView.contentSize = CGSizeMake(contentWidth, posy);

	[UIView commitAnimations];
}

// add new view t
//- (void) addView:(id)sender
//{
//    CGFloat contentWidth  = mScrollView.frame.size.width  - mScrollView.contentInset.left - mScrollView.contentInset.right;
//    CGFloat contentHeight = mScrollView.frame.size.height - mScrollView.contentInset.top;
//	CGSize size = CGSizeMake(((contentWidth-sDROPVIEW_MARGIN*(sCOUNT_OF_VIEWS_HORICONTALLY-1))/sCOUNT_OF_VIEWS_HORICONTALLY),
//                             floor((contentHeight-sDROPVIEW_MARGIN*(sCOUNT_OF_VIEWS_VERTICALLY-1))/sCOUNT_OF_VIEWS_VERTICALLY));
//	
//    JDDroppableView * dropview = [[JDDroppableView alloc] initWithScrollView: mScrollView
//                                                           andDropTarget: mDropTarget];
//    dropview.backgroundColor = [UIColor blackColor];
//    dropview.layer.cornerRadius = 3.0;
//    dropview.frame = CGRectMake(mLastPosition.x, mLastPosition.y, size.width, size.height);
//    dropview.delegate = self;
//
//    [mScrollView addSubview: dropview];
//    [dropview release];
//    
//    [self relayout];
//    
//    // scroll to bottom, if added manually
//    if ([sender isKindOfClass: [UIButton class]]) {
//        [self scrollToBottomAnimated: YES];
//    }
//}


// add new view t
- (void) makeSmall
{
    if(mSmall) {
        for (UIView* subview in mScrollView.subviews) {
        
            CGRect frame = subview.frame;
            frame.size.width *= 0.5;
            frame.size.height *= 0.5;
            frame.origin.x += (subview.frame.size.width-frame.size.width)/2;
            frame.origin.y += (subview.frame.size.height-frame.size.height)/2;
    
            [UIView beginAnimations: @"drag" context: nil];
            [UIView setAnimationDelegate: subview];
      
    
            subview.frame = frame;
            //subview.center = CGPointMake(mDropTarget.center.x - 320, mDropTarget.center.y);
    
            [UIView commitAnimations];
    
            [self relayout];
            [mScrollView flashScrollIndicators];
        }
        mSmall = NO;
    }



}

- (void) addAllView:(NSNumber *)count
{
    CGFloat contentWidth  = mScrollView.frame.size.width  - mScrollView.contentInset.left - mScrollView.contentInset.right;
    CGFloat contentHeight = mScrollView.frame.size.height - mScrollView.contentInset.top;
	CGSize size = CGSizeMake(((contentWidth-sDROPVIEW_MARGIN*(sCOUNT_OF_VIEWS_HORICONTALLY-1))/sCOUNT_OF_VIEWS_HORICONTALLY),
                             floor((contentHeight-sDROPVIEW_MARGIN*(sCOUNT_OF_VIEWS_VERTICALLY-1))/sCOUNT_OF_VIEWS_VERTICALLY));
	
    JDDroppableView * dropview = [[JDDroppableView alloc]initWithScrollView:mScrollView
                                                               andDropTarget: mDropTarget
                                                                setNumber:[count intValue]];
    dropview.backgroundColor = [UIColor blackColor];
    dropview.layer.cornerRadius = 3.0;
    dropview.frame = CGRectMake(mLastPosition.x, mLastPosition.y, size.width*2, size.height*1.5);
    dropview.delegate = self;
     
    // use the picture
    for(int i = 0; i < 9; i++) {
        if(i == [count intValue]) {
            NSString * imagecount = [[NSString alloc] initWithFormat:@"00%d.jpg",i];
            UIImage *image = [UIImage imageNamed:imagecount];
            dropview.layer.contents  = (id)image.CGImage;
        }
    }
    
    [mScrollView addSubview: dropview];
//    [dropview setPosition:dropview.center];    //save the old position
//     NSLog(@"(x:%0.1f,y:%0.1f)",dropview.center.x,dropview.center.y);
//    [dropview release];
    
     [self relayout];
     //for (UIView* subview in mScrollView.subviews)
     [dropview setPosition:dropview.center];    //save the old position
     [dropview release];   
}


- (void) scrollToBottomAnimated: (BOOL) animated
{
    [mScrollView.layer removeAllAnimations];
    
    CGFloat bottomScrollPosition = mScrollView.contentSize.height;
    bottomScrollPosition -= mScrollView.frame.size.height;
    bottomScrollPosition += mScrollView.contentInset.top;
    bottomScrollPosition = MAX(-mScrollView.contentInset.top,bottomScrollPosition);
    CGPoint newOffset = CGPointMake(-mScrollView.contentInset.left, bottomScrollPosition);
    if (newOffset.y != mScrollView.contentOffset.y) {
        [mScrollView setContentOffset: newOffset animated: animated];
    }
}

#pragma -
#pragma droppabe view delegate

- (BOOL) shouldAnimateDroppableViewBack: (JDDroppableView *)view wasDroppedOnTarget: (UIView *)target
{
//	[self droppableView: view leftTarget: target];
//    
//    CGRect frame = view.frame;
//    frame.size.width *= 0.3;
//    frame.size.height *= 0.3;
//    frame.origin.x += (view.frame.size.width-frame.size.width)/2;
//    frame.origin.y += (view.frame.size.height-frame.size.height)/2;
//    
//    [UIView beginAnimations: @"drag" context: nil];
//    [UIView setAnimationDelegate: view];
//    //[UIView setAnimationDidStopSelector: @selector(removeFromSuperview)];
//    
//    view.frame = frame;
//    view.center = CGPointMake(target.center.x - 320, target.center.y);
//    //view.center = target.center;
//    
//    
//    [UIView commitAnimations];
//    
//    [self relayout];
//    [mScrollView flashScrollIndicators];
    
    if(flipViewScore.intValue < 9) {
        //[myScore setScore:newScore+11];
        //newScore += 11;
        //NSString * myNewScore = [[NSString alloc] initWithFormat:@"YourScore:%d",[myScore Score]];
        //scoreLabel.text =myNewScore;
        //[self.view addSubview:scoreLabel];
        [flipViewScore animateUp];
    }
    return NO;
}

- (void) droppableViewBeganDragging:(JDDroppableView *)view
{
	[UIView beginAnimations: @"drag" context: nil];
	view.backgroundColor = [UIColor colorWithRed: 1 green: 0.5 blue: 0 alpha: 1];
	view.alpha = 0.8;
	[UIView commitAnimations];
}

- (void) droppableView:(JDDroppableView *)view enteredTarget:(UIView *)target
{
//    target.transform = CGAffineTransformMakeScale(1.5, 1.5);
//    target.backgroundColor = [UIColor greenColor];
}

- (void) droppableView:(JDDroppableView *)view leftTarget:(UIView *)target
{
//    target.transform = CGAffineTransformMakeScale(1.0, 1.0);
//    target.backgroundColor = [UIColor orangeColor];
}

- (void) droppableViewEndedDragging:(JDDroppableView *)view
{
	[UIView beginAnimations: @"drag" context: nil];
	view.backgroundColor = [UIColor blackColor];
	view.alpha = 1.0;
	[UIView commitAnimations]; 
}

- (void) handleTimer
{
    //reset mylefttime
    if (!flagWin) {
//        leftTime -= 1;
//        NSString *myTime = [NSString stringWithFormat:@"YourLeftTime: %ds",leftTime];
//        timeLabel.text = myTime;
        if ( flipViewScore.intValue == 9)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"YOU WIN" message:@"YOU WIN THE GAME!SO COOL!" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
            flagWin = YES;
            [flipViewTime stopAnimation];
        }
        
        //times up
        if (flipViewTime.intValue == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"YOU failure" message:@"YOU LOSE THE GAME!SO BAD!" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
            flagWin = YES;
            [flipViewTime stopAnimation];
            //flipView.intValue = 11;
            //[flipViewTime reloadInputViews];
            //[flipView setIntValue:111];
        }
        
    }
}

-(void) exitAll
{
    //use for 
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @"DO YOU WANT TO OUT?"
                           delegate:(id)self
                           cancelButtonTitle:@"DO YOU WANT TO OUT?"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"Out",@"No", nil];
    
    menu.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    //UIActionSheetStyleDefault 
    //UIActionSheetStyleBlackTranslucent
    [menu showInView:self.view];

}

# pragma mark UIActionSheet method
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
           exit(0);    //out
    }else if(buttonIndex==1){
            //do nothing
    }
    
    [actionSheet release];
}
@end
