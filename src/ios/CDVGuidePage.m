//
//  GuisePage.m
//  GuisePage
//
//  Created by guogh on .
//
//

#import "CDVGuidePage.h"
@implementation CDVGuidePage
@synthesize viewH,viewW;
@synthesize DocumentsDirectory;
#pragma mark "API"
- (void)pluginInitialize
{
    viewW = [UIScreen mainScreen].bounds.size.width;
    viewH = [UIScreen mainScreen].bounds.size.height;
    
    //创建沙盒
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    DocumentsDirectory=[[NSMutableString alloc] initWithCapacity:500];
    [DocumentsDirectory appendString:[paths objectAtIndex:0]];
    [DocumentsDirectory appendString:@"/"];
    
    //创建 tupia 缓存目录
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *PhotoPath=[DocumentsDirectory stringByAppendingPathComponent:@"photo"];
    NSError *error;
    [fileMgr createDirectoryAtPath:PhotoPath withIntermediateDirectories:YES attributes:nil  error:&error];
    
    
    //
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"] == NO)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [self show:nil];
    }
    else if([[NSUserDefaults standardUserDefaults] boolForKey:@"downLaunch"] == NO)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"downLaunch"];
        [self showGuideInfo:nil];
    }
    
    [self getGuideViewInfo:nil];
}

//显示 默认配置的 引导页
- (void)show:(CDVInvokedUrlCommand *)command
{
    id pagesCount = [self.commandDelegate.settings objectForKey:[@"guideImageCount" lowercaseString]];
    if (pagesCount == nil || [pagesCount integerValue] ==0)
        return;
    
    NSInteger pages = [pagesCount integerValue];
    NSLog(@"w=%f;h=%f",viewW,viewH);
    
    [self.viewController.navigationController setNavigationBarHidden:YES];
    
    _guideView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,viewW+1,viewH)];
    _guideView.bounces = NO;
    _guideView.showsHorizontalScrollIndicator = NO;
    _guideView.showsVerticalScrollIndicator = NO;
    _guideView.pagingEnabled = YES;
    _guideView.delegate = self;
    [_guideView setContentSize:CGSizeMake(viewW*pages, viewH)];
    
    
    NSString *imageName=@"guide";
    NSString *imageAllName;
    
    if (viewH == 480)
    {
        imageAllName = [imageName stringByAppendingString:@"-480h"];
    }
    else if(viewH == 568)
    {
        imageAllName = [imageName stringByAppendingString:@"-568h"];
    }
    else if (viewH == 667)
    {
        imageAllName = [imageName stringByAppendingString:@"-667h"];
    }
    else if (viewH == 736)
    {
        imageAllName = [imageName stringByAppendingString:@"-736h"];
    }
    
    char count='a';
    for (int i=0; i<pages; i++)
    {
        char countAt=count+i;
        NSString *imageViewName=[[NSString stringWithFormat:@"%c-",countAt] stringByAppendingString:imageAllName];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*viewW,0, viewW,viewH)];
        imageView.userInteractionEnabled = YES;
        UIImage *image = [UIImage imageNamed:imageViewName];
        if (image == nil)
            image = [UIImage imageNamed:[[NSString stringWithFormat:@"%c-",countAt] stringByAppendingString:imageName]];
        
        if (image == nil)
        {
            NSLog(@"没有找到 引导页图片 1:%@ 2:%@",imageViewName,[[NSString stringWithFormat:@"%c-",countAt] stringByAppendingString:imageName]);
            return;
        }
        
        //
        imageView.image = image;
        
        //最后一张图片 加上btn
        if (i==pages-1)
        {
            UIButton* button  = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(25., viewH*4./5., viewW-50., 50.);
            button.backgroundColor = [UIColor colorWithRed:45/255.f green:168/255.f blue:225/255.f alpha:1];
            [button setTitle:NSLocalizedString(@"立即使用",nil) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(startUseApp) forControlEvents:UIControlEventTouchUpInside];//UIControlEventTouchUpInside
            [imageView addSubview:button];
        }
        
        
        [_guideView addSubview:imageView];
    }
    
    [self.viewController.view addSubview:_guideView];
}

-(void)startUseApp
{
    [_guideView removeFromSuperview];
}

