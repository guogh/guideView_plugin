<<<<<<< HEAD
<?xml version="1.0" encoding="utf-8"?>
<DevInfor>

参数配置
<!-- 默认 引导页 的个数    -->
<preference name="guideImageCount"       value="3" />

<!--   默认引导页图片      -->
<resource-file src="src/ios/GuideImage/a-guide-480h.png" />
<resource-file src="src/ios/GuideImage/b-guide-480h.png" />
<resource-file src="src/ios/GuideImage/c-guide-480h.png" />

<resource-file src="src/ios/GuideImage/a-guide-568h.png" />
<resource-file src="src/ios/GuideImage/b-guide-568h.png" />
<resource-file src="src/ios/GuideImage/c-guide-568h.png" />

<resource-file src="src/ios/GuideImage/a-guide-667h.png" />
<resource-file src="src/ios/GuideImage/b-guide-667h.png" />
<resource-file src="src/ios/GuideImage/c-guide-667h.png" />

<resource-file src="src/ios/GuideImage/a-guide-736h.png" />
<resource-file src="src/ios/GuideImage/b-guide-736h.png" />
<resource-file src="src/ios/GuideImage/c-guide-736h.png" />



<!--   动态获取的 josn   -->
<preference name="guideInfoUrl"       value="http://wwww.yunbaopu.com/guideIofo" />


接口返回json数据
{
    "data": {
        “version”: “1”,
        “guideimageCount”:"3",
        “imageArray”:{
            {“name”:name,”url”:url},
            {“name”:name,”url”:url},
            {“name”:name,”url”:url},
        }
    },

    "respCode": "100200",
    "respMsg": "成功"
}

</DevInfo>
=======
# guideView_plugin
>>>>>>> 9a08d9d528217be236563acad4f90b269b7b4bcf
