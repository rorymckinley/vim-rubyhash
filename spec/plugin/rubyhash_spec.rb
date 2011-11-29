require 'spec_helper'

describe "rubyhash plugin" do
  before(:each) do
    @plugin_path = File.join(File.dirname(__FILE__), '..', '..', 'plugin', 'rubyhash.vim')
    @runner = RobotVim::Runner.new
    @commands = [ ":source #{@plugin_path}"]
  end

  describe "operating on a single line containing a complete hash" do
    it "converts string hash keys to symbol hash keys" do
      input_buffer = "{'my_key'=>'my_value', \"new_key\"=>'new_value', 'final_key' => 'final_value'}"
      @commands += [ ":call ToSymbolKeysLinewise()"]

      result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
      result.body.should == "{:my_key=>'my_value', :new_key=>'new_value', :final_key => 'final_value'}"
    end

    it "converts Ruby 1.9 style keys to symbols" do
      input_buffer = "{key_one:'value_one', keytwo: 'value:two', keythree: 'value3', key4: My::Class}"
      @commands += [ ":call ToSymbolKeysLinewise()"]

      result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
      result.body.should == "{:key_one =>'value_one', :keytwo => 'value:two', :keythree => 'value3', :key4 => My::Class}"
    end
  end

  describe "operating on a single line containing a snippet of a hash" do
    it "converts string hash keys to symbol hash keys" do
      input_buffer = "        'my_key'=>'my_value', \"new_key\"=>'new_value', 'final_key' => 'final_value'"
      @commands += [ ":call ToSymbolKeysLinewise()"]

      result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
      result.body.should ==  "        :my_key=>'my_value', :new_key=>'new_value', :final_key => 'final_value'"
    end

    it "converts Ruby 1.9 style keys to symbols" do
      input_buffer = "   key_one:'value_one', keytwo: 'value:two', keythree: 'value3', key4: My::Class"
      @commands += [ ":call ToSymbolKeysLinewise()"]

      result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
      result.body.should == "   :key_one =>'value_one', :keytwo => 'value:two', :keythree => 'value3', :key4 => My::Class"
    end
  end

end