#pragma  -mark scrollview delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    NSInteger page = scrollView.contentOffset.x /self.view.bounds.size.width;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    return YES;
}

#pragma mark 显示网络动态加载的图片
- (void)showGuideInfo:(CDVInvokedUrlCommand *)command
{
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:[DocumentsDirectory stringByAppendingString:@"guideInDic"]];
    GuideInfo *info = [self ModeInit:dic];
    NSInteger pages = [info.guideimageCount integerValue];
    
    [self.viewController.navigationController setNavigationBarHidden:YES];
    _guideView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,viewW+1,viewH)];
    _guideView.bounces = NO;
    _guideView.showsHorizontalScrollIndicator = NO;
    _guideView.showsVerticalScrollIndicator = NO;
    _guideView.pagingEnabled = YES;
    //    _guideView.delegate = self;
    [_guideView setContentSize:CGSizeMake(viewW*pages, viewH)];
    
    for (int i=0; i<pages; i++)
    {
        NSDictionary *dic = [info.imageArray objectAtIndex:i];
        NSString *name = [dic objectForKey:@"name"];
        
        NSString *imagePath = [DocumentsDirectory stringByAppendingString:[NSString stringWithFormat:@"photo/%@.png",name]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*viewW,0, viewW,viewH)];
        imageView.userInteractionEnabled = YES;
        UIImage *image = [UIImage imageNamed:imagePath];
        
        if (image == nil)
        {
            NSLog(@"加载 图片失败 %@",imagePath);
            return;
        }
        
        //
        imageView.image = image;
        [_guideView addSubview:imageView];
        
        //最后一张图片 加上btn
        if (i == pages-1)
        {
            UIButton* button  = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(25., viewH*4./5., viewW-50., 50.);
            button.backgroundColor = [UIColor colorWithRed:45/255.f green:168/255.f blue:225/255.f alpha:1];
            [button setTitle:NSLocalizedString(@"立即使用",nil) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(startUseApp) forControlEvents:UIControlEventTouchUpInside];//UIControlEventTouchUpInside
            [imageView addSubview:button];
            [self.viewController.view addSubview:_guideView];
        }
    }
}

//获取 guideInfo
-(void)getGuideViewInfo:(CDVInvokedUrlCommand *)command
{
    NSDictionary *paramter = [[NSDictionary alloc] initWithObjects:@[[NSString stringWithFormat:@"%f",viewH],[NSString stringWithFormat:@"%f",viewW]] forKeys:@[@"height",@"width"]];
    
    id guideInfoUrl = [self.commandDelegate.settings objectForKey:[@"guideInfoUrl" lowercaseString]];
    if (guideInfoUrl == nil) {
        NSLog(@"guideInfoUrl == nil");
        return;
    }
    
    [HttpResponse postRequestWithPath:guideInfoUrl paramters:paramter finshedBlock:^(NSData *data){
        NSError *error=nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error)
        {
            NSLog(@"json 错误 %@",[error localizedDescription]);
            return ;
        }
        
        //数据错误
        NSString *respCode=[NSString stringWithFormat:@"%@",[dic objectForKey:@"respCode"]];
        if (![respCode isEqualToString:@""])
        {
            NSLog(@"%@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"respMsg"]]);
            return;
        }
        
        
        //判断更新
        NSDictionary *guideInfo = [dic objectForKey:@"data"];
        GuideInfo *info = [self ModeInit:guideInfo];
        
        NSDictionary *oldDic = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@guideInDic",DocumentsDirectory]];
        GuideInfo *oldInfo = [self ModeInit:oldDic];
        
        if ([info.version isEqualToString:oldInfo.version])
            return;
        
        
        //删除 缓存图片
        [self removeImageArray:oldInfo.imageArray];
        
        //更新 文件
        [guideInfo writeToFile:[NSString stringWithFormat:@"%@guideInDic",DocumentsDirectory] atomically:YES];
        
        //跟新 图片
        [self downlodImage:info.imageArray];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"downLaunch"];
        
    } errorBlock:^(NSString *error){
        NSLog(@"%@",error);
    }];
}

