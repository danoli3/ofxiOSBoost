#import <UIKit/UIKit.h>

#include "BoostTests.hpp"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property(nonatomic, strong) UIWindow *window;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    (void)application;
    (void)launchOptions;

    BoostTestResult result = runBoostTests();
    NSString *report = [NSString stringWithUTF8String:result.report.c_str()];
    NSLog(@"\n%@", report);

    UIViewController *controller = [[UIViewController alloc] init];
    controller.view.backgroundColor = result.passed
        ? [UIColor colorWithRed:0.90 green:1.0 blue:0.92 alpha:1.0]
        : [UIColor colorWithRed:1.0 green:0.90 blue:0.90 alpha:1.0];

    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.editable = NO;
    textView.backgroundColor = UIColor.clearColor;
    textView.textColor = UIColor.blackColor;
    textView.font = [UIFont monospacedSystemFontOfSize:16.0
                                              weight:UIFontWeightRegular];
    textView.text = report;
    [controller.view addSubview:textView];
    [NSLayoutConstraint activateConstraints:@[
        [textView.leadingAnchor constraintEqualToAnchor:controller.view.safeAreaLayoutGuide.leadingAnchor constant:16.0],
        [textView.trailingAnchor constraintEqualToAnchor:controller.view.safeAreaLayoutGuide.trailingAnchor constant:-16.0],
        [textView.topAnchor constraintEqualToAnchor:controller.view.safeAreaLayoutGuide.topAnchor constant:16.0],
        [textView.bottomAnchor constraintEqualToAnchor:controller.view.safeAreaLayoutGuide.bottomAnchor constant:-16.0]
    ]];

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    return YES;
}

@end

int main(int argc, char *argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(AppDelegate.class));
    }
}
