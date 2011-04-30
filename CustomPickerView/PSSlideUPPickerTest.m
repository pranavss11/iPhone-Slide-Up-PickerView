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


//NOTE: This is just a rough test class that I created for convenience. 

#import "PSSlideUPPickerTest.h"


@implementation PSSlideUPPickerTest

@synthesize button, componentButton;
@synthesize picker;
@synthesize indexForPickerWithOneComponent;
@synthesize indexesForPickerWithMultipleComponents;
@synthesize selectedDate;

- (void)dealloc
{
    [self.button release];
    [self.componentButton release];
    [self.picker release];
    [self.selectedDate release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (IBAction)openPicker:(id)sender {
    NSMutableArray *testArray = [[NSMutableArray alloc] init];
    [testArray addObject:@"Test 1"];
    [testArray addObject:@"Test 2"];
    [testArray addObject:@"Test 3"];
    picker = [[PSSlideUPPicker alloc] initWithPickerData:testArray forView:self.view delegate:self withSelectedIndex:indexForPickerWithOneComponent];
    [picker showPSPicker];
    [testArray release];
}

- (void)viewDidLoad {
    //This capacity will depend on the comp array defined in openMultipleComponentPicker
    //Defaulting to Index 0.
    indexesForPickerWithMultipleComponents = [[NSMutableArray alloc] init];
    [indexesForPickerWithMultipleComponents addObject:[NSNumber numberWithInt:0]];
    [indexesForPickerWithMultipleComponents addObject:[NSNumber numberWithInt:0]];
    self.selectedDate = [NSDate date];
}

- (IBAction)openMultipleComponentPicker:(id)sender {
    NSMutableArray *testArray = [[NSMutableArray alloc] init];
    [testArray addObject:@"Test 1"];
    [testArray addObject:@"Test 2"];
    [testArray addObject:@"Test 3"];
    
    NSMutableArray *testArray2 = [[NSMutableArray alloc] init];
    [testArray2 addObject:@"Stuff 1"];
    [testArray2 addObject:@"Stuff 2"];
    [testArray2 addObject:@"Stuff 3"];
    
    NSMutableArray *comp = [[NSMutableArray alloc] init];
    [comp addObject:testArray];
    [comp addObject:testArray2];
    
    [testArray release];
    [testArray2 release];
    
    picker = [[PSSlideUPPicker alloc] initWithMultipleComponents:[comp count] withPickerData:comp forView:self.view delegate:self withSelectedIndexes:indexesForPickerWithMultipleComponents];
    [picker showPSPicker];
    [comp release];
}

- (IBAction)openDatePicker:(id)sender {
    picker = [[PSSlideUPPicker alloc] initWithDatePickerforView:self.view delegate:self withSelectedDate:self.selectedDate andDatePickerMode:UIDatePickerModeDateAndTime];
    [picker showPSPicker];
}

- (void)didSelectData:(id)selectedData {
    NSLog(@"Data %@", selectedData);
}

- (void)didSelectIndex:(NSInteger)selectedIndex {
    NSLog(@"Index %i", selectedIndex);
    indexForPickerWithOneComponent = selectedIndex;
}

- (void)didSelectIndex:(NSInteger)selectedIndex forComponent:(NSInteger)component {
    [indexesForPickerWithMultipleComponents replaceObjectAtIndex:component withObject:[NSNumber numberWithInt:selectedIndex]];
    NSLog(@"Index %i, %i", selectedIndex, component);
}

- (void)didSelectData:(id)selectedData forComponent:(NSInteger)component {
    NSLog(@"Data %@ %i", selectedData, component);
}

- (void)didSelectDate:(NSDate *)date {
    NSLog(@"Date %@", date);
    self.selectedDate = date;
}

@end
