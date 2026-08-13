#import <UIKit/UIKit.h>

#include "BoostTests.hpp"

#include <cstdio>
#include <cstdlib>

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

    if (std::getenv("OFXIOSBOOST_CI") != nullptr) {
        NSString *reportPath =
            [NSTemporaryDirectory() stringByAppendingPathComponent:
                @"ofxiOSBoost-smoke-report.txt"];
        NSError *writeError = nil;
        if (![report writeToFile:reportPath
                      atomically:YES
                        encoding:NSUTF8StringEncoding
                           error:&writeError]) {
            NSLog(@"Failed to write CI report: %@", writeError);
            std::_Exit(EXIT_FAILURE);
        }
        std::fprintf(stdout, "%s\n", result.report.c_str());
        std::fflush(stdout);
        std::_Exit(result.passed ? EXIT_SUCCESS : EXIT_FAILURE);
    }

    UIViewController *controller = [[UIViewController alloc] init];
    controller.view.backgroundColor = result.passed
        ? [UIColor colorWithRed:0.90 green:1.0 blue:0.92 alpha:1.0]
        : [UIColor colorWithRed:1.0 green:0.90 blue:0.90 alpha:1.0];

    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.editable = NO;
    textView.selectable = YES;
    textView.scrollEnabled = YES;
    textView.alwaysBounceVertical = YES;
    textView.showsVerticalScrollIndicator = YES;
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
    [controller.view layoutIfNeeded];
    [textView setContentOffset:CGPointZero animated:NO];
    return YES;
}

@end

int main(int argc, char *argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(AppDelegate.class));
    }
}
