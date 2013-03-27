module LambdaDriver::Ap
  def ap(f = nil, &block)
    if f.nil? && (not block_given?)
      return lambda{|g=nil,&inner_block| self.ap(g, &inner_block) }
    end

    block_given? ?  (yield self) : f.call(self)
  end
end
