//
//  WebController.m
//  TTManager
//
//  Created by chao liu on 2020/12/28.
//

#import "WebController.h"
#import <WebKit/WebKit.h>

@interface WebController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) UIProgressView *loadingProgressView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *close;
@property (nonatomic, strong) UIBarButtonItem *goBack;
@property (nonatomic, strong) UIBarButtonItem *refresh;
@end

@implementation WebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self addWebViewAndBottomBarViewWithLoadUrl:self.loadUrl];
}

#pragma mark - Lazy load

- (UIProgressView* )loadingProgressView
{
    if (!_loadingProgressView)
    {
        _loadingProgressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        _loadingProgressView.progressTintColor = [UIColor colorWithRed:234/255.00 green:152/255.00 blue:0/255.00 alpha:1];
        _loadingProgressView.trackTintColor = RGBA_COLOR(58, 59, 60, 1.0);
    }
    return _loadingProgressView;
}
- (UIRefreshControl* )refreshControl
{
    if (!_refreshControl)
    {
        _refreshControl = [[UIRefreshControl alloc]init];
        [_refreshControl addTarget:self action:@selector(webViewReload) forControlEvents:UIControlEventValueChanged];
        _refreshControl.hidden = YES;
    }
    return _refreshControl;
}
- (WKWebView* )webView
{
    if (!_webView)
    {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        config.preferences = [[WKPreferences alloc]init];
        config.preferences.minimumFontSize = 0.0f;
        config.allowsInlineMediaPlayback = YES;
        config.selectionGranularity = YES;
        config.mediaTypesRequiringUserActionForPlayback = YES;
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        //添加此属性可触发侧滑返回上一网页与下一网页操作
        _webView.allowsBackForwardNavigationGestures = YES;
        // 添加进度监听
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:(NSKeyValueObservingOptionNew) context:nil];
    }
    return _webView;
}

- (UIBarButtonItem *)close{
    if (_close == nil) {
        _close = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeView)];
    }
    return _close;
}
- (UIBarButtonItem *)goBack{
    if (_goBack == nil) {
        _goBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(bottomToolItemBack)];
    }
    return _goBack;
}
- (UIBarButtonItem *)refresh{
    if (_refresh == nil) {
//        _refresh = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(bottomToolItemRefresh)];
        _refresh = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(bottomToolItemRefresh)];
    }
    return _refresh;
}
- (void)fileView:(NSDictionary *)fileViewDic{
    NSString *url = [NSString stringWithFormat:@"%@%@%@?",FILESERVICEADDRESS,@"/fileviewservice/FileView/",fileViewDic[@"uid_target"]];
    for (id key in [fileViewDic allKeys]) {
        url = [url urlAddCompnentForValue:fileViewDic[key] key:key];
    }
    self.loadUrl = url;
}

#pragma mark - Action
- (void)closeView{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - UI

- (void)addWebViewAndBottomBarViewWithLoadUrl:(NSString *)loadUrl
{
    // 添加webView
    [self.view addSubview:self.webView];
    // 添加进度条
    [self.view addSubview:self.loadingProgressView];
    
    [self addViewCustomLaytou];

    [self requestUrl:loadUrl];
    
    self.navigationItem.leftBarButtonItems = @[self.close,self.goBack,self.refresh];
}
- (void)addViewCustomLaytou{
    [self.loadingProgressView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(2);

    }];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loadingProgressView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}
- (void)requestUrl:(NSString *)url
{
    // 加载初始化的url
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                           timeoutInterval:30.0]];
    NSLog(@"http:webUrl --->>> %@",url);
}
#pragma mark - WKNavigationDelegate
//开始加载网页
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    self.loadingProgressView.hidden = NO;
    // 看是否加载空网页
    if ([webView.URL.scheme isEqual:@"about"])
    {
        webView.hidden = YES;
    }
}
//网页加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.title = webView.title;
    self.webView.hidden = NO;
}

//网页加载错误
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if([error code] != NSURLErrorCancelled)
    {
        webView.hidden = NO;
        _loadingProgressView.hidden = NO;
        if ([webView.URL.scheme isEqual:@"about"])
        {
            webView.hidden = YES;
        }
    }
}
//当 WKWebView 总体内存占用过大，页面即将白屏的时候，系统会调用上面的回调函数，在该函数里执行[webView reload](这个时候 webView.URL 取值尚不为 nil）解决白屏问题
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    [webView reload];
}
// 网页加载错误时是否允许重新加载
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    UIApplication *app = [UIApplication sharedApplication];
    // 打电话
    if ([scheme isEqualToString:@"tel"])
    {
        if ([app canOpenURL:URL])
        {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
            [app openURL:URL];
#else
            [app openURL:URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES} completionHandler:nil];
#endif
            // 一定要加上这句,否则会打开新页面
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    // 打开appstore
    else if ([URL.absoluteString containsString:@"itunes.apple.com"])
    {
        if ([app canOpenURL:URL])
        {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
            [app openURL:URL];
#else
            [app openURL:URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES} completionHandler:nil];
#endif
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }else
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    // 判断服务器采用的验证方法
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        // 如果没有错误的情况下 创建一个凭证，并使用证书
        if (challenge.previousFailureCount == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }else {
            // 验证失败，取消本次验证
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);

    }
}

#pragma mark - UIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:^{}];

}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:^{}];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor whiteColor];
    }];

    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        _loadingProgressView.progress = [change[@"new"] floatValue];
        if (_loadingProgressView.progress == 1.0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.loadingProgressView.hidden = YES;
            });
        }
    }
}
- (void)dealloc{
    // 添加进度监听
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
#pragma mark webView Action
- (void)webViewReload
{
    [_webView reload];
}


- (void)bottomToolItemBack
{
    if ([self.webView canGoBack])
        [self.webView goBack];
}

- (void)bottomToolItemRefresh
{
    if (![self.webView isLoading])
        [self webViewReload];
}

- (void)bottomToolItemGoHome
{
    if (self.loadUrl)
        [self requestUrl:self.loadUrl];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
