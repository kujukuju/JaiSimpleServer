main :: () {
    args := get_command_line_arguments();
    defer array_free(args);

    port: u32 = 3000;
    if args.count > 1 {
        potential_port, success := parse_int(*args[1]);
        if success {
            port = xx potential_port;
        }
    }

    print("Listening on port %...\n", port);

    mg_http_static_start(".", port);
}

#import "mongooseJai";
#import "Basic";
#import "String";