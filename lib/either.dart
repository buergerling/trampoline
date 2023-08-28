//
sealed class Either<L, R> {
  Either();
  factory Either.right(R v) {
    return Right(v);
  }

  factory Either.left(L v) {
    return Left(v);
  }
}

final class Left<L, R> extends Either<L, R> {
  L value;
  Left(this.value);
}

final class Right<L, R> extends Either<L, R> {
  R value;
  Right(this.value);
}
