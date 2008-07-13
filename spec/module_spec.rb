require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
require 'pp'

describe Module do

  before(:all) do
    module Foo
      module Bar
        module Noo
          module Too
          end
        end
      end

      class Zed
      end
    end

    class Baz
    end

    class Bar
    end
  end

  it "should raise NameError for a missing constant" do
    lambda { Object::find_const('MissingConstant') }.should raise_error(NameError)
  end

  it "should be able to get a recursive constant" do
    Object::find_const('Foo::Bar').should == Foo::Bar
  end

  it "should ignore get Constants from the Kernel namespace correctly" do
    Object::find_const('::Foo::Bar').should == ::Foo::Bar
  end

  it "should not cache unresolvable class string" do
    pending "This shouldn't be applicable anymore, but hopefully somebody can double check before it is removed"
    lambda { find_const('Foo::Bar::Baz') }.should raise_error(NameError)
    Object::send(:__nested_constants__).has_key?('Foo::Bar::Baz').should == false
  end

  it "should find relative constants" do
    Foo.find_const('Bar').should == Foo::Bar
    Foo.find_const('Baz').should == Baz
  end

  it "should find sibling constants" do
    Foo::Bar.find_const("Zed").should == Foo::Zed
  end

  it "should find nested constants on nested constants" do
    # pending "Implement this"
    Foo::Bar.find_const('Noo::Too')
  end
  
  it "should be able to deal with constants being added and removed" do
    Object.find_const('Bar') # First we load Bar with find_const
    Object.module_eval { remove_const('Bar') } # Now we delete it
    module Bar; end; # Now we redefine it
    Object.find_const('Bar').should == Bar
  end

end
