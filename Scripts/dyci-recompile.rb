#!/usr/bin/ruby
VERBOSE = false

def printv(string)
	print string if VERBOSE
end

def last_build_state_dat_path
	`find ~/Library/Developer/Xcode/DerivedData -type f -name build-state.dat -print0 | xargs -0 ls -t | head -n 1`
end

def compilation_params(compilation_string)
	command = compilation_string
	library_search_paths = []
	frameworks_search_paths = []
	params = {}
	params["LParams"] = library_search_paths
	params["FParams"] = frameworks_search_paths
    
    compilation_string_left = compilation_string
    while compilation_string_left.length > 0
    	match = nil
    	if match = compilation_string_left.match(/(.*?)\s(--?[^\s]+)\s?([^-\s][^\s]*)?$/) 
		    compilation_string_left, param, value = match[1..3]
		        # print "LEFT : " + compilation_string_left + "\n"
			    printv "PARAM : #{param}\n"
    			printv "VALUE : #{value}\n"
    			if param.start_with?("-L")
    				library_search_paths << param
    			elsif param.start_with?("-F")
    				frameworks_search_paths << param		
    			elsif param.match(/^-mi.*-min=.*/)
    				params["-minOSParam"] = param	
    			end

    			value = "" if value == nil
    			params[param] = value

    			true
    	else
    		command = compilation_string_left
    		break
    	end
    end

	return command, params
end


def recompile(path_to_build_state_dat, source_file_path)
	output_file = File.basename(source_file_path, ".*") + ".o"
	regexp = "CompileC.*/usr/bin/clang.*#{source_file_path}"
	output = `grep -E "#{regexp}" "#{path_to_build_state_dat}"`
	# print output
	compilation_record = output[/CompileC.*#{source_file_path}.*#{output_file}/] 
    info,path_change,*rest = compilation_record.split(/\r/)
    path_change.strip!
    `#{path_change}`
    compilation_line = rest.last.strip
    `#{compilation_line}`

    printv "Changing directory with\n'#{path_change}'\n"
    printv "Compiling file with\n'#{compilation_line}'\n"

    obj_file_path = compilation_line.match(/-o\s(.*)/)[1]
    printv "Objectt file path\n#{obj_file_path}\n"

    return compilation_line, obj_file_path

end


def compile_dylib(dylib_path, compilation_line, obj_file_path)

	#creating new random name wor the dynamic library
	library_name = "dyci" + rand(1000000).to_s + ".dylib"

	command, params = compilation_params(compilation_line)

	compile_dylib_command = []
	compile_dylib_command << command
	compile_dylib_command << "-arch" << params["-arch"]
	compile_dylib_command << "-dynamiclib"
	compile_dylib_command << "-isysroot" << params["-isysroot"]
	compile_dylib_command << params["LParams"] if params["LParams"].length > 0
	compile_dylib_command << params["FParams"] if params["FParams"].length > 0
	compile_dylib_command << obj_file_path
	compile_dylib_command << "-install_name" << "/usr/local/bin/#{library_name}"
	compile_dylib_command << "-Xlinker -objc_abi_version -Xlinker 2"
	compile_dylib_command << "-ObjC"
	compile_dylib_command << "-undefined dynamic_lookup"
	compile_dylib_command << "-fobjc-arc"
	compile_dylib_command << "-fobjc-link-runtime"
	compile_dylib_command << "-Xlinker -no_implicit_dylibs"
	compile_dylib_command << params["-minOSParam"]
	compile_dylib_command << "-single_module"
	compile_dylib_command << "-compatibility_version 5"
	compile_dylib_command << "-current_version 5"
	compile_dylib_command << "-o" << File.expand_path("~/.dyci/#{library_name}")

    #Running linker, that will create dynamic library for us
    compile_dylib_string = compile_dylib_command.join(" ")

    printv "#{compile_dylib_string}"

    `#{compile_dylib_string}`

end

compilation_line, obj_file_path = recompile(last_build_state_dat_path.strip, ARGV[0])
compile_dylib("~/.dyci/", compilation_line, obj_file_path)


