//
//  ViewController.m
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import "ViewController.h"
#import "HZAreaPickerView.h"

@interface ViewController () <UITextFieldDelegate, HZAreaPickerDelegate, HZAreaPickerDatasource>

@property (retain, nonatomic) IBOutlet UITextField *areaText;
@property (retain, nonatomic) IBOutlet UITextField *cityText;
@property (strong, nonatomic) NSString *areaValue, *cityValue;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;

-(void)cancelLocatePicker;

@end

@implementation ViewController
@synthesize areaText;
@synthesize cityText;
@synthesize areaValue=_areaValue, cityValue=_cityValue;
@synthesize locatePicker=_locatePicker;

- (void)dealloc {
    [areaText release];
    [cityText release];
    [_cityValue release];
    [_areaValue release];
    [super dealloc];
}

-(void)setAreaValue:(NSString *)areaValue
{
    if (![_areaValue isEqualToString:areaValue]) {
        _areaValue = [areaValue retain];
        self.areaText.text = areaValue;
    }
}

-(void)setCityValue:(NSString *)cityValue
{
    if (![_cityValue isEqualToString:cityValue]) {
        _cityValue = [cityValue retain];
        self.cityText.text = cityValue;
    }
}

- (void)viewDidUnload
{
    [self setAreaText:nil];
    [self setCityText:nil];
    [self cancelLocatePicker];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    } else{
        self.cityValue = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
    }
}

-(NSArray *)areaPickerData:(HZAreaPickerView *)picker
{
    NSArray *data;
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        data = [[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]] autorelease];
    } else{
        data = [[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]] autorelease];
    }
    return data;
}



-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}


#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.areaText]) {
        [self cancelLocatePicker];
        self.locatePicker = [[[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict
                                                        withDelegate:self
                                                       andDatasource:self] autorelease];
        [self.locatePicker showInView:self.view];
    } else {
        [self cancelLocatePicker];
        self.locatePicker = [[[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity
                                                            withDelegate:self
                                                           andDatasource:self] autorelease];
        [self.locatePicker showInView:self.view];
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self cancelLocatePicker];
}

@end
