import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkManager {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription;
  final StreamController<ConnectivityResult> _connectivityStreamController =
      StreamController<ConnectivityResult>.broadcast();

  NetworkManager._privateConstructor();

  static final NetworkManager _instance = NetworkManager._privateConstructor();

  factory NetworkManager() {
    return _instance;
  }

  void initialize() {
    _subscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityStreamController.add(result);
    });
  }

  Stream<ConnectivityResult> get connectivityStream =>
      _connectivityStreamController.stream;

  void dispose() {
    _subscription.cancel();
    _connectivityStreamController.close();
  }

  Future<ConnectivityResult> getCurrentConnectivity() async {
    return await _connectivity.checkConnectivity();
  }

  Future<bool> isConnected() async {
    ConnectivityResult connectivityResult = await getCurrentConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<bool> isConnectedToWiFi() async {
    ConnectivityResult connectivityResult = await getCurrentConnectivity();
    return connectivityResult == ConnectivityResult.wifi;
  }
}
