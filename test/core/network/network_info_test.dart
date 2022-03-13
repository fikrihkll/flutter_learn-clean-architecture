import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_bloc_advance/core/network/network_info.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDataConnectionChecker extends Mock implements Connectivity {}

/*
* THIS TEST IS NOT IMPLEMENTED BECAUSE I'M SUCK
* */

void main() {

  MockDataConnectionChecker mockDataConnectionChecker= MockDataConnectionChecker();
  NetworkInfoImpl networkInfoImpl= NetworkInfoImpl(mockDataConnectionChecker);

  setUp(() {

  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async {
          //arrange
          when(()=>mockDataConnectionChecker.checkConnectivity())
              .thenAnswer((_) async => ConnectivityResult.mobile);
          //act
          final result = await networkInfoImpl.isConnected;
          //assert
          verify(()=>mockDataConnectionChecker.checkConnectivity());
          expect(result,true);
        });
  });
}
