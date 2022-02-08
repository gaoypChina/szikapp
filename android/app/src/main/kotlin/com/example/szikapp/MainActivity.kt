package com.example.szikapp

import io.flutter.embedding.android.FlutterActivity;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.android.DrawableSplashScreen;
import io.flutter.embedding.android.SplashScreen;

import android.widget.ImageView;
import android.graphics.drawable.Drawable;
import android.content.pm.PackageManager;
import android.os.Build
import android.view.ViewTreeObserver
import android.view.WindowManager

class MainActivity: FlutterActivity() {
    /*override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    override fun provideSplashScreen(): SplashScreen? {
        val manifestSplashDrawable = getSplashScreenFromManifest();
        return DrawableSplashScreen(
            manifestSplashDrawable,
            ImageView.ScaleType.FIT_XY,
            0 // Fade in duration
        );
    }

    // Copied from FlutterActivity since it's private
    private fun getSplashScreenFromManifest(): Drawable {
        val activityInfo = getPackageManager().getActivityInfo(getComponentName(), PackageManager.GET_META_DATA)
        val metadata = activityInfo.metaData
        val splashScreenId = metadata.getInt("io.flutter.embedding.android.SplashScreenDrawable")
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP) {
            return getResources().getDrawable(splashScreenId, getTheme())
        } else {
            return getResources().getDrawable(splashScreenId)
        }
    }*/
}
