import 'package:flutter/widgets.dart';
import 'package:titan_app/l10n/generated/l10n.dart';

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

  static String getErrorMessage(BuildContext context, int code) {
    switch (code) {
      case parameterError:
        return S.of(context).error_parameter;
      case signatureError:
        return S.of(context).error_signature;
      case deviceHasBeenBound:
        return S.of(context).error_device_has_bound;
      case invalidToken:
        return S.of(context).error_invalid_token;
      case tokenHasBeenBound:
        return S.of(context).error_token_has_bound;
      case network:
        return S.of(context).error_network;
      case nodeNotExist:
        return S.of(context).devicenotexists;
      default:
        return S.of(context).error_unknown;
    }
  }
}
