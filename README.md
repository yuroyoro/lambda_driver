# LambdaDriver

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'lambda_driver'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lambda_driver

## Usage

TODO: Write usage instructions here

Proc/lambda/Symbol/Method extensions
- call
- compose
- with_args
- flip
- curry

<!-- Symbol extensions -->
<!-- - to_method -->

Class extensions
- alias instance_method, :/

UnboundMethod extensions
- alias bind, :<

Combinators
<!-- - && || -->
- ski combinator

Object extensions
- ap(|>) :  obj.ap(f) => f.call(obj)
- obj._.method : returns obj.method(method) or lamdba{|*args| obj.send(method, *args) }
<!-- - obj.disjunction(f) : if f(self) is nil, return self else return f(self) -->


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
