#import "Basic";
#import "Compiler";
#import "File_Utilities";
#import "String";

build :: () {
    context.allocator = __temporary_allocator;

    current_workspace := get_current_workspace();
    set_build_options_dc(.{do_output = false}, current_workspace);

    workspace := compiler_create_workspace("Jai Simple Server");
    build_options := get_build_options(workspace);
    build_options.output_type = .EXECUTABLE;
    build_options.output_executable_name = "jai-server";
    build_options.temporary_storage_size = 2097152;
    build_options.import_path = .["C:/jai/modules", #run tprint("%../", #filepath)];
    print("Module folders: %\n", build_options.import_path);
    set_build_options(build_options, workspace);
    set_working_directory(#filepath);

    files := file_list(tprint("%src", #filepath), true);
    for file : files {
        if !ends_with(file, ".jai") {
            continue;
        }

        print("Build file: %\n", file);
        add_build_file(file, workspace);
    }
}

#run build();
