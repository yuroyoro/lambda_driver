# -*- encoding : utf-8 -*-
module LambdaDriver::Currying

  if RUBY_VERSION < '1.9.0'
    def curry(arity = nil)
      f = self.to_proc
      arity ||= __arity(f)
      return f if arity == 0

      lambda{|arg| __curry(f, arity, arg, []) }
    end
  else
    def curry(arity = nil)
      self.to_proc.curry(arity)
    end
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


  def self.included(klass)
    klass.send(:alias_method, :%, :curry)
  end
end
