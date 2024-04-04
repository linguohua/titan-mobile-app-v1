
import '../lang/lang.dart';

class ErrorCode {
  static const int parameterError = 1001;
  static const int signatureError = 1021;
  static const int deviceHasBeenBound = 1025;
  static const int nodeNotExist = 1007;
  static const int invalidToken = 1026;
  static const int tokenHasBeenBound = 1029;

  static const int network = -2;

  static const int unknown = -1;
  static const int success = 0;

  static String getErrorMessage(int code) {
    switch (code) {
      case parameterError:
        return Lang().dict.parameterError;
      case signatureError:
        return Lang().dict.signatureError;
      case deviceHasBeenBound:
        return Lang().dict.deviceHasBeenBound;
      case invalidToken:
        return Lang().dict.invalidToken;
      case tokenHasBeenBound:
        return Lang().dict.tokenHasBeenBound;
      case network:
        return Lang().dict.network;
      case nodeNotExist:
        return Lang().dict.nodeNotExist;
      default:
        return Lang().dict.unknown;
    }
  }
}
