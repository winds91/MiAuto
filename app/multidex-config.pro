-keep class androidx.startup.InitializationProvider { *; }
-keep class androidx.startup.AppInitializer { *; }
-keep class org.conscrypt.Conscrypt { *; }
-keep class org.conscrypt.OpenSSLProvider { *; }

# ICCOA 启动链（App.onCreate → IccoaManager.<init>）：强制进 primary dex。
# Dalvik (Android 4.4) 上 secondary dex 间的类引用在 <init>/<clinit> 阶段可能触发
# NoClassDefFoundError。D8 会把 IccoaManager 主类、匿名内部类（$1~$5）和 lambda
# 合成类分到不同 dex，这里统一 keep 到 primary dex 消除跨 dex 初始化依赖。
-keep class com.miauto.app.IccoaManager { *; }
-keep class com.miauto.app.IccoaManager$* { *; }
-keep class com.miauto.app.IccoaManager$$ExternalSynthetic* { *; }
-keep class com.andrerinas.openheadunit.AppComponent { *; }
-keep class com.andrerinas.openheadunit.connection.IcocaBridge { *; }