require "./dyci_recompiler"
require 'test/unit'

# require File.dirname(__FILE__) + '/../test_helper'

class TestDyciRecompiler < Test::Unit::TestCase

	def test_should_raise_without_parameters
		assert_raise(ArgumentError) { DyciRecompiler.new }
	end
end