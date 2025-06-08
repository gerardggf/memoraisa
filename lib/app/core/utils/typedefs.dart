import 'either/either.dart';
import 'failure/failure.dart';

typedef Result<R> = Either<Failure, R>;

typedef AsyncResult<R> = Future<Either<Failure, R>>;
