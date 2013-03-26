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
  f = lamdba{|x| x.to_s }
  f < :foo # => "foo"
```

#### Proc#compose

Returns new lambda which composed self and given function.
A composed proc called with args, executes `self.(g(*args)).

```ruby
  f = lamdba{|x| x.to_s }
  g = lambda{|y| y.length }
  h = f compose g
  h.(:hoge) # => 4
```

This method is aliased as `<<`.

```ruby
  f << g # => f.compose(g)
```

#### Proc#with_args

Returns partially applied function that has 2nd and more parameters
fixed by given *args.

```ruby
  f = lamdba{|x, y, z| [x, y, z]}
  h = f.with_args(:a, :b)
  h.(:c) # => [:c, :a, :b]
```

This method is aliased as `*`.

```ruby
  f * :foo  # => f.with_args(:foo)
```


#### Proc#flip

Returns function whose parameter order spawed 1st for 2nd.
A result of filped fuction is curried by Proc#curry.

```ruby
  f = lamdba{|x, y, z| [x, y, z]}
  h = f.flip
  h.(:a).(:b).(:c) # => [:b, :a, :c]
```

If arguments is var-args, pass explicitly arity to curring.

```ruby
  p = Proc.new{|*args| args.inspect }
  p.flip(3).call(:a).(:b).(:c)      # => "[:b, :a, :c]"
  p.flip(4).call(:a).(:b).(:c).(:d) # => "[:b, :a, :c, :d]"
```

If arity is 0 or 1, flip returns itself.

This method is aliased as `~@`.

```ruby
  ~f # => f.filp
```

<!-- Symbol extensions -->
<!-- - to_method -->

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
  String / :index < "foobarbaz" < 3  # => 3 (== "foobarbaz".index(3) )
```

### Combinators
<!-- - && || -->
- ski combinator

### Object extensions
- ap(|>) :  obj.ap(f) => f.call(obj)
- obj._.method : returns obj.method(method) or lamdba{|*args| obj.send(method, *args) }
<!-- - obj.disjunction(f) : if f(self) is nil, return self else return f(self) -->

#### Object#ap

`Object#ap` is applies self to given proc/block.

```ruby
  f = lambda{|x| x * 2 }
  "foo".ap(f) #  => "fooffoo"
```

#### Object#_

Object#op is shortcut to quickly extract Method object.

```ruby
"foobarbaz"._.index         #=> #<Method: String#index>
"foobarbaz"._.index < "bar" # => 3 (== "foobarbaz".index(3) )

2._(:>=) # => #<Method: Fixnum#>=>
[1, 2, 3].select(&2._(:>=)) # => [1, 2]( = [1, 2].select{|n| 2 >= n})
```



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
