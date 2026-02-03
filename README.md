# Tatin

> "_Tatin is a classic French upside-down tart with caramelized apples baked under a pastry crust_."

Tatin is a VM sandbox for running potentially dangerous large language model agent workflows on Apple Silicon Macs.

The project combines [Tart](https://tart.run/) virtualization with [Vagrant](https://www.vagrantup.com/) through the [vagrant-tart](https://github.com/letiemble/vagrant-tart) plugin to create a full development environment where AI agents can operate with sudo access in a safe, contained space.

## Why

- LLM agents with tool calling abilities are potentially dangerous at all times, and cannot be trusted to cohabitate with humans in the same computing environment. You put the integrity of your data and system at risk whenever you run an agent tool in your primary computing environment.
- Tatin provides a safe, contained space for AI agents to operate with sudo access, and minimizes the blast radius of any potential damage an agent could cause.
- You can run your agent with all permission checks switched off so that the agent can operate for extended periods without interruption.

## What's inside

Tatin combines several nice technologies towards the goal of virtual machine based sandboxes using Apple native virtualization with an operating system image that ships with a rich development environment for multiple languages along with a selection of popular AI agent tools.

> **Note:** Tatin does not provide any model inference servers. You must run your own inference server, like [Ollama](https://ollama.com/), [vLLM](https://docs.vllm.ai/en/latest/), [LM Studio](https://lmstudio.ai/), and configure the agent tools in Tatin to use the server.

### AI agent tools

- [Pi](https://shittycodingagent.ai/)
- [Claude Code](https://claude.ai/code) - Anthropic's terminal agent
  - Configured to dangerously skip permissions
- [OpenCode](https://opencode.ai/) - open source terminal agent
  - Example configuration allows all permissions
- [Crush](https://github.com/charmbracelet/crush) - open source terminal agent
- Tool configuration examples in `work/` directory

### Development tools

- [mise](https://mise.jdx.dev/) - unified tool version manager
- build-essential (gcc, make, etc.)
- Bun
- Go
- Python
- Node.js
- Ruby
- Rust
- beads, curl, git, htop, jq, qmd, tmux, tree, unzip, vim, wget, zsh  

### Base Environment

- Debian 13
- 4 CPU cores, 8GB RAM, 20GB disk
- User **admin** with sudo access

## Prerequisites

1. Apple Silicon Mac

1. Tart macOS native virtualization installed:

   ```shell
   brew install cirruslabs/cli/tart
   ```

1. Vagrant for VM lifecycle management installed:

   ```shell
   brew install hashicorp/tap/hashicorp-vagrant
   ```

1. vagrant-tart plugin installed:

   ```shell
   vagrant plugin install vagrant-tart
   ```

1. **Packer** for building the image

   ```shell
   brew tap hashicorp/tap && \
   brew install hashicorp/tap/packer
   ```

### Build the base image

> **NOTE**: This is a long-running process that takes 10-15 minutes depending on network speed.

In addition to covering the prerequisites, you must build the base VM image with Packer before proceeding.

1. Change into the packer directory.

    ```shell
    cd packer
    ```

1. Initialize Packer plugins.

    ```shell
    packer init .
    ```

1. Validate the template.

    ```shell
    packer validate .
    ```

1. Build the image.

    ```shell
    packer build .
    ```

This creates a `tatin` image in your local Tart registry with all development tools and AI agents pre-installed.

Verify image creation:

```shell
tart list
```

## Quick start

1. Clone the repository.

    ```shell
    git clone https://github.com/brianshumate/tatin.git
    ```

1. Change into the repository directory.

    ```shell
    cd tatin
    ```

1. Build the base image (one-time setup).

    ```shell
    packer init packer/ && packer build packer/
    ```

1. Start the sandbox.

    ```shell
    ./scripts/tatin.sh up
    ```

1. Connect to the sandbox.

    ```shell
    ./scripts/tatin.sh ssh
    # or
    vagrant ssh
    ```

1. When done, stop the VM.

    ```shell
    ./scripts/tatin.sh down
    # or
    vagrant halt
    ```

1. To completely remove the VM.

    ```shell
    ./scripts/tatin.sh delete
    # or
    vagrant destroy -f
    ```


## Usage

The `tatin` script provides a clean interface for VM management:

```shell
tatin up       # Start and provision the VM
tatin down     # Stop the VM (preserves state)
tatin delete   # Destroy the VM completely
tatin status   # Show current VM status
tatin ssh      # Connect to the running VM
tatin logs     # View provisioning logs
```

### Direct Vagrant Commands

You can also use Vagrant directly:

```shell
vagrant up              # Start VM
vagrant halt            # Stop VM
vagrant destroy -f      # Delete VM
vagrant ssh             # Connect to VM
vagrant provision       # Re-run provisioning
vagrant status          # Check status
```

### Provisioning stages

The Packer build runs these provisioning stages to create the base image:

1. **base-system** - Core packages, build tools, shell utilities
2. **mise** - Installs [mise](https://mise.jdx.dev/) and all language runtimes (Python, Go, Node.js, Ruby, Bun, Rust)
3. **claude-code** - Claude Code CLI
4. **opencode** - OpenCode CLI
5. **crush** - Crush CLI (via npm)
6. **finalize** - Shell configuration, cleanup

## Configuration

### VM resources

Edit the `Vagrantfile` to adjust resources:

```ruby
config.vm.provider "tart" do |tart|
  tart.cpus = 4        # CPU cores
  tart.memory = 8192   # RAM in MB
  tart.disk = 20       # Disk in GB
end
```

### Synced folders

Only the `work/` directory is shared between host, and is the only point of direct contact with the host system for safety.

```ruby
config.vm.synced_folder "./work", "/home/admin/work"
```

Place files in `./work` on the host to access them at `/home/admin/work` in the VM.

### SSH credentials

Default credentials (Debian image defaults):
- Username: `admin`
- Password: `admin`

## Using AI agent tools

Once connected to the sandbox, each tool requires some configuration:

### Pi

Start `pi`, and login:

```shell
/login
```

### Claude Code

Authenticate with Claude Code:

```shell
claude auth login
# or set ANTHROPIC_API_KEY environment variable
```

Run Claude Code:
```shell
claude
```

### OpenCode

Configure using the example in the shared `work/` directory:

```shell
cp ~/work/example.opencode.json ~/.config/opencode/config.json
# Edit config.json with your model server details
```

Run OpenCode:
```shell
opencode
```

### Crush

Configure using the example in the shared `work/` directory:

```shell
cp ~/work/example.crush.json ~/.config/crush/config.json
# Edit config.json with your model server details
```

Run Crush:
```shell
crush
```

## Troubleshooting

### View logs

```shell
./scripts/tatin.sh logs
```

or

```shell
cat .tatin/tatin.log
```

### Re-provision

```shell
vagrant provision
```

### Fresh start

```shell
./scripts/tatin.sh delete && \
./scripts/tatin.sh up
```

### List installed Tart VMs

```shell
tart list
```

## License

Mozilla Public License 2.0
