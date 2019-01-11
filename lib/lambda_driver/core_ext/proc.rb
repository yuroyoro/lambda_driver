# -*- encoding : utf-8 -*-

# Override Proc#>> and << these are implemented from Ruby 2.6
# to ensure passed argument is callable.
# Convert argument to proc obj by calling :to_proc before call super implementaion
module ProcOverride
  def compose(g)
    self << g
  end

  # g compose self
  def <<(g)
    super(g.to_proc)
  end

  # g compose self
  def >>(g)
    g.to_proc << self
  end
end

class Proc
  include LambdaDriver::Callable
  include LambdaDriver::WithArgs
  include LambdaDriver::Flipable
  include LambdaDriver::ProcConvertable
  include LambdaDriver::Currying
  include LambdaDriver::Liftable

  if RUBY_VERSION < "2.6.0"
    include LambdaDriver::Composable
  else
    prepend ProcOverride
  end
end

