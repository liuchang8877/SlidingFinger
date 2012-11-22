//
//  JDDroppableView.m
//  JDDroppableView
//
//  Created by Markus Emrich on 01.07.10.
//  Copyright 2010 Markus Emrich. All rights reserved.
//

#import "JDDroppableView.h"

@interface JDDroppableView (hidden)
- (void) beginDrag;
- (void) dragAtPosition: (UITouch *) touch;
- (void) endDrag;

- (void) changeSuperView;
- (BOOL) handleDroppedView;
@end



@implementation JDDroppableView

@synthesize delegate = mDelegate;

- (id) initWithScrollView: (UIScrollView *) aScrollView andDropTarget: (UIView *) target setNumber:(int)myNumber
{
	self = [super init];
	if (self != nil) {
		
		mOuterView  = aScrollView.superview;
		mScrollView = aScrollView;
		
		mDropTarget = target;
        mIsOverTarget = NO;
        mBiger = YES;
        flagNumber = myNumber;
        isOk = NO;
    }
	return self;
}

#pragma touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make the picture to look bigger, just for once
    if (mBiger) {
        CGRect frame = self.frame;
        frame.size.width /= 0.5;
        frame.size.height /= 0.5;
        //frame.origin.x -= (self.frame.size.width-frame.size.width)/2;
        //frame.origin.y -= (self.frame.size.height-frame.size.height)/2;
        self.frame = frame;
        mBiger = NO;
    }
    
    [self beginDrag];
	[self dragAtPosition: [touches anyObject]];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dragAtPosition: [touches anyObject]];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   [self endDrag];
    NSLog(@"-----X:%0.1f, Y:%0.2f",self.center.x,self.center.y);
    if ([self isItorNot]) {
        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        [UIView beginAnimations: @"drag" context: nil];
        self.center = position;
        [UIView commitAnimations];
        if (!isOk) {
            [self handleDroppedView];
            isOk = YES;
        }
    }
    
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endDrag];
}

#pragma drag logic

- (void) beginDrag
{
    if ([mDelegate respondsToSelector: @selector(droppableViewBeganDragging:)]) {
        [mDelegate droppableViewBeganDragging: self];
    };
	
	mOriginalPosition = self.center;
	NSLog(@"******(x:%0.1f, y:%0.1f)\n",position.x,position.y);
	[self changeSuperView];
}


- (void) dragAtPosition: (UITouch *) touch
{
	[UIView beginAnimations: @"drag" context: nil];
	self.center = [touch locationInView: self.superview];
	[UIView commitAnimations];
	
	CGRect intersect = CGRectIntersection(self.frame, mDropTarget.frame);
	if (intersect.size.width > 10 || intersect.size.height > 10)
    {
        if (!mIsOverTarget)
        {
            mIsOverTarget = YES;
            
            if ([mDelegate respondsToSelector: @selector(droppableView:enteredTarget:)]) {
                [mDelegate droppableView: self enteredTarget: mDropTarget];
            }
        }
	}
    else if (mIsOverTarget)
    {
        mIsOverTarget = NO;
        
        if ([mDelegate respondsToSelector: @selector(droppableView:leftTarget:)]) {
            [mDelegate droppableView: self leftTarget: mDropTarget];
        }
	}
}


- (void) endDrag
{
    mIsOverTarget = NO;
    
    if([mDelegate respondsToSelector: @selector(droppableViewEndedDragging:)]) {
        [mDelegate droppableViewEndedDragging: self];
    }
	
	CGRect intersect = CGRectIntersection(self.frame, mDropTarget.frame);
	if (intersect.size.width > 10 || intersect.size.height > 10) {
        //if([self handleDroppedView]) {
            return;
        //}
	}

	[self changeSuperView];
	
    //use to reset his position  ---------
    
//    [UIView beginAnimations: @"drag" context: nil];
//    self.center = mOriginalPosition;
//    [UIView commitAnimations];
}

- (BOOL) handleDroppedView
{
    if ([mDelegate respondsToSelector: @selector(shouldAnimateDroppableViewBack:wasDroppedOnTarget:)]) {
        return ![mDelegate shouldAnimateDroppableViewBack: self wasDroppedOnTarget: mDropTarget];
    }
    return NO;
    
}


- (void) changeSuperView
{
    UIView * tmp = self.superview;
	
	[self removeFromSuperview];
	[mOuterView addSubview: self];
	
	mOuterView = tmp;
	
	// set new position
	
	CGPoint ctr = self.center;
	
	if (mOuterView == mScrollView) {
		
		ctr.x += mScrollView.frame.origin.x - mScrollView.contentOffset.x;
		ctr.y += mScrollView.frame.origin.y - mScrollView.contentOffset.y;
	} else {
		
		ctr.x -= mScrollView.frame.origin.x - mScrollView.contentOffset.x;
		ctr.y -= mScrollView.frame.origin.y - mScrollView.contentOffset.y;
	}

	self.center = ctr;
}

- (BOOL) setPosition:(CGPoint)myPosition
{
    position = myPosition;
    return YES;
}

- (BOOL) isItorNot
{
    if (fabs(self.center.x - position.x) < 100.0 && fabs(self.center.y - position.y) < 100.0)
    {
        //NSLog(@"a:%f b:%f ",fabs(self.center.x - position.x),fabs(self.center.y - position.y));
        return YES;
    }
    else
    {
        //NSLog(@"a:%f b:%f ",fabs(self.center.x - position.x),fabs(self.center.y - position.y));
        return NO;
        
    }
}

@end
