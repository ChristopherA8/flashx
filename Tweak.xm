@interface CSQuickActionsButton : UIView
@end

@interface CSQuickActionsView : UIView
@property (nonatomic,retain) CSQuickActionsButton * flashlightButton;
@end

@interface AVFlashlight : NSObject
-(BOOL)setFlashlightLevel:(float)arg1 withError:(id*)arg2 ;
@end


static UIButton *button;
static BOOL flashlightEnabled = NO;

%hook CSQuickActionsView
-(void)layoutSubviews {
    %orig;
    if (!button) {
        button = [%c(UIButton) buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(toggleFlashlight) forControlEvents:UIControlEventTouchUpInside];
        button.frame = self.frame;
        [self.flashlightButton addSubview:button];
    }
}
%new
-(void)toggleFlashlight {
	static AVFlashlight *flashlight = [[%c(AVFlashlight) alloc] init];

    if (flashlightEnabled) {
        [flashlight setFlashlightLevel:0 withError:nil];
        flashlightEnabled = NO;
    } else {
        [flashlight setFlashlightLevel:1 withError:nil];
        flashlightEnabled = YES;
    }

}
%end