//下载图片
-(void)downlodImage:(NSArray *)imageArray
{
    for (NSDictionary *imageInfo in imageArray)
    {
        NSString *name = [NSString stringWithFormat:@"%@",[imageInfo objectForKey:@"name"]];
        NSString *url = [NSString stringWithFormat:@"%@",[imageInfo objectForKey:@"url"]];
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[imageInfo objectForKey:@"name"]]];
        if (image == nil)
        {
            [HttpResponse postRequestWithPath:url paramters:nil finshedBlock:^(NSData* data){
                NSString *path = [DocumentsDirectory stringByAppendingString:[NSString stringWithFormat:@"photo/%@.png",name]];
                [data writeToFile:path atomically:YES];
                
            } errorBlock:^(NSString *erro){
                NSLog(@"%@",erro);
            }];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"downLaunch"];
}

//删除 缓存
-(void)removeImageArray:(NSArray *)imageArray
{
    for (NSDictionary *imageInfo in imageArray)
    {
        NSString *name = [NSString stringWithFormat:@"%@",[imageInfo objectForKey:@"name"]];
        NSString *path = [DocumentsDirectory stringByAppendingString:[NSString stringWithFormat:@"photo/%@.png",name]];
        
        BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:path];
        if (blHave)
        {
            NSError *error=nil;
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
        }
        else
        {
            NSLog(@"no  have");
        }
    }
}


-(GuideInfo*)ModeInit:(NSDictionary *)dic
{
    GuideInfo *guideInfo = [[GuideInfo alloc] init];
    guideInfo.version = [NSString stringWithFormat:@"%@",[dic objectForKey:@"version"]];
    guideInfo.guideimageCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"guideimageCount"]];
    guideInfo.imageArray = [dic objectForKey:@"imageArray"];
    
    return guideInfo;
}


@end




#pragma mark mode
@implementation GuideInfo
@synthesize version,guideimageCount,imageArray;

@end


#pragma mark  网络获取
@implementation HttpResponse

+ (void)postRequestWithPath:(NSString *)path
                  paramters:(NSDictionary *)paramters
               finshedBlock:(FinishBlock)finshblock
                 errorBlock:(ErrorBlock)errorblock
{
    HttpResponse *httpRequest = [[HttpResponse alloc]init];
    httpRequest.finishBlock = finshblock;
    httpRequest.errorBlock = errorblock;
    
    
    NSString *urlStr = [@"" stringByAppendingString:path];
    NSString *urlStradd = [urlStr stringByAppendingString:[HttpResponse parseParams:paramters]];
    NSLog(@"%@",urlStradd);
    
    NSURL *url = [NSURL URLWithString:[urlStradd stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *requset = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    
    [requset setHTTPMethod:@"POST"];
    [requset setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requset setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:requset delegate:httpRequest];
    [connection start];
    NSLog(connection ? @"连接创建成功" : @"连接创建失败");
    
    
    //    NSString *urlString = @"https://www.baidu.com/img/bdlogo.png";
}


/**
 *  接收到服务器回应的时回调
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (!self.resultData)
    {
        self.resultData = [[NSMutableData alloc]init];
    }
    else
    {
        [self.resultData setLength:0];
    }
    
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dic = [httpResponse allHeaderFields];
        NSLog(@"[network]allHeaderFields:%@",[dic description]);
    }
}


/**
 *  接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.resultData appendData:data];
}


/**
 *  数据传完之后调用此方法
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.resultData != nil)
    {
        if (self.finishBlock)
            self.finishBlock(self.resultData);
    }
    else
    {
        if (self.errorBlock)
            self.errorBlock(@"resultData = nil ");
    }
}


/**
 *  网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"network error : %@", [error localizedDescription]);
    
    if (self.errorBlock)
    {
        self.errorBlock([error localizedDescription]);
    }
}

//拼接参数
+ (NSString *)parseParams:(NSDictionary *)params
{
    NSString *keyValueFormat;
    NSMutableString *result = [[NSMutableString alloc] init];
    //实例化一个key枚举器用来存放dictionary的key
    NSEnumerator *keyEnum = [params keyEnumerator];
    id key;
    while (key = [keyEnum nextObject])
    {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&",key,[params valueForKey:key]];
        [result appendString:keyValueFormat];
        //NSLog(@"post()方法参数解析结果：%@",result);
    }
    return result;
}

@end























