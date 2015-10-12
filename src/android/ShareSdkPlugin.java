package com.yuanbaopu.databox;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.apache.cordova.PluginResult.Status;
import org.json.JSONArray;
import org.json.JSONException;

import android.util.Log;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.onekeyshare.OnekeyShare;
import android.content.pm.PackageManager;
import android.app.Activity;
import android.content.pm.ActivityInfo;
import java.util.HashMap;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.wechat.friends.Wechat;
import cn.sharesdk.wechat.moments.WechatMoments;

public class ShareSdkPlugin extends CordovaPlugin {
    private static final String TAG = "sharesdk";

    private String initError = null ;

    /**
     * Sets the context of the Command. This can then be used to do things like
     * get file paths associated with the Activity.
     *
     * @param cordova The context of the main Activity.
     * @param webView The CordovaWebView Cordova is running in.
     */
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        Activity self = cordova.getActivity() ;
        try {
            ActivityInfo info = self.getPackageManager().getActivityInfo(self.getComponentName(), PackageManager.GET_META_DATA);
            // STEP 1: initialize the ShareSDK through code
            ShareSDK.initSDK(cordova.getActivity(), info.applicationInfo.metaData.getString("ShareSDK_AppKey", "VPREFIX_").substring(8));
            // STEP 2: initialize the sina web share interface
            {
                HashMap<String,Object> hashMap = new HashMap<String, Object>();
                hashMap.put("Id","1");
                hashMap.put("SortId","1");
                hashMap.put("ShareByAppClient","true");
                hashMap.put("Enable","true");
                hashMap.put("AppKey", info.applicationInfo.metaData.getString("ShareSDK_SinaWeibo_AppKey", "VPREFIX_").substring(8));
                hashMap.put("AppSecret",info.applicationInfo.metaData.getString("ShareSDK_SinaWeibo_AppSecret", "VPREFIX_").substring(8));
                hashMap.put("RedirectUrl",info.applicationInfo.metaData.getString("ShareSDK_SinaWeibo_RedirectUrl", "VPREFIX_").substring(8));
                ShareSDK.setPlatformDevInfo(SinaWeibo.NAME,hashMap);
            }
            // STEP 2: initialize the Wechat share interface
            {
                HashMap<String,Object> hashMap = new HashMap<String, Object>();
                hashMap.put("Id","2");
                hashMap.put("SortId","2");
                hashMap.put("Enable","true");
                hashMap.put("BypassApproval","false");
                hashMap.put("AppId",info.applicationInfo.metaData.getString("ShareSDK_Wechat_AppId", "VPREFIX_").substring(8));
                hashMap.put("AppSecret",info.applicationInfo.metaData.getString("ShareSDK_Wechat_AppSecret", "VPREFIX_").substring(8));
                ShareSDK.setPlatformDevInfo(Wechat.NAME,hashMap);
            }
            // STEP 3: initialize the WechatMoments share interface
            {
                HashMap<String,Object> hashMap = new HashMap<String, Object>();
                hashMap.put("Id","3");
                hashMap.put("SortId","3");
                hashMap.put("Enable","true");
                hashMap.put("BypassApproval","false");
                hashMap.put("AppId",info.applicationInfo.metaData.getString("ShareSDK_WechatMoments_AppId", "VPREFIX_").substring(8));
                hashMap.put("AppSecret",info.applicationInfo.metaData.getString("ShareSDK_WechatMoments_AppSecret", "VPREFIX_").substring(8));
                ShareSDK.setPlatformDevInfo(WechatMoments.NAME,hashMap);
            }
        } catch (Exception e) {
            initError = e.getMessage();
            e.printStackTrace();
        }
    }

    public void onDestroy() {
    }

    private void share(String title,String text,String imgUrl , String url) throws PackageManager.NameNotFoundException {
        OnekeyShare oks = new OnekeyShare();
        //关闭sso授权
        oks.disableSSOWhenAuthorize();
        // title标题，印象笔记、邮箱、信息、微信、人人网和QQ空间使用
        oks.setTitle(title);
        // text是分享文本，所有平台都需要这个字段
        oks.setText(text);
        // imageUrl是图片的网络路径，新浪微博、人人网、QQ空间和Linked-In支持此字段
        oks.setImageUrl(imgUrl);
        // url仅在微信（包括好友和朋友圈）中使用
        oks.setUrl(url);
        oks.show(cordova.getActivity());
    }
    
    /**
     * Entry-point for JS calls from Cordova
     */
    @Override
    public boolean execute(String action, JSONArray inputs, CallbackContext callbackContext) throws JSONException {
        try {
            if (initError != null) {
                callbackContext.error(initError);
            } else if ("share".equals(action)) {
                String title     = inputs.getJSONObject(0).getString("title");
                String content   = inputs.getJSONObject(0).getString("content");
                String imagePath = inputs.getJSONObject(0).getString("imagePath");
                String url       = inputs.getJSONObject(0).getString("url");

                share(title,content,imagePath,url);
                callbackContext.success("Hello");
                return true;
            } else {
                Log.w(TAG, "Invalid action passed: " + action);
                PluginResult result = new PluginResult(Status.INVALID_ACTION);
                callbackContext.sendPluginResult(result);
            }
        } catch (Exception e) {
            Log.w(TAG, "Caught exception during execution: " + e);
            String message = e.toString();
            callbackContext.error(message);
        }

        return true;
    }
}
