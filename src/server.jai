main :: () {
    args := get_command_line_arguments();
    defer array_free(args);

    port: u16 = 3000;
    if args.count > 1 {
        potential_port, success := parse_int(*args[1]);
        if success {
            port = xx potential_port;
        }
    }

    server := create_server(port);
    handle(server, .Get, "*", (request: *HttpRequest, response: *HttpResponse, path: string) -> HttpResult {
        file, found := read_entire_file(tprint("./%", path), zero_terminated = true, log_errors = false);
        if found {
            file.count += 1;

            content_type := get_content_type(path);
            return reply(response, 200, .[.["Content-Type", content_type]], file, .Allocated);
        }

        file, found = read_entire_file(tprint("./%/index.html", path), zero_terminated = true, log_errors = false);
        if found {
            file.count += 1;

            html_content_type :: #run get_content_type("html");
            content_type := get_content_type(path);
            return reply(response, 200, .[.["Content-Type", html_content_type]], file, .Allocated);
        }

        return reply(response, 404, .[], null);
    });

    server_listen(server);
}

#import "KodaMicroHttp";
#import "Basic";
#import "File";
#import "String";