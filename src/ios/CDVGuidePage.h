//
//  GuidePage.h
//  Hello
//
//  Created by guogunh on .
//
//

#import <Cordova/CDV.h>
#import <StoreKit/StoreKit.h>

@interface CDVGuidePage : CDVPlugin <NSURLConnectionDataDelegate>

@property (nonatomic) CGFloat viewH;
@property (nonatomic) CGFloat viewW;
@property (strong,nonatomic) UIScrollView *guideView;
@property (strong,nonatomic) NSMutableString *DocumentsDirectory;

//显示默认引导页
- (void)show:(CDVInvokedUrlCommand *)command;

//获取 guideInfo 跟新本地图片
-(void)getGuideViewInfo:(CDVInvokedUrlCommand *)command;

//显示动态加载 引导页
- (void)showGuideInfo:(CDVInvokedUrlCommand *)command;
@end


//mode
@interface GuideInfo : NSObject

@property (strong,nonatomic) NSString* version;
@property (strong,nonatomic) NSString *guideimageCount;
@property (strong,nonatomic) NSMutableArray *imageArray;

@end


#pragma mark 网络请求
/***************************************************************************/
typedef void (^FinishBlock)(NSData *dataDic);
typedef void (^ErrorBlock)(NSString *dataString);

@interface HttpResponse : NSObject<NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData *resultData;
@property (strong, nonatomic) FinishBlock finishBlock;
@property (strong, nonatomic) ErrorBlock errorBlock;

+ (void)postRequestWithPath:(NSString *)path
                  paramters:(NSDictionary *)paramters
               finshedBlock:(FinishBlock)finshblock
                 errorBlock:(ErrorBlock)errorblock;

@end