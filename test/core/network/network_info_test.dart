import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';
import 'package:ukla_app/core/network/network_info.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}


void main() {
  MockInternetConnectionChecker mockInternetConnectionChecker =
      MockInternetConnectionChecker();
    
  NetworkInfoImpl networkInfo = NetworkInfoImpl(mockInternetConnectionChecker);


  group('isConnected', () {
    test(
      'should forward the call to InternetConnectionChecker.hasConnection',
      () async {
        // arrange
        final tHasConnectionFuture = Future.value(true);

        when(mockInternetConnectionChecker.hasConnection)
            .thenReturn(Future.value(true));
        //   .thenAnswer((_) => tHasConnectionFuture);
        // act
        // NOTICE: We're NOT awaiting the result
        final result = networkInfo.isConnected;
        // assert
        verify(mockInternetConnectionChecker.hasConnection);
        // Utilizing Dart's default referential equality.
        // Only references to the same object are equal.
        expect(result, tHasConnectionFuture);
      },
    );
  });
}
