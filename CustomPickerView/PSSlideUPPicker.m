/*
 Email: pranavss11@gmail.com
 Copyright (c) 2011, Pranav Shah, http://www.sourcebits.com/
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following 
 conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer 
 in the documentation and/or other materials provided with the distribution.
 Neither the names of Pranav Shah, Sourcebits Inc, nor the names of its contributors may be used to endorse or promote products 
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
 BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "PSSlideUPPicker.h"

#define slideUPViewFrame        CGRectMake(0.0, 0.0, 320.0, 480.0)
#define pickerViewFrame         CGRectMake(0.0, 244.0, 320.0, 216.0) //SDK has visual glitches for height other than 216.0
#define pickerViewFrameHidden   CGRectMake(0, 480.0, 320.0, 216.0)
#define toolBarFrame            CGRectMake(0.0, 204.0, 320.0, 40.0)
#define toolBarFrameHidden      CGRectMake(0.0, 480.0, 320.0, 40.0)

#define PSCustomColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define PSAnimationColorInitial     PSCustomColor(65,65,65,0.0f)
#define PSAnimationColorAnimated    PSCustomColor(65,65,65,0.5f)

@interface PSSlideUPPicker() 

- (void)performAnimation:(PSAnimationType)animation;
- (void)animationCompleted;
- (void)createToolBar;

@end

@implementation PSSlideUPPicker

@synthesize delegate;
@synthesize delegatesView;
@synthesize pickerData;
@synthesize pickerView;
@synthesize slideUpView;
@synthesize toolBar;
@synthesize numberOfPickerComponents;
@synthesize pickerHasMultipleComponents;
@synthesize animationType;
@synthesize selectedIndex;
@synthesize selectedIndexes;

#pragma mark - Memory Management 
- (void)dealloc {
    [self.pickerData release];
    [self.pickerView release];
    [self.slideUpView release];
    [self.delegatesView release];
    [self.selectedIndexes release];
    [self.toolBar release];
    
    self.pickerView.delegate = nil;
    self.pickerView.dataSource = nil;
    [super dealloc];
}

#pragma mark - Initialization 
//For one component.
- (id)initWithPickerData:(NSArray *)data forView:(UIView *)theView delegate:(id)del withSelectedIndex:(NSInteger)index {
    if(self == [super init]) {
        self.pickerHasMultipleComponents = NO;
        self.pickerData = data;
        self.delegatesView = theView;
        self.delegate = del;
        self.selectedIndex = index;
    }
    return self;
}


//pickerData objectAtIndex: 0 = first component data, 1 = second component data, 3 = third component data
//selectedIndexes objectAtIndex:0 = first component selected index,1 = second component selected Index, 3 = third component selected Index
- (id)initWithMultipleComponents:(NSInteger)totalComponents withPickerData:(NSArray *)data forView:(UIView *)theView delegate:(id)del withSelectedIndexes:(NSArray *)indexes {
    if(self == [super init]) {
        self.pickerHasMultipleComponents = YES;
        self.numberOfPickerComponents = totalComponents;
        self.pickerData = data;
        self.delegatesView = theView;
        self.delegate = del;
        self.selectedIndexes = [NSArray arrayWithArray:indexes];
    }
    return self;
}

#pragma mark - Picker Controls
- (void)showPSPicker {
    self.slideUpView = [[UIView alloc] initWithFrame:slideUPViewFrame];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:pickerViewFrameHidden];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    
    if(!pickerHasMultipleComponents) {
        [self.pickerView selectRow:selectedIndex inComponent:0 animated:NO];
    } 
    else {
        for(NSInteger i = 0; i < [selectedIndexes count]; i ++) {
            [self.pickerView selectRow:[[selectedIndexes objectAtIndex:i] intValue] inComponent:i animated:NO];
        }
    }
    
    [self createToolBar];
    [self.slideUpView addSubview:self.toolBar];
    [self.slideUpView addSubview:self.pickerView];
    [self.pickerView release];
    [self.toolBar release];

    [self performAnimation:PSAnimationSlideUp];
}

- (void)createToolBar {
    self.toolBar = [[UIToolbar alloc] initWithFrame:toolBarFrameHidden];
    self.toolBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelPicker)];
    NSArray *toolBarItems = [NSArray arrayWithObject:cancelBarButton];
    [cancelBarButton release];
    [toolBar setItems:toolBarItems];
}

- (void)cancelPicker {
    [self performAnimation:PSAnimationSlideDown];
}

#pragma mark View Animation
- (void)performAnimation:(PSAnimationType)animation {
    switch (animation) {
        case PSAnimationSlideUp:
            [self.delegatesView addSubview:self.slideUpView];
            self.slideUpView.backgroundColor = PSAnimationColorInitial;

            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4f];
            [UIView setAnimationDelegate:self];
            self.slideUpView.backgroundColor = PSAnimationColorAnimated;
            self.pickerView.frame = pickerViewFrame;
            self.toolBar.frame = toolBarFrame;
            [UIView commitAnimations];	
            break;
        case PSAnimationSlideDown:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4f];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animationCompleted)];
            self.slideUpView.backgroundColor = PSAnimationColorAnimated;
            self.pickerView.frame = pickerViewFrameHidden;
            self.toolBar.frame = toolBarFrameHidden;
            [UIView commitAnimations];	
            break;   
        default:
            NSLog(@"Invalid Animation!");
            break;
    }
}

- (void)animationCompleted {
    [self.slideUpView removeFromSuperview];
}

#pragma mark - Picker View Delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //Update delegates
    if(!pickerHasMultipleComponents) {
        if([self.delegate respondsToSelector:@selector(didSelectData:)] && [self.delegate respondsToSelector:@selector(didSelectIndex:)]) {
            [self.delegate didSelectIndex:row];
            [self.delegate didSelectData:[self.pickerData objectAtIndex:row]];
        }
        else if([self.delegate respondsToSelector:@selector(didSelectIndex:)]) {
            [self.delegate didSelectIndex:row];
        }
        else if([self.delegate respondsToSelector:@selector(didSelectData:)]) {
            [self.delegate didSelectData:[self.pickerData objectAtIndex:row]]; 
        }
    }
    else {
        if([self.delegate respondsToSelector:@selector(didSelectIndex:forComponent:)] && [self.delegate respondsToSelector:@selector(didSelectData:forComponent:)]) {
            [self.delegate didSelectIndex:row forComponent:component];
            [self.delegate didSelectData:[[self.pickerData objectAtIndex:component] objectAtIndex:row] forComponent:component];
        }
        else if([self.delegate respondsToSelector:@selector(didSelectIndex:forComponent:)]) {
            [self.delegate didSelectIndex:row forComponent:component];
        }
        else if([self.delegate respondsToSelector:@selector(didSelectData:forComponent:)]) {
            [self.delegate didSelectData:[[self.pickerData objectAtIndex:component] objectAtIndex:row] forComponent:component];
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if(!pickerHasMultipleComponents)
        return 1;
    
	return numberOfPickerComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(!pickerHasMultipleComponents)
        return [self.pickerData count];
    
    return [[self.pickerData objectAtIndex:component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(!pickerHasMultipleComponents) 
        return [self.pickerData objectAtIndex:row];
    
    return [[self.pickerData objectAtIndex:component] objectAtIndex:row];
    
}

@end
