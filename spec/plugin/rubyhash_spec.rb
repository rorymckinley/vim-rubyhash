require 'spec_helper'

describe "rubyhash plugin" do
  before(:each) do
    @plugin_path = File.join(File.dirname(__FILE__), '..', '..', 'plugin', 'rubyhash.vim')
    @runner = RobotVim::Runner.new
    @commands = [ ":source #{@plugin_path}"]
  end

  describe "operating on a single line" do
    it "converts string hash keys to symbol hash keys" do
      input_buffer = "{'my_key'=>'my_value', \"new_key\"=>'new_value', 'final_key' => 'final_value'}"
      @commands += [ ":call ToSymbolKeysLinewise()"]

      result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
      result.body.should == "{:my_key=>'my_value', :new_key=>'new_value', :final_key => 'final_value'}"
    end
  end
end
