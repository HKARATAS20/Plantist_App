import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthManager {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _biometricOnly = false;

  bool get biometricOnly => _biometricOnly;

  Future<bool> canAuthenticate() async {
    return await _localAuth.canCheckBiometrics;
  }

  Future<bool> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to login',
      );
    } on PlatformException catch (e) {
      print("Error during biometric authentication: ${e.message}");
    }
    return authenticated;
  }

  Future<void> storeCredentials(String email, String password) async {
    await _secureStorage.write(key: 'biometric_email', value: email);
    await _secureStorage.write(key: 'biometric_password', value: password);
    _biometricOnly = true;
  }

  Future<Map<String, String>> retrieveCredentials() async {
    String? email = await _secureStorage.read(key: 'biometric_email');
    String? password = await _secureStorage.read(key: 'biometric_password');
    return {'email': email ?? '', 'password': password ?? ''};
  }
}
