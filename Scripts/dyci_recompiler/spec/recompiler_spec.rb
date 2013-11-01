require "dyci_recompiler"
include Dyci

describe DyciRecompiler do

  it "fails with no params" do
    expect {Recompiler.new}.to raise_error
  end

  it "initializes with the source path" do
    path = "some_path"
    recompiler = Recompiler.new(path)

    recompiler.should_not be_nil
    recompiler.source_file_path.should eq path
  end
  
end

describe ParamsParser do

  it "fails with no params" do
    expect {ParamsParser.new}.to raise_error
  end

  it "initializes with command string" do
    command_line = "hello there"
    parser = ParamsParser.new(command_line)
    parser.should_not be_nil
    parser.command_line.should eq command_line
  end

  it "correctly resolves command from command line" do
    ParamsParser.new("clang").command.should eq "clang"
    ParamsParser.new("clang xtreme").command.should eq "clang"
    ParamsParser.new("/Some/Tricky/Path/clang xtreme").command.should eq "/Some/Tricky/Path/clang"
  end

  it "correctly resolves command" do
    path = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
    ParamsParser.new(path).command.should eq path
  end

  it "correctly resolves parameters" do
    path = "command -x objective-c"
    ParamsParser.new(path).params.should_not be_nil
    ParamsParser.new(path).params["-x"].should eq "objective-c"

    path = "command -arch x86_64"
    ParamsParser.new(path).params.should_not be_nil
    ParamsParser.new(path).params["-arch"].should eq "x86_84"

    path = "command -fmessage-length=0 -fdiagnostics-show-note-include-stack"
    ParamsParser.new(path).params.should_not be_nil
    ParamsParser.new(path).params["-fmessage-length"].should eq "0"
    ParamsParser.new(path).params["-fdiagnostics-show-note-include-stack"].should eq ""

    path = "command -stdc=c99 -fobjc-gc -Wno-trigraphs -fpascal-strings -O0"
    ParamsParser.new(path).params.should_not be_nil
    ParamsParser.new(path).params["-stdc"].should eq "c99"
    ParamsParser.new(path).params["-fobjc-gc"].should eq ""
    ParamsParser.new(path).params["-Wno-trigraphs"].should eq ""
    ParamsParser.new(path).params["-fpascal-strings"].should eq ""
    ParamsParser.new(path).params["-O0"].should eq ""

    path = "command -Wshorten-64-to-32 -Wpointer-sign -Wno-newline-eof"
    ParamsParser.new(path).params.should_not be_nil
    ParamsParser.new(path).params["-Wshorten-64-to-32"].should eq ""
    ParamsParser.new(path).params["-Wpointer-sign"].should eq ""
    ParamsParser.new(path).params["-Wno-newline-eof"].should eq ""

    path = "command -DDEBUG=1 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk"
    ParamsParser.new(path).params.should_not be_nil
    ParamsParser.new(path).params["-DDEBUG"].should eq "1"
    ParamsParser.new(path).params["-isysroot"].should eq "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk"

    path = "command -mmacosx-version-min=10.8 -g"
    ParamsParser.new(path).params.should_not be_nil
    ParamsParser.new(path).params["-g"].should eq ""
   
     # -I/Users/paultaykalo/Library/Developer/Xcode/DerivedData/BetterConsole-beyclcoqezrzrefcjngawoproqko/Build/Intermediates/BetterConsole.build/Debug/BetterConsole.build/BetterConsole.hmap -I/Users/paultaykalo/Library/Developer/Xcode/DerivedData/BetterConsole-beyclcoqezrzrefcjngawoproqko/Build/Products/Debug/include -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Users/paultaykalo/Library/Developer/Xcode/DerivedData/BetterConsole-beyclcoqezrzrefcjngawoproqko/Build/Intermediates/BetterConsole.build/Debug/BetterConsole.build/DerivedSources/x86_64 -I/Users/paultaykalo/Library/Developer/Xcode/DerivedData/BetterConsole-beyclcoqezrzrefcjngawoproqko/Build/Intermediates/BetterConsole.build/Debug/BetterConsole.build/DerivedSources -F/Users/paultaykalo/Library/Developer/Xcode/DerivedData/BetterConsole-beyclcoqezrzrefcjngawoproqko/Build/Products/Debug -MMD -MT dependencies -MF /Users/paultaykalo/Library/Developer/Xcode/DerivedData/BetterConsole-beyclcoqezrzrefcjngawoproqko/Build/Intermediates/BetterConsole.build/Debug/BetterConsole.build/Objects-normal/x86_64/BCUtils.d --serialize-diagnostics /Users/paultaykalo/Library/Developer/Xcode/DerivedData/BetterConsole-beyclcoqezrzrefcjngawoproqko/Build/Intermediates/BetterConsole.build/Debug/BetterConsole.build/Objects-normal/x86_64/BCUtils.dia -c /Users/paultaykalo/Downloads/BetterConsole-master/BetterConsole/BCUtils.m -o /Users/paultaykalo/Library/Develope36"3F4155F3-D9BD-42C3-A711-431CA19814FA-oqezrzrefcjngawoproqko/Build/Intermediates/BetterConsole.build/Debug/BetterConsole.build/Objects-normal/x86_64/BCUtils.o
  end

  it "correctly resolves Include parameters" do
    
  end

end
