require 'spec_helper'
require 'lib/why_not'
 
describe "WhyNot" do
  describe "/^is(nt|_not)_.+\?$/ method" do
    it "should work for isnt_a? method" do
      [].isnt_a?(Array).should be_false
      [].isnt_a?(String).should be_true
    end
    it "should work for is_not_a? method" do
      [].is_not_a?(Array).should be_false
      [].is_not_a?(String).should be_true
    end
    it "should raise error for is_not_azzz?" do
      lambda { [].is_not_azzz?(Array) }.should raise_exception(NoMethodError)
    end
    it "should raise error for isnt_azzz?" do
      lambda { [].isnt_azzz?(Array) }.should raise_exception(NoMethodError)
    end
  end
  describe "/^not_.*\?$/ method" do
    it "should work for empty? method on arrays" do
      array = []
      array.empty?.should be_true
      lambda { array.not_empty?.should be_false }.should_not raise_exception
      array = %w(one two three four five)
      array.empty?.should be_false
      array.not_empty?.should be_true
    end
    it "should work for NilClass" do
      obj = nil
      obj.nil?.should be_true
      lambda { obj.not_nil?.should be_false }.should_not raise_exception
    end
    it "should raise NoMethodError if associated method does not exist" do
      array = %w(one two three)
      lambda { array.not_even? }.should raise_exception(NoMethodError, /even/)
    end
    it "should work for methods defined through opening a class" do
      class TestArray < Array; def even?; self.size%2 == 0; end; end
      array = TestArray.new(%w(one two three))
      lambda { array.even?.should == false }.should_not raise_exception
      lambda { array.not_even?.should == true}.should_not raise_exception
    end
    it "should raise NoMethodError when not negating a test (?) method" do
      array = %w(one two three)
      lambda { array.not_length }.should raise_exception(NoMethodError, /not_length/)
    end
    it "should not access protected methods but should from inside method call" do
      class TestArray < Array; def protected_odd?; self.size % 2 != 0; end; protected :protected_odd?; end
      array = TestArray.new(%w(one two three))
      lambda { array.protected_odd? }.should raise_exception
      class TestArray < Array; def inner_odd?; protected_odd?; end; end
      lambda { array.inner_odd?.should == true }.should_not raise_exception
      lambda { array.not_inner_odd?.should == false}.should_not raise_exception
    end
    it "should not access private methods but should from inside method call" do
      class TestArray < Array; def private_odd?; self.size % 2 != 0; end; private :private_odd?; end
      array = TestArray.new(%w(one two three))
      lambda { array.privat_odd? }.should raise_exception
      class TestArray < Array; def inner_odd?; private_odd?; end; end
      lambda { array.inner_odd?.should == true }.should_not raise_exception
      lambda { array.not_inner_odd?.should == false}.should_not raise_exception
    end
  end
end
