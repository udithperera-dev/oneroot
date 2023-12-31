package com.akurupela.oneroot;

import androidx.annotation.NonNull;

import com.akurupela.oneroot.core.OneRoot;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** OnerootPlugin */
public class OnerootPlugin implements FlutterPlugin, MethodCallHandler , ActivityAware{
  private MethodChannel channel;
  private ActivityPluginBinding activityBinding;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "oneroot");
    channel.setMethodCallHandler(this);
  }



  @Override
  public void  onDetachedFromActivity() {}

  @Override
  public void  onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {}

  @Override
  public void  onAttachedToActivity(ActivityPluginBinding binding) {
    activityBinding = binding;
  }

  @Override
  public void  onDetachedFromActivityForConfigChanges() {}


  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }else if (call.method.equals("getRootChecker")) {
      try{
        OneRoot oneRoot= new OneRoot(activityBinding.getActivity());
        if(oneRoot.isRooted()){
          result.success("ROOTED");
        }else{
          result.success("");
        }
      }catch (Exception e){
        result.success("");
      }
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
