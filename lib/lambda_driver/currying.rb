module LambdaDriver::Currying
  def curry(arity = nil)
    f = self.to_proc
    arity ||= __arity(f)
    return f if arity == 0

    lambda{|arg| __curry(f, arity, arg, []) }
  end

  private
    def __arity(f)
      (f.arity >= 0) ? f.arity : -(f.arity + 1)
    end

    def __curry(f, arity, arg, passed)
      args = passed + [arg]
      return f.call(*args) if arity == 1
      lambda{|arg| __curry(f, arity - 1, arg, args) }
    end
end
