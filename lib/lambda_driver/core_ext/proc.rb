class Proc
  include LambdaDriver::Callable
  include LambdaDriver::Currying if RUBY_VERSION < '1.9.0'
end
