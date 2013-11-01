require "dyci_recompiler/version"

module Dyci

  class Recompiler

	attr_reader :source_file_path

  	def initialize(source_file_path)
  		@source_file_path = source_file_path
  	end

  end


  class ParamsParser
    attr_reader :command_line, :command

  	def initialize(command_line)
  		@command_line = command_line
  		self.parse
  	end
    
    def parse
    	@command = "clang"
    end

    def params
    	{
    		
    	}
    end

  end
end
