module LambdaDriver::Disjunction
  def disjunction(f = nil, &block)
    if f.nil? && (not block_given?)
      return lambda{|g=nil,&inner_block| self.disjunction(g, &inner_block) }
    end

    (block_given? ?  (yield self) : f.call(self)) || self
  end
end
