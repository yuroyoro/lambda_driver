# -*- encoding : utf-8 -*-
module LambdaDriver::Disjunction
  def disjunction(f = nil, &block)
    if f.nil? && (not block_given?)
      return self.method(:disjunction)
    end

    (block_given? ?  (yield self) : f.call(self)) || self
  end
end
