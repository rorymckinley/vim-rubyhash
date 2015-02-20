require 'spec_helper'

describe "rubyhash plugin" do
  before(:each) do
    @plugin_path = File.join(File.dirname(__FILE__), '..', '..', 'plugin', 'rubyhash.vim')
    # use a fake vimrc file so we don't confuse the tests by executing the contents of
    # our real .vimrc file
    @runner = RobotVim::Runner.new(:vimrc => "spec/test_vimrc")
    @commands = [ ":source #{@plugin_path}"]
  end

  describe "operating on a single line containing a complete hash" do

    describe "ToSymbolKeysLinewise" do

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

      it "leaves existing symbol keys untouched when converting to symbol keys" do
        input_buffer = "{ change_me: 'ping', :leave_me => 'pang', 'change_me_too' => 'pong' }"
        @commands += [ ":call ToSymbolKeysLinewise()"]

        result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
        result.body.should == "{ :change_me => 'ping', :leave_me => 'pang', :change_me_too => 'pong' }"
      end

    end

    describe "To19KeysLinewise" do

      it "converts symbol keys" do
        input_buffer = %q{{:key_one=>'val_one', :key_two => "val_two"}}
        @commands += [ ":call To19KeysLinewise()"]

        result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
        result.body.should == %q|{key_one:'val_one', key_two: "val_two"}|
      end

      it "converts string keys" do
        input_buffer = %q|{"key_one"=>"val_one", 'key_two' => 'val_two'}|
        @commands += [ ":call To19KeysLinewise()"]

        result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
        result.body.should == %q|{key_one:"val_one", key_two: 'val_two'}|
      end

      it "leaves 1.9 style keys unchanged" do
        input_buffer = %q|{"key_one"=>"val_one", key_two: "val_two"}|
        @commands += [ ":call To19KeysLinewise()"]

        result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
        result.body.should == %q|{key_one:"val_one", key_two: "val_two"}|
      end

    end

    describe "ToStringKeysLinewise" do

      it "converts symbol keys" do
        input_buffer = %q{{:key_one=>'val_one', :key_two => "val_two"}}
        @commands += [ ":call ToStringKeysLinewise()"]

        result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
        result.body.should == %q|{"key_one"=>'val_one', "key_two" => "val_two"}|
      end

      it "converts Ruby 1.9 style keys to strings" do
        input_buffer = "{key_one:'value_one', keytwo: 'value:two', keythree: 'value3', key4: My::Class}"
        @commands += [ ":call ToStringKeysLinewise()"]

        result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
        result.body.should == %q|{"key_one" =>'value_one', "keytwo" => 'value:two', "keythree" => 'value3', "key4" => My::Class}|
      end

    end

    describe "ToSingleQuotedStringKeysLinewise" do

      it "converts symbol keys" do
        input_buffer = %q{{:key_one=>'val_one', :key_two => "val_two"}}
        @commands += [ ":call ToSingleQuotedStringKeysLinewise()"]

        result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
        result.body.should == %q|{'key_one'=>'val_one', 'key_two' => "val_two"}|
      end

      it "converts Ruby 1.9 style keys to strings" do
        input_buffer = "{key_one:'value_one', keytwo: 'value:two', keythree: 'value3', key4: My::Class}"
        @commands += [ ":call ToSingleQuotedStringKeysLinewise()"]

        result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
        result.body.should == %q|{'key_one' =>'value_one', 'keytwo' => 'value:two', 'keythree' => 'value3', 'key4' => My::Class}|
      end

    end

  end

  describe "operating on a single line containing a snippet of a hash" do

    describe "ToSymbolKeysLinewise" do

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

      it "leaves existing symbol keys untouched when converting to symbol keys" do
        input_buffer = " change_me: 'ping', :leave_me => 'pang', 'change_me_too' => 'pong' "
        @commands += [ ":call ToSymbolKeysLinewise()"]

        result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
        result.body.should == " :change_me => 'ping', :leave_me => 'pang', :change_me_too => 'pong' "
      end

    end

    describe "To19KeysLinewise" do

      it "converts symbol keys" do
        input_buffer = %q|:key_one=>'val_one', :key_two => "val_two"|
        @commands += [ ":call To19KeysLinewise()"]

        result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
        result.body.should == %q|key_one:'val_one', key_two: "val_two"|
      end

      it "converts string keys" do
        input_buffer = %q|"key_one"=>"val_one", 'key_two' => 'val_two'|
        @commands += [ ":call To19KeysLinewise()"]

        result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
        result.body.should == %q|key_one:"val_one", key_two: 'val_two'|
      end

      it "leaves 1.9 style keys unchanged" do
        input_buffer = %q|"key_one"=>"val_one", key_two: "val_two"|
        @commands += [ ":call To19KeysLinewise()"]

        result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
        result.body.should == %q|key_one:"val_one", key_two: "val_two"|
      end

    end

    describe "ToStringKeysLinewise" do

      it "converts symbol keys" do
        input_buffer = %q|:key_one=>'val_one', :key_two => "val_two"|
        @commands += [ ":call ToStringKeysLinewise()"]

        result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
        result.body.should == %q|"key_one"=>'val_one', "key_two" => "val_two"|
      end

      it "converts Ruby 1.9 style keys to symbols" do
        input_buffer = "key_one:'value_one', keytwo: 'value:two', keythree: 'value3', key4: My::Class"
        @commands += [ ":call ToStringKeysLinewise()"]

        result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
        result.body.should == %q|"key_one" =>'value_one', "keytwo" => 'value:two', "keythree" => 'value3', "key4" => My::Class|
      end

    end

    describe "ToSingleQuotedStringKeysLinewise" do

      it "converts symbol keys" do
        input_buffer = %q|:key_one=>'val_one', :key_two => "val_two"|
        @commands += [ ":call ToSingleQuotedStringKeysLinewise()"]

        result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
        result.body.should == %q|'key_one'=>'val_one', 'key_two' => "val_two"|
      end

      it "converts Ruby 1.9 style keys to symbols" do
        input_buffer = "key_one:'value_one', keytwo: 'value:two', keythree: 'value3', key4: My::Class"
        @commands += [ ":call ToSingleQuotedStringKeysLinewise()"]

        result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
        result.body.should == %q|'key_one' =>'value_one', 'keytwo' => 'value:two', 'keythree' => 'value3', 'key4' => My::Class|
      end

    end

  end

  describe "default keymappings" do
    before(:each) do
      @commands << ":let mapleader='\'"
    end

    it "converts to symbols with the sequence <Leader>rs" do
      input_buffer = %q|'key_one' => 'one'|
      @commands += [ '\rs' ]

      result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
      result.body.should == %q|:key_one => 'one'|
    end

    it "converts to strings with the sequence <Leader>rt" do
      input_buffer = %q|:key_one => 'one'|
      @commands += [ '\rt' ]

      result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
      result.body.should == %q|"key_one" => 'one'|
    end

    it "converts to single-quoted strings with the sequence <Leader>rq" do
      input_buffer = %q|:key_one => 'one'|
      @commands += [ '\rq' ]

      result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
      result.body.should == %q|'key_one' => 'one'|
    end

    it "converts to Ruby1.9 keys with the sequence <Leader>rr" do
      input_buffer = %q|:key_one => 'one'|
      @commands += [ '\rr' ]

      result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
      result.body.should == %q|key_one: 'one'|
    end

  end

  describe "overriding default keymappings" do
    it "does not set the keymappings if rubyhash_map_keys is set to 0" do
      input_buffer = %q|:key_one => 'one'|
      @commands.unshift(":let rubyhash_map_keys=0")
      @commands << ":let mapleader='\'"
      @commands += [ '\rr' ]
      result = @runner.run(:commands => @commands.join("\n")+"\n", :input_file => input_buffer)
      result.body.should_not == %q|key_one: 'one'|
    end
  end
end
