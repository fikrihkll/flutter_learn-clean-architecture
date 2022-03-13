import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo{
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo{
  final Connectivity connectivity;


  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }}
}