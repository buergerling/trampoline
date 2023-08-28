trampoline
==========

Two libraries for trampolining recursive calls:

- trampoline.dart 
- trampoline2.dart





# Example 1 for trampoline.dart


```dart

import 'package:trampoline/trampoline.dart';

TailRec<int> fib(int n) {
  if (n < 2) {
    return done(n);
  } else {
    return tailcall(() => fib(n - 1)).flatMap((x) {
      return tailcall(() => fib(n - 2)).map((y) {
        return (x + y);
      });
    });
  }
}

void main() {
  int z = 10;
  print("fib(${z}) is ${fib(z).result}!");
}

```

# Example 2 for trampoline.dart


```dart

import 'package:trampoline/trampoline.dart';

TailRec<bool> odd(int n) => n == 0 ? done(false) : tailcall(() => even(n - 1));
TailRec<bool> even(int n) => n == 0 ? done(true) : tailcall(() => odd(n - 1));

void main() {
  int z = 1000;
  print("${z} is odd? ${odd(z).result}!");
}

```


# Example 3 for trampoline2.dart

```dart
import 'package:trampoline/trampoline2.dart';

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

main() {
  print(range(1, 1000).length);
  print(mrange(1, 1000000).result.length);

}
```

# Example 4 for trampoline2.dart

```dart
import 'package:trampoline/trampoline2.dart';

Stackless<int> fa(int z) {
  if (z % 10000 == 0) print(z);

  if (z < 0)
    return done(z); 
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

main() {
  print(fa(10000000).result);
}
```

# Example 5 for trampoline2.dart


```dart
import 'package:trampoline/trampoline2.dart';

Stackless<int> f1(int z) {
  if (z % 1000000 == 0) print(z);
  return delayed<int>(() => f2(z + 1));
}

Stackless<int> f2(int z) {
  return delayed<int>(() => f1(z + 1));
}

main() {

  print(f1(10000000).result);
}
```

