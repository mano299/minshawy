# just_audio / just_audio_background / audio_service
-keep class com.ryanheise.just_audio.** { *; }
-keep class com.ryanheise.audioservice.** { *; }
-dontwarn com.ryanheise.just_audio.**
-dontwarn com.ryanheise.audioservice.**

# ExoPlayer (بيستخدمه just_audio جوه)
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

# Media session / notification
-keep class android.support.v4.media.** { *; }
-keep class androidx.media.** { *; }
-keep class androidx.media3.** { *; }
-dontwarn androidx.media3.**

# Hive
-keep class hive.** { *; }

# Gson/JSON لو بتستخدم أي reflection-based serialization
-keepattributes Signature
-keepattributes *Annotation*