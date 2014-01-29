# -*- encoding : utf-8 -*-
module LambdaDriver::Callable

  def <(*args, &block)
    if block_given?
      self.to_proc.call(*args, &block)
    else
      self.to_proc.call(*args)
    end
  end
end
