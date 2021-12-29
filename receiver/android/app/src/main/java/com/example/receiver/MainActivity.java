package com.example.receiver;

import io.flutter.embedding.android.FlutterActivity;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    String sharedText;

    private static final String TAG = "MainActivity";
    private static final String CHANNEL = "app.channel.shared.data";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        Intent intent = getIntent();
        String action = intent.getAction();
        String type = intent.getType();

        if (Intent.ACTION_SEND.equals(action) && type != null) {
            Log.d(TAG, "######## Intent.Action_SEND was entered... ");
            if ("text/plain".equals(type)) {
                Log.d(TAG, "onCreate: handleSendText was called...");
                handleSendText(intent); // Handle text being sent

            }
        }

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                Log.d(TAG, "onMethodCall: was called");
                Log.d(TAG, "called :"+methodCall.method);

                if (methodCall.method.contentEquals("getSharedText")) {
                    Log.d(TAG, "onMethodCall: if entered...");
                    Log.d(TAG, "returns payload text : "+sharedText);
                    result.success(sharedText);
                    sharedText = null;
                }
            }
        });
    }


    void handleSendText(Intent intent) {
        Log.e(TAG, "handleSendText: was called...");
        sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
    }
}