
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
}

class ConnectionCheckerImpl implements ConnectionChecker{

  final InternetConnectionChecker connectionChecker;

  ConnectionCheckerImpl(this.connectionChecker);

  @override
  // TODO: implement isConnected
  Future<bool> get isConnected async => await connectionChecker.hasConnection; 

}