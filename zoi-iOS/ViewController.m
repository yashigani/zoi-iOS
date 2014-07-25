//
//  ViewController.m
//  zoi-iOS
//
//  Created by yashigani on 2014/07/25.
//
//

#import "ViewController.h"
#import <Social/Social.h>

@interface ViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://zoi.herokuapp.com"]];
    [self.webView loadRequest:req];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)tweetTapped:(id)sender
{
    NSString *href = [self.webView stringByEvaluatingJavaScriptFromString:@"document.querySelector('h1.text-center > a').href"];
    [self tweet:[NSURL URLWithString:href]];
}

- (void)tweet:(NSURL *)tweetURL
{
    NSMutableDictionary *query = NSMutableDictionary.dictionary;
    for (NSString *p in [tweetURL.query componentsSeparatedByString:@"&"]) {
        NSArray *pair = [p componentsSeparatedByString:@"="];
        query[pair.firstObject] = pair.lastObject;
    }
    SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    NSString *pic = [@"https://" stringByAppendingString:query[@"text"]];
    [vc addURL:[NSURL URLWithString:[pic substringToIndex:pic.length - 4]]];
    vc.initialText = [@"#" stringByAppendingString:query[@"hashtags"]];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.host isEqual:@"twitter.com"]) {
        [self tweet:request.URL];
        return NO;
    }
    self.navigationItem.leftBarButtonItem.enabled = NO;
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

@end
