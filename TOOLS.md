# TOOLS

## Documentation

- To learn more about a command line tool in the shell, you can try to read its system manual page using the `man` command. You need to execute a special command line to view the entire manual page. Use `man <command_name> | cat` to view the entire manual page (where <command_name> is the name of the command you want to learn more about).

## Docker tools

- Use `docker build` to build a Docker image.
- Use `docker run` to run a Docker container.
- Use `docker ps` to list running Docker containers.
- Use `docker images` to list Docker images.
- Use `docker stop` to stop a Docker container.
- Use `docker rm` to remove a Docker container.
- Use `docker rmi` to remove a Docker image.

## Go tools

You need to know about these Go programming language tools.

- Use `go fmt` to format Go source code.
- Use `go vet` to check Go source code for suspicious constructs.
- Use `go test` to run Go unit tests.
- Use `go mod` to manage Go module dependencies.
- Use `go run` to run Go source code.

## HashiCorp Vault tools

- Use `vault --help` or `vault command --help` to get detailed help.
- Use `vault path-help` to get help on a specific path.
- Use `vault login` to authenticate with Vault.
- Use `vault kv put` to store static secrets in a Vault K/V secrets engine.
- Use `vault kv get` to retrieve secrets from a Vault K/V secrets engine.
- Use `vault kv list` to list paths in Vault.
- Use `vault kv delete` to delete secrets from a Vault K/V secrets engine.
- Use `vault secrets enable` to enable a secrets engine.
- Use `vault auth enable` to enable an auth method.
- Use `vault token create` to create a new token directly from the token store.
- Use `vault policy` to interact with ACL policies.
- Use `vault policy read` to read an ACL policy.
- Use `vault policy write` to write an ACL policy.
- Use `vault policy delete` to delete an ACL policy.
- Use `vault status` to learn about Vault server status.
- Use `vault audit` to manage audit devices.
- Use `vault lease` to manage leases.

## Rust tools

You need to know about these Rust programming language tools.

- Use `rustfmt` to format Rust source code.
- Use `cargo check` to check Rust source code for suspicious constructs.
- Use `cargo test` to run Rust unit tests.
- Use `cargo run` to run Rust source code.

## Shell

You need to know about these command line tools for the shell.

- Use `history` to view your command history and remind yourself of things you've done.
  - If you find commands that do not work in the history, remember to not try those commands again.
- Use `bash` or `zsh` as your default shell when possible.
- Check processes with `ps` or `top`.
- Examine environment variables with `env` or `printenv`.
- DO NOT execute any destructive commands without warning AND user confirmation.
- If a command does not succeed or return 0 after 2 tries, figure out a new approach and try again. Use the `man` command for the command if it exists to learn more about the command.

## System and network tools

You need to know about these system tools. (when in doubt about usage try to read the tool's manual page)

- Use `journalctl` to view system logs, and pass in `-u` with an application/username to filter logs to app.
- Use `systemctl` to manage system services.
- Use `curl` to download files from the internet.
- Use `unzip` to unzip .zip files.
- Use `tar -zxf` to extract .tar.gz files.
- Use `nc` to create network connections for testing and debugging connectivity, open ports, and more.
  
## TypeScript tools

You need to know about these TypeScript programming language tools.

- Use `bun` for runtime, package management, bundling and test running.
- Use `tsc` to compile TypeScript files.
- Use `ts-node` to run TypeScript files.
- Use `tslint` to lint TypeScript files.
- Use `ts-jest` to test TypeScript files.

## Vagrant tools

- Use `vagrant` to manage virtual machines.
- Use `vagrant ssh` to connect to a running virtual machine.
- Use `vagrant up` to start a virtual machine.
- Use `vagrant halt` to stop a running virtual machine.
- Use `vagrant destroy -f` to delete a virtual machine.
- Use `vagrant status` to check virtual machine status.
- Use `vagrant plugin` to manage Vagrant plugins.
