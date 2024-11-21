import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static const String androidPackageName = 'com.example.kakra';
  static const String iosBundleId = 'com.example.kakra';

  static const String projectNumber = '54357462485';
  static const String projectId = 'kakra-1e247';
  static const String storageBucket = 'kakra-1e247.firebasestorage.app';

  static const Map<String, String> platforms = {
    'android': '1:54357462485:android:842245c20a3d52b38dc15c',
    'ios': '1:54357462485:ios:65d4f60fce59fb378dc15c',
  };

  static FirebaseOptions get currentPlatform {
    if (kReleaseMode) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyBfHw48ffZa_0cmGypvKf6ihnLEFaAI6nc',
        appId: '1:54357462485:android:842245c20a3d52b38dc15c',
        messagingSenderId: '54357462485',
        projectId: projectId,
        storageBucket: storageBucket,
      );
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyBfHw48ffZa_0cmGypvKf6ihnLEFaAI6nc',
        appId: '1:54357462485:android:842245c20a3d52b38dc15c',
        messagingSenderId: '54357462485',
        projectId: projectId,
        storageBucket: storageBucket,
        androidClientId: null,
        // androidPackageName: androidPackageName,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyCKizRjWoHkEHZut4eOqd5eN0toSnUc-W4',
        appId: '1:54357462485:ios:65d4f60fce59fb378dc15c',
        messagingSenderId: '54357462485',
        projectId: projectId,
        storageBucket: storageBucket,
        iosClientId: null,
        iosBundleId: iosBundleId,
      );
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  // Optional: Method to get specific platform details
  static String getPlatformAppId(String platform) {
    return platforms[platform] ?? '';
  }

  // Optional: Firebase configuration validation
  static void validateConfiguration() {
    assert(projectId.isNotEmpty, 'Project ID cannot be empty');
    assert(storageBucket.isNotEmpty, 'Storage bucket cannot be empty');
  }
}
