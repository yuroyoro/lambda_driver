# -*- encoding : utf-8 -*-
module LambdaDriver::Curring
  def curry(arity = nil)
    self.to_proc.curry(arity)
  end

  def self.included(klass)
    klass.send(:alias_method, :%, :curry)
  end
end
