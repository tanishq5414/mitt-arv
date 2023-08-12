
import 'package:fpdart/fpdart.dart';
import 'package:mittarv/core/core.dart';



typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
typedef FutureVoid = Future<void>;
