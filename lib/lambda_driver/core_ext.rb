# -*- encoding : utf-8 -*-
Dir["#{File.dirname(__FILE__)}/core_ext/*.rb"].sort.each do |path|
  require "lambda_driver/core_ext/#{File.basename(path, '.rb')}"
end
