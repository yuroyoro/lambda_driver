# -*- encoding : utf-8 -*-
require "lambda_driver/version"
Dir["#{File.dirname(__FILE__)}/lambda_driver/*.rb"].sort.each do |path|
  next if File.basename(path, '.rb') == 'core_ext'
  require "lambda_driver/#{File.basename(path, '.rb')}"
end
require "lambda_driver/core_ext"

module LambdaDriver

  # SKI combinators
  I = lambda{|x| x }
  K = lambda{|x| lambda{|y| y }}
  S = lambda{|x| lambda{|y| lambda{|z| x.to_proc.call(z).call(y.to_proc.call(z)) } } }

  # Boolean combinators
  AND = lambda{|l| lambda{|r| l && r }}
  OR  = lambda{|l| lambda{|r| l || r }}

  class << self
    def i ; I end
    def k ; K end
    def s ; S end
  end

end
