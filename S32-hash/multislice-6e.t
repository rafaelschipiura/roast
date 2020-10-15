use v6.e.PREVIEW;
use Test;

plan 480;

# Testing hash multislices, aka %h{a;b;c} and associated adverbs

my %hash;
sub set-up-hash(--> Nil) {
    %hash = a => { b => { c => 42, d => 666, e => { f => 314 } } };
}
sub leftover-ok($leftover) {
    is-deeply %hash, $leftover,
      'is hash as expected after deletion of key?';
    set-up-hash;
}

# tests taking 3 keys with a single (non-)result and result after deletion
for

  "a", "b", "c", 42,           %(a => { b => { d => 666, e => { f => 314 } } }),
  "a", "b", "d", 666,          %(a => { b => { c =>  42, e => { f => 314 } } }),
  "a", "b", "e", { f => 314 }, %(a => { b => { c =>  42, d => 666 } }),
  "a", "b", "x", Nil,          %hash,
  "a", "x", "e", Nil,          %hash,
  "x", "b", "e", Nil,          %hash

-> $a, $b, $c, $result, $leftover {
    my $raku    := $result.raku;
    my $araku   := $a.raku;
    my $braku   := $b.raku;
    my $craku   := $c.raku;
    my $abc     := ($a,$b,$c);
    my $abcraku := $abc.raku;
    my $exists  := defined($result);

    set-up-hash;
    for False, True -> $delete {
        is-deeply %hash{$a;$b;$c}:$delete,
          !$exists && !$delete ?? Any !! $result,  # XXX
          "\%hash\{$araku;$braku;$craku}{
              ":delete" if $delete
          } gives {$exists ?? $raku !! "Nil"}";
        leftover-ok($leftover) if $delete;

        is-deeply %hash{$a;$b;$c}:exists:$delete,
          $exists,
          "\%hash\{$araku;$braku;$craku}:exists{
              ":delete" if $delete
          } gives $exists";
        leftover-ok($leftover) if $delete;

        is-deeply %hash{$a;$b;$c}:exists:kv:$delete,
          $exists ?? ($abc,$exists) !! (),
          "\%hash\{$araku;$braku;$craku}:exists:kv{
              ":delete" if $delete
          } gives ({
              "$abcraku,True" if $exists
          })";
        leftover-ok($leftover) if $delete;

        is-deeply %hash{$a;$b;$c}:exists:p:$delete,
          $exists ?? Pair.new($abc,$exists) !! Nil,
          "\%hash\{$araku;$braku;$craku}:exists:p{
              ":delete" if $delete
          } gives {
              $exists ?? "Pair.new($abcraku,$exists)" !! "Nil"
          }";
        leftover-ok($leftover) if $delete;

        is-deeply %hash{$a;$b;$c}:k:$delete,
          $exists ?? $abc !! Nil,
          "\%hash\{$araku;$braku;$craku}:k:{
              ":delete" if $delete
          } gives {$exists ?? $abcraku !! "Nil"}";
        leftover-ok($leftover) if $delete;

        is-deeply %hash{$a;$b;$c}:kv:$delete,
          $exists ?? ($abc,$result) !! (),
          "\%hash\{$araku;$braku;$craku}:kv{
              ":delete" if $delete
          } gives ({
              "$abcraku,$raku" if $exists
          })";
        leftover-ok($leftover) if $delete;

        is-deeply %hash{$a;$b;$c}:p:$delete,
          $exists ?? Pair.new($abc,$result) !! Nil,
          "\%hash\{$araku;$braku;$craku}:p{
              ":delete" if $delete
          } gives {
              $exists ?? "Pair.new($abcraku,$raku)" !! "Nil"
          }";
        leftover-ok($leftover) if $delete;

        is-deeply %hash{$a;$b;$c}:v:$delete,
          $exists ?? $result !! Nil,
          "\%hash\{$araku;$braku;$craku}:v{
              ":delete" if $delete
          } gives {$exists ?? $raku !! "Nil"}";
        leftover-ok($leftover) if $delete;
    }
}

# tests taking 3 keys with a single (non-)result and one or more whatevers
for

    *, "b", "c", 42,           %(a => { b => { d => 666, e => { f => 314 } } }),
  "a",   *, "d", 666,          %(a => { b => { c =>  42, e => { f => 314 } } }),
    *,   *, "e", { f => 314 }, %(a => { b => { c =>  42, d => 666 } }),
    *, "b", "x", Nil,          %hash,
  "a",   *, "x", Nil,          %hash,
    *,   *, "x", Nil,          %hash

