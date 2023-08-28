abstract class TailRec<TailRecA> {
  TailRec<TailRecB1> map<TailRecB1>(TailRecB1 Function(TailRecA) f) => flatMap((a) => _Call(() => _Done(f(a))));

  TailRec<TailRecB2> flatMap<TailRecB2>(TailRec<TailRecB2> Function(TailRecA) f);

  TailRec<TailRecA> get result2;

  TailRec<TailRecB3> _result1<TailRecB3>(_Cont<TailRecA, TailRecB3> c);

  static TailRec<TailRecC> _result0<TailRecD, TailRecC>(TailRec<TailRecD> b, _Cont<TailRecD, TailRecC> c) => b._result1(c);

  TailRecA get result {
    TailRec<TailRecA> ts = this;
    while (!(ts is _Done<TailRecA>)) {
      ts = ts.result2;
    }
    return (ts).value;
  }
}

class _Call<CallA> extends TailRec<CallA> {
  _Call(this.rest);

  final TailRec<CallA> Function() rest;

  @override
  TailRec<CallB1> flatMap<CallB1>(f) => _Cont<CallA, CallB1>(this, f);

  @override
  TailRec<CallA> get result2 => rest();

  @override
  TailRec<CallB2> _result1<CallB2>(c) => rest().flatMap<CallB2>(c.f);
}

class _Cont<ContB, ContA> extends TailRec<ContA> {
  _Cont(this.b, this.f);

  TailRec<ContB> b;

  TailRec<ContA> Function(ContB) f;

  @override
  TailRec<ContC1> flatMap<ContC1>(g) => _Cont<ContB, ContC1>(b, (ContB x) => f(x).flatMap<ContC1>(g));

  @override
  TailRec<ContA> get result2 => TailRec._result0<ContB, ContA>(b, this);

  @override
  TailRec<ContC2> _result1<ContC2>(c) => b.flatMap<ContC2>((ContB x) => f(x).flatMap<ContC2>(c.f));
}

class _Done<DoneA> extends TailRec<DoneA> {
  _Done(this.value);
  final DoneA value;

  @override
  _Call<DoneB1> flatMap<DoneB1>(f) => _Call<DoneB1>(() => f(value));

  @override
  TailRec<DoneA> get result2 => this;

  @override
  TailRec<DoneB2> _result1<DoneB2>(c) => c.f(value);
}

TailRec<TCA> tailcall<TCA>(TailRec<TCA> Function() rest) => _Call<TCA>(rest);

TailRec<DNA> done<DNA>(DNA result) => _Done<DNA>(result);
