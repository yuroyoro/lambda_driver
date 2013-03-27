class Symbol
  include LambdaDriver::Callable
  include LambdaDriver::Currying if RUBY_VERSION < '1.9.0'

  def to_method
    lambda{|obj| obj._(self) }
  end

  alias_method :-@, :to_method
end
