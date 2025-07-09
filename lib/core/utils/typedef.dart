import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failure.dart';

typedef ResultStream<T> = Stream<Either<Failure, T>>;

typedef ResultsStream<T, S> = Stream<Either<T, S>>;

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef Result<T> = Either<Failure, T>;
typedef ResultVoid = ResultFuture<void>;

typedef DataMap = Map<String, dynamic>;
