# LambdaDriver

虚弦斥力場生成システム

LambdaDriver drives your code more functional.

```ruby
# [:foo, :bar, :baz].map{|s| s.to_s }.map{|s| s.upcase }
# [:foo, :bar, :baz].map(&:to_s).map(&:upcase)

[:foo, :bar, :baz].map(&:to_s >> :upcase ) # => ["FOO",  "BAR",  "BAZ"]
```

```ruby
# [:foo, :hoge, :bar, :fuga].select{|s| s.to_s.length > 3} # => [:hoge, :fuga]

[:foo, :hoge, :bar, :fuga].select(&:to_s >> :length >> 3._(:<)) # => [:hoge, :fuga]
```

- [project page](http://yuroyoro.github.com/lambda_driver/)
- [rubygems.org](https://rubygems.org/gems/lambda_driver)

## Build status

[![Build Status](https://travis-ci.org/yuroyoro/lambda_driver.png)](https://travis-ci.org/yuroyoro/lambda_driver)

## Installation

Add this line to your application's Gemfile:

    gem 'lambda_driver'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lambda_driver

## Usage

### Proc/lambda/Symbol/Method extensions
- call
- compose
- with_args
- flip
- curry

#### alias :< to Proc#call

```ruby
  f = lambda{|x| x.to_s }
  f < :foo # => "foo"
```

#### alias :+@ to Proc#to_proc

```ruby
  +:to_s           # => #<Proc:0x007ff78aadaa78>
  +:to_s < :foo    # => "foo"
```


#### Proc#compose

Returns new lambda which composed self and given function.
A composed proc called with args, executes `self.(g(*args)).

```ruby
  f = lambda{|x| x.to_s * 2 }
  g = lambda{|y| y.length }

  h = f.compose g  # => #<Proc:0x007ff78aa2ab2>
  h.(:hoge)        # => "44" ( == f.call(g.call(:hoge)) )
```

This method is aliased as `<<`.

```ruby
  f << g          # => f.compose(g)
  f << g < :hoge  # => "44" ( == f.call(g.call(:hoge)) )
```

#### Proc#lift

Lift this function to the given context-function.
The lifted fucntion can compose other function with context-fucntion.

The given context-fuction used by `compose_with_lifting`
to compose other fucntion.

The context-funciton should recieve 2 arguments.

- first one is a function that reciver function of `compose_with_lifting` method.
- second arg is a result of g(x)
  - g is a function passed to `compose_with_lifting`

If given arguments is Symbol, find context-function from
default context-functions.

- :identify
  - this context nothing to do
- :maybe
  - computations which may not return a result
- :list
  - computations which can return multiple possible results
- :reader
  - computations which read from a shared environment
- :writer
  - computations which write data in addition to computing values

see -> LambdaDriver::Context

#### Proc#compose_with_lifting

Compose self and given function on the context-function.
The context-funciton is passed by `lift` method.

This method returns composed funciton like bellow.

```ruby
 lambda{|args|  context(self, g(*args)) }
```

For example, set context-function that logging the result.

```ruby
  hash = {:a => "foo"}
  f = lambda{|x| x.length}
  g = lambda{|y| hash[y]}

  ctx = lambda{|f,x|
    puts "g(x)    -> #{x}"
    y = f.call(x)
    puts "f(g(x)) -> #{y}"
    y
  }

  lifted = f.lift(ctx)
  h = lifted.compose_with_lifting g

  h.(:a)
  #=>  g(x)    -> foo # output by ctx
  #=>  f(g(x)) -> 3   # output by ctx
  #=> 3
```

if context-function does not given,
default behaivior is compose function with checking g(x) is mzoro

if g(x) is mzero, it does not call self and return g(x),
otherwise returns f(g(x)).

mzero means the object is nil or emtpy

```ruby
  hash = {:a => "foo"}
  f = lambda{|y| y.length }
  g = lambda{|y| hash[y]}
  h = f.compose_with_lifting g
  h.(:a) # => 3
  h.(:b) # => nil (it does not called f)
```

This method is aliased as `<=`.

```ruby
  f <= g # => f.compose_with_lifting(g)
```

#### Proc#with_args

Returns partially applied function that has 2nd and more parameters are
fixed by given *args.

```ruby
  f = lambda{|x, y, z| [x, y, z]}

  h = f.with_args(:a, :b)   # => #<Proc:0x007ff78a9c5ca0>
  h.(:c)                    # => [:c, :a, :b] ( == f.call(:c, :a, :b) )
```

This method is aliased as `*`.

```ruby
  f = lambda{|x, y| [x, y]}

  f * :foo          # => #<Proc:0x007ff78a987540> (== f.with_args(:foo) )
  f * :foo < :bar   # => [:bar,  :foo] ( == f.with_args(:foo).call(:bar) )
```


#### Proc#flip

Returns function whose parameter order swaped 1st for 2nd.
A result of filped fuction is curried by Proc#curry.

```ruby
  f = lambda{|x, y, z| [x, y, z]}

  h = f.flip                    # => #<Proc:0x007ff78a942fa>
  h.call(:a).call(:b).call(:c)  # => [:b, :a, :c] (== f.curry.call(:b).call(:a).call(:b))
  h < :a < :b < :c              # => [:b, :a, :c] (== f.curry.call(:b).call(:a).call(:b))
```

If arguments is var-args, pass explicitly arity to curring.

```ruby
  p = Proc.new{|*args| args.inspect }

  p.arity                           # => -1
  p.flip(3).call(:a).(:b).(:c)      # => "[:b, :a, :c]"
  p.flip(4).call(:a).(:b).(:c).(:d) # => "[:b, :a, :c, :d]"
```

If arity is 0 or 1, flip returns itself.

This method is aliased as `~@`.

```ruby
  ~f # =>             #<Proc:0x007ff78a8e22c> (== f.filp)
  ~f < :a < :b < :c   # => [:b, :a, :c] (== f.filp.call(:b).call(:a).call(:b))

```

### Symbol extensions
- to_method
- to_method_with_args

#### Symbol#to_method

Symbol#to_method generates a function that extract Method object from given argument.
This method is aliased as `-@`.

```ruby
  (-:index).call("foobarbaz")             # => #<Method: String#index>
  (-:index).call("foobarbaz").call("bar") # => 3 (== "foobarbaz".index("bar") )

  -:index < "foobarbaz"         # => #<Method: String#index>
  -:index < "foobarbaz" < "bar" # => 3 (== "foobarbaz".index("bar") )
```

#### Symbol#to_method_with_args

Symbol#to_method_with_args generates a function that extract Method object from given object,
and returns function is partially applied parameters by passed arguments.
It is same as Symbol#to_method with Proc#with_args.

This method is aliased as `&`.

```ruby
  :index.to_method_with_args("bar")                   #  => #<Proc:0x007ffef4886ff8
  :index.to_method_with_args("bar").call("foobarbaz") #  => 3 (== "foobarbaz".index("bar") )

  :index & "bar"               #  => #<Proc:0x007ffef4886ff8
  :index & "bar" < "foobarbaz" #  => 3 (== "foobarbaz".index("bar") )
```

### Class extensions
- alias instance_method, :/

```ruby
  String / :index # => #<UnboundMethod: String#index>
```

### UnboundMethod extensions
- alias bind, :<

```ruby
  String / :index                    # => #<UnboundMethod: String#index>
  String / :index < "foobarbaz"      # => #<Method: String#index>
  String / :index < "foobarbaz" < 3  # => 3 (== "foobarbaz".index("bar") )
```

### Combinators
<!-- - && || -->
- ski combinator

### Object extensions
- obj.revapply(|>)
- obj._
- obj.disjunction(f)

#### Object#revapply

`Object#revapply` is applies self to given proc/block.

```ruby
  f = lambda{|x| x * 2 }

  "foo".revapply(f) #  => "fooffoo" (== f.call("foo") )
```

#### Object#_

Object#_ is shortcut to quickly extract Method object.

```ruby
"foobarbaz"._.index         # => #<Method: String#index>
"foobarbaz"._.index < "bar" # => 3 (== "foobarbaz".index("bar") )

2._(:>=)                    # => #<Method: Fixnum#>=>
[1, 2, 3].select(&2._(:>=)) # => [1, 2]( = [1, 2].select{|n| 2 >= n})
```

#### Object#disjunction

`Object#disjunction` select self or result of applied self to given function.
if f(self) is nil, returns self, otherwise return f(self).

```ruby
  f = lambda{|x| x % 2 == 0 ? nil : x * 2}

  2.disjunction(f) # => 2 (disjunction returns reciever object)
  3.disjunction(f) # => 6 (disjunction returns f(3) )
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
