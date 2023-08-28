import 'package:trampoline/trampoline2.dart';

// Beispiel 1

List<int> range(int a, int b) {
  if (a == b)
    return [];
  else {
    // a :: range(a + 1, b)
    List<int> nextRange = range(a + 1, b);
    return nextRange..add(a);
  }
}

Stackless<List<int>> mrange(int a, int b) {
  if (a == b)
    return done(<int>[]); // implicit call to 'done(Nil)'
  else {
    return delayed<List<int>>(() => mrange(a + 1, b)).andThen((nextRange) => done(nextRange..add(a)));
  }
}

// Beispiel 2

Stackless<int> fa(int z) {
  if (z % 10000 == 0) print(z);

  if (z < 0)
    return done(z); // implicit call to 'done(Nil)'
  else {
    return delayed<int>(() => fb(z - 1));
  }
}

Stackless<int> fb(int z) {
  if (z < 0)
    return done(z); // implicit call to 'done(Nil)'
  else {
    return delayed<int>(() => fa(z - 1));
  }
}

// Beispiel 3

Stackless<int> f1(int z) {
  if (z % 1000000 == 0) print(z);
  return delayed<int>(() => f2(z + 1));
}

Stackless<int> f2(int z) {
  return delayed<int>(() => f1(z + 1));
}

void trampoline2() {
  // print(range(1, 1000).length);
  // print(mrange(1, 1000000).result.length);
  // print(fa(10000000).result);
  print(f1(10000000).result);
}

void main() {
  trampoline2();
}
