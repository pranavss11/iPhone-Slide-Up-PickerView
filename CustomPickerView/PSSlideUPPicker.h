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

#import <Foundation/Foundation.h>

typedef enum {
    PSAnimationSlideUp = 0,
    PSAnimationSlideDown,
} PSAnimationType;

@protocol PSSlideUPPickerDelegate;

@interface PSSlideUPPicker : NSObject <UIPickerViewDelegate, UIPickerViewDataSource>{
    id <PSSlideUPPickerDelegate> delegate;
    
    UIView *delegatesView; //Add slideUpView to the original view once ready.
    UIView *slideUpView; 
    UIPickerView *pickerView; //Added to slideUpView
    UIToolbar *toolBar;
    
    NSArray *pickerData;
    
    BOOL pickerHasMultipleComponents; 
    NSInteger numberOfPickerComponents;
    
    NSInteger selectedIndex; //Used when only one component in picker.
    NSArray *selectedIndexes; //Used for multiple components in picker. Contains NSNumber objects.
    
    PSAnimationType animationType;
}

@property (nonatomic, assign) id<PSSlideUPPickerDelegate> delegate;

@property (nonatomic, retain) UIView *delegatesView;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UIView *slideUpView;
@property (nonatomic, retain) UIToolbar *toolBar;

@property (nonatomic, retain) NSArray *pickerData;

@property (nonatomic, assign) NSInteger numberOfPickerComponents;
@property (nonatomic, assign) BOOL pickerHasMultipleComponents;

@property (nonatomic, assign) NSInteger selectedIndex;

//Used only for multiple components.
//Structure: objectAtIndex 0 contains selectedIndex for Component 0.
@property (nonatomic, retain) NSArray *selectedIndexes;

@property (nonatomic, assign) PSAnimationType animationType;

/*
 Used for Regular pickers with just one component. 
 */
- (id)initWithPickerData:(NSArray *)data forView:(UIView *)theView delegate:(id)del withSelectedIndex:(NSInteger)index;
/*
 Used for Pickers with multiple components.
 data = An array of arrays: objectAtIndex 0 contains pickerdata array for 
 component 0, objectAtIndex 1 contains pickerdata array for component 1.
 indexes = objectAtIndex 0 contains selectedIndex for component 0, objectAtIndex 1 contains selectedIndex for component 1.
 */
- (id)initWithMultipleComponents:(NSInteger)totalComponents withPickerData:(NSArray *)data forView:(UIView *)theView delegate:(id)del withSelectedIndexes:(NSArray *)indexes;
/*
 Always should be called after initialization to show the picker.
 */
- (void)showPSPicker;

@end

@protocol PSSlideUPPickerDelegate<NSObject>
@optional 
- (void)didSelectIndex:(NSInteger)selectedIndex;
- (void)didSelectIndex:(NSInteger)selectedIndex forComponent:(NSInteger)component;
- (void)didSelectData:(id)selectedData;
- (void)didSelectData:(id)selectedData forComponent:(NSInteger)component;
@end