-> $a, $b, $c, $result, $leftover {
    my $raku    := $result.raku;
    my $araku   := $a.raku;
    my $braku   := $b.raku;
    my $craku   := $c.raku;
    my $abc     := ("a","b",$c);
    my $abcraku := $abc.raku;
    my $exists  := defined($result);

    set-up-hash;
    for False, True -> $delete {
        is-deeply %hash{$a;$b;$c}:$delete,
          !$exists && !$delete ?? (Any,) !! ($result,),  # XXX
          "\%hash\{$araku;$braku;$craku}{
              ":delete" if $delete
          } gives {
              $exists ?? "($raku,)" !! "(Nil,)"
          }";
        leftover-ok($leftover) if $delete;

        is-deeply %hash{$a;$b;$c}:exists:$delete,
          ($exists,),
          "\%hash\{$araku;$braku;$craku}:exists{
              ":delete" if $delete
          } gives ($exists,)";
        leftover-ok($leftover) if $delete;

        is-deeply %hash{$a;$b;$c}:exists:kv:$delete,
          $exists ?? ($abc,$exists) !! (),
          "\%hash\{$araku;$braku;$craku}:exists:kv{
              ":delete" if $delete
          } gives ({
              "$abcraku,True" if $exists
          })";
        leftover-ok($leftover) if $delete;

        is-deeply %hash{$a;$b;$c}:exists:p:$delete,
          $exists ?? (Pair.new($abc,$exists),) !! (),
          "\%hash\{$araku;$braku;$craku}:exists:p{
              ":delete" if $delete
          } gives {
              $exists ?? "(Pair.new($abcraku,$exists),)" !! "()"
          }";
        leftover-ok($leftover) if $delete;

        is-deeply %hash{$a;$b;$c}:k:$delete,
          $exists ?? ($abc,) !! (),
          "\%hash\{$araku;$braku;$craku}:k{
              ":delete" if $delete
          } gives {$exists ?? "($abcraku,)" !! "()"}";
        leftover-ok($leftover) if $delete;

        is-deeply %hash{$a;$b;$c}:kv:$delete,
          $exists ?? ($abc,$result) !! (),
          "\%hash\{$araku;$braku;$craku}:kv{
              ":delete" if $delete
          } gives ({ "$abcraku,$raku" if $exists })";
        leftover-ok($leftover) if $delete;

        is-deeply %hash{$a;$b;$c}:p:$delete,
          $exists ?? (Pair.new($abc,$result),) !! (),
          "\%hash\{$araku;$braku;$craku}:p{
              ":delete" if $delete
          } gives {
              $exists ?? "(Pair.new($abcraku,$raku),)" !! "()"
          }";
        leftover-ok($leftover) if $delete;

        is-deeply %hash{$a;$b;$c}:v:$delete,
          $exists ?? ($result,) !! (),
          "\%hash\{$araku;$braku;$craku}:v{
              ":delete" if $delete
          } gives {$exists ?? "($raku,)" !! "()"}";
        leftover-ok($leftover) if $delete;
    }
}

# tests taking 3 keys with multi at highest level, result always the same
for

  "a", "b", <c d e>,
    *, "b", <c d e>,
  "a",   *, <c d e>,
    *,   *, <c d e>,
  "a", "b", *,
    *, "b", *,
  "a",   *, *,
    *,   *, *

-> $a, $b, $c {
    my $araku   := $a.raku;
    my $braku   := $b.raku;
    my $craku   := $c<>.raku;
    my $leftover := %(a => %(b => { }));

    # Note: because $c may contain a list as an item, we need to decont
    # it before using it as an index, otherwise we will never get a match.
    # So the use of $c<> here is an artefact of the test, not of the way
    # indexing works on multi-level hashes.
    set-up-hash;
    for False, True -> $delete {
        is-deeply (%hash{$a;$b;$c<>}:$delete).sort,
          (42, 666, { f => 314 }),
          "\%hash\{$araku;$braku;$craku}{
              ":delete" if $delete
          } gives (42, 666, \{ f => 314 })";
        leftover-ok($leftover) if $delete;

        is-deeply %hash{$a;$b;$c<>}:exists:$delete,
          (True,True,True),
          "\%hash\{$araku;$braku;$craku}:exists{
              ":delete" if $delete
          } gives (True,True,True)";
        leftover-ok($leftover) if $delete;

        is-deeply (%hash{$a;$b;$c<>}:exists:kv:$delete)
          .map(-> \key, \value { Pair.new(key,value) })
          .sort( *.key )
          .map( { |(.key, .value) } ),
          (<a b c>,True,<a b d>,True,<a b e>,True),
          "\%hash\{$araku;$braku;$craku}:exists:kv{
              ":delete" if $delete
          } gives <a b c>,True,<a b d>,True,<a b e>,True";
        leftover-ok($leftover) if $delete;

        is-deeply (%hash{$a;$b;$c<>}:exists:p:$delete).sort( *.key ),
          (<a b c> => True,<a b d> => True,<a b e> => True),
          "\%hash\{$araku;$braku;$craku}:exists:p{
              ":delete" if $delete
          } gives <a b c> => True,<a b d> => True,<a b e> => True";
        leftover-ok($leftover) if $delete;

        is-deeply (%hash{$a;$b;$c<>}:k:$delete).sort,
          (<a b c>,<a b d>,<a b e>),
          "\%hash\{$araku;$braku;$craku}:k{
              ":delete" if $delete
          } gives <a b c>,<a b d>,<a b e>";
        leftover-ok($leftover) if $delete;

        is-deeply (%hash{$a;$b;$c<>}:kv:$delete)
          .map(-> \key, \value { Pair.new(key,value) })
          .sort( *.key )
          .map( { |(.key, .value) } ),
          (<a b c>,42,<a b d>,666,<a b e>,{ f => 314 }),
          "\%hash\{$araku;$braku;$craku}:kv{
              ":delete" if $delete
          } gives <a b c>,42,<a b d>,666,<a b e>,\{ f => 314 }";
        leftover-ok($leftover) if $delete;

        is-deeply (%hash{$a;$b;$c<>}:p:$delete).sort( *.key ),
          (<a b c> => 42,<a b d> => 666,<a b e> => { f => 314 }),
          "\%hash\{$araku;$braku;$craku}:p{
              ":delete" if $delete
          } gives <a b c> => 42,<a b d> => 666,<a b e> => \{ f => 314 }";
        leftover-ok($leftover) if $delete;

        is-deeply (%hash{$a;$b;$c<>}:v:$delete).sort,
          (42, 666, { f => 314 }),
          "\%hash\{$araku;$braku;$craku}:v{
              ":delete" if $delete
          } gives 42, 666, \{ f => 314 }";
        leftover-ok($leftover) if $delete;
    }
}

# vim: expandtab shiftwidth=4
