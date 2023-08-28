import 'package:trampoline/either.dart';

//
typedef ES<A> = Either<Stackless<A> Function(), A>;

//
sealed class Stackless<A> {
  ES<A> resume() {
    Stackless<A> th = this;
    while (true) {
      // print("  resume ... ");
      if (th case Done(res: A resDone))
        return Right(resDone);
      else if (th case More(k: Stackless<A> Function() kMore))
        return Left(kMore);
      else if (th case AndThen(sub: Stackless<A> subAndThen, k: Stackless<A> Function(A) kAndThen)) {
        if (subAndThen case Done(res: A resDoneInner))
          th = kAndThen(resDoneInner); // rec
        else if (subAndThen case More(k: Stackless<A> Function() kMoreInner))
          return Left(() => kMoreInner().andThen(kAndThen));
        else if (subAndThen case AndThen(sub: Stackless<A> subAndThenInner, k: Stackless<A> Function(A) kAndThenInner))
          th = subAndThenInner.andThen((A s) => kAndThenInner(s).andThen(kAndThen)); // rec
      }
    }
  }

  A run() {
    Stackless<A> th = this;
    while (true) {
      ES<A> it = th.resume();
      if (it case Left(value: Stackless<A> Function() valueLeft)) {
        th = valueLeft(); // rec
      } else if (it case Right(value: A valueRight)) {
        return valueRight;
      }
    }
  }

  A get result => run();

  Stackless<B> andThen<B>(Stackless<B> Function(A) f) => switch (this) {
        // 1
        AndThen<B, A>(sub: Stackless<B> a, k: Stackless<A> Function(B) g) //
          =>
          AndThen<B, B>(a, (B x) => AndThen<A, B>(g(x), f)),
        // 2
        Stackless<A> x => AndThen(x, f),
      };

  Stackless<B> map<B>(B Function(A x) f) => andThen((a) => Done(f(a)));

  Stackless<B> flatMap<B>(Stackless<B> Function(A) f) => andThen(f);

  void foreach<B>(void Function(A) f) => map(f).run;
  
}

//

final class More<A> extends Stackless<A> {
  More(this.k);
  Stackless<A> Function() k;
}

final class Done<A> extends Stackless<A> {
  final A res;
  Done(this.res);
}

final class AndThen<A, B> extends Stackless<B> {
  AndThen(this.sub, this.k);

  Stackless<A> sub;

  Stackless<B> Function(A) k;
}

//

Stackless<A> done<A>(A result) => Done(result);

Stackless<A> delayed<A>(Stackless<A> Function() k) => More(() => k());
