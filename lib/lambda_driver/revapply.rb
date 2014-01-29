# -*- encoding : utf-8 -*-
module LambdaDriver::Revapply
  def revapply(f = nil, &block)
    if f.nil? && (not block_given?)
      return self.method(:revapply)
    end

    block_given? ?  (yield self) : f.call(self)
  end
end
