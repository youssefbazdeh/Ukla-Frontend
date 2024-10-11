import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  List properties = const <dynamic>[];
  // Failure(this.properties); // used to be like this
  Failure();
  @override
  List<Object> get props => [properties];
}

class ServerFailure extends Failure {
//  ServerFailure(super.properties);  // this line is added beacause of the error see if it orks
  ServerFailure();
}

class CacheFailure extends Failure {
  CacheFailure();
}

// the original class is the one below but it doesn't work since equatable changed so i made a try to correct it
// we will see if it's gets the job done or not
// import 'package:equatable/equatable.dart';

// abstract class Failure extends Equatable {
//   // If the subclasses have some properties, they'll get passed to this constructor
//   // so that Equatable can perform value comparison.
//   Failure([List properties = const <dynamic>[]]) : super(properties);
// }
