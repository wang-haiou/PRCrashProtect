# PRCrashProtect
## 简介：
防止常见的bug导致crash，并收集crash原因和堆栈信息；收集导致crash的错误信息和堆栈信息。
## 使用规则：
1、在 `-application:didFinishLaunchingWithOptions: `方法中使用**PRCrashProtect.h**的注册方法；  
2、在**PRCrashReport.h**文件中提供了crash信息上报接口，还可以根据**userInfo**附件额外信息；  
3、如果需要将crash信息上传服务器，可以通过`-receivedReport:`方法或者`+crashMessagesHistory`方法去获取。  

___备注：建议仅在release模式下开启，debug模式下使用该框架容易让开发人员忽略问题。___