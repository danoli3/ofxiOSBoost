#import <UIKit/UIKit.h>

#include "BoostTests.hpp"

#include <cstdio>
#include <cstdlib>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property(nonatomic, strong) UIWindow *window;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) NSTimer *testTimer;
@property(nonatomic, strong) NSMutableString *testReport;
@property(nonatomic, assign) NSUInteger testIndex;
@property(nonatomic, assign) BOOL allTestsPassed;
@property(nonatomic, assign) BOOL ciMode;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    (void)application;
    (void)launchOptions;

    UIViewController *controller = [[UIViewController alloc] init];
    controller.view.backgroundColor = UIColor.whiteColor;

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
    const std::string header = boostTestReportHeader();
    self.testReport = [NSMutableString stringWithUTF8String:header.c_str()];
    self.testIndex = 0;
    self.allTestsPassed = YES;
    self.ciMode = std::getenv("OFXIOSBOOST_CI") != nullptr;
    self.textView = textView;
    textView.text = self.testReport;
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

    [self writeCurrentReport];
    self.testTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0)
        target:self
        selector:@selector(runNextBoostTest:)
        userInfo:nil
        repeats:YES];
    return YES;
}

- (NSString *)reportPath
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:
        @"ofxiOSBoost-smoke-report.txt"];
}

- (void)writeCurrentReport
{
    NSError *writeError = nil;
    if (![self.testReport writeToFile:self.reportPath
                           atomically:YES
                             encoding:NSUTF8StringEncoding
                                error:&writeError]) {
        NSLog(@"Failed to write smoke-test report: %@", writeError);
        [self.testTimer invalidate];
        if (self.ciMode) {
            std::_Exit(EXIT_FAILURE);
        }
    }
}

- (void)runNextBoostTest:(NSTimer *)timer
{
    (void)timer;
    if (self.testIndex >= boostTestCount()) {
        [self.testTimer invalidate];
        self.testTimer = nil;
        [self.testReport appendFormat:@"\n%@",
            self.allTestsPassed ? @"ALL TESTS PASSED" : @"TESTS FAILED"];
        self.textView.text = self.testReport;
        self.window.rootViewController.view.backgroundColor = self.allTestsPassed
            ? [UIColor colorWithRed:0.90 green:1.0 blue:0.92 alpha:1.0]
            : [UIColor colorWithRed:1.0 green:0.90 blue:0.90 alpha:1.0];
        [self writeCurrentReport];
        NSLog(@"\n%@", self.testReport);

        if (self.ciMode) {
            std::fprintf(stdout, "%s\n", self.testReport.UTF8String);
            std::fflush(stdout);
            std::_Exit(self.allTestsPassed ? EXIT_SUCCESS : EXIT_FAILURE);
        }
        return;
    }

    const BoostTestResult result = runBoostTestAtIndex(self.testIndex);
    self.allTestsPassed = self.allTestsPassed && result.passed;
    NSString *entry = [NSString stringWithUTF8String:result.report.c_str()];
    [self.testReport appendString:entry];
    self.textView.text = self.testReport;
    [self.textView scrollRangeToVisible:
        NSMakeRange(self.textView.text.length, 0)];
    ++self.testIndex;

    // Persist after every frame so a device crash or hang leaves the last
    // completed test visible in the report.
    [self writeCurrentReport];
}

@end

int main(int argc, char *argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(AppDelegate.class));
    }
}
