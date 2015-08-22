Generated code with -O2 is very interesting. `DeepSeq` instance is very close to
hand-written one:

```
Rec {
Main.$fNFDataTree_$crnf [Occ=LoopBreaker]
  :: forall a_ab5v. NFData a_ab5v => Tree a_ab5v -> ()
[GblId, Arity=2, Caf=NoCafRefs, Str=DmdType <C(S),C(U())><S,1*U>]
Main.$fNFDataTree_$crnf =
  \ (@ a17_ab5v)
    ($dNFData_ab5w :: NFData a17_ab5v)
    (eta_B1 :: Tree a17_ab5v) ->
    case eta_B1 of _ [Occ=Dead] {
      Leaf g1_aaHO ->
        ($dNFData_ab5w
         `cast` (Control.DeepSeq.NTCo:NFData[0] <a17_ab5v>_N
                 :: NFData a17_ab5v ~R# (a17_ab5v -> ())))
          g1_aaHO;
      Branch g1_aaHP g2_aaHQ ->
        case Main.$fNFDataTree_$crnf @ a17_ab5v $dNFData_ab5w g1_aaHP
        of _ [Occ=Dead] { () ->
        Main.$fNFDataTree_$crnf @ a17_ab5v $dNFData_ab5w g2_aaHQ
        }
    }
end Rec }
```

This is generated code for hand-written implementation:

```
Rec {
Main.$fNFDataTree1_$crnf [Occ=LoopBreaker]
  :: forall a_abd4. NFData a_abd4 => Tree1 a_abd4 -> ()
[GblId, Arity=2, Caf=NoCafRefs, Str=DmdType <C(S),C(U())><S,1*U>]
Main.$fNFDataTree1_$crnf =
  \ (@ a17_abd4)
    ($dNFData_abd5 :: NFData a17_abd4)
    (eta_B1 :: Tree1 a17_abd4) ->
    case eta_B1 of _ [Occ=Dead] {
      Leaf1 a18_a4tg ->
        ($dNFData_abd5
         `cast` (Control.DeepSeq.NTCo:NFData[0] <a17_abd4>_N
                 :: NFData a17_abd4 ~R# (a17_abd4 -> ())))
          a18_a4tg;
      Branch1 t1_a4th t2_a4ti ->
        case Main.$fNFDataTree1_$crnf @ a17_abd4 $dNFData_abd5 t1_a4th
        of _ [Occ=Dead] { () ->
        Main.$fNFDataTree1_$crnf @ a17_abd4 $dNFData_abd5 t2_a4ti
        }
    }
end Rec }
```

They're exactly the same! I don't know how is this possible.

Benchmarks:
