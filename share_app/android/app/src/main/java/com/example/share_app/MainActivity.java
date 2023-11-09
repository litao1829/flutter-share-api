package com.example.share_app;


import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.os.Build;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    MethodChannel methodChannel;


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),
                "com.example.share_app");
        methodChannel.setMethodCallHandler((call, result) -> {
            // 判断方法名
            if (call.method.equals("sendData")) {
                Map map = (Map) call.arguments;
                System.out.println("原生接收的数据是：" + map.get("content"));
                if (map.get("flag").equals("1")) {
                    result.success("这是原生返回的信息-----");
                }
            } else if (call.method.equals("copyUrl")) {
                String text = (String) call.arguments;
                System.out.println("原生及收到的复制文本数据是：" + text);
                /// 获取剪贴板管理器
                ClipboardManager cm = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
                /// 创建普通字符型ClipaData
                /// 将ClipData内容放在系统剪切板里
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
                    ClipData mClipData = ClipData.newPlainText("Label", text);
                    cm.setPrimaryClip(mClipData);
                    result.success(true);
                }
            }
        });
    }

}
