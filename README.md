# Tatin

> "_Tatin is a classic French upside-down tart with caramelized apples baked under a pastry crust_."

Tatin is a VM sandbox for running potentially dangerous large language model (LLM) agent workflows on Apple Silicon Macs.

## Why

- LLM agents with tool calling abilities are potentially dangerous at all times, and you cannot trust agents to coexist with humans in the same computing environment. You put the integrity of your data and system at risk whenever you run an agent tool in your primary computing environment.
- Tatin provides a safe, contained space for AI agents to operate with sudo access, and minimizes the blast radius of any potential damage an agent could cause.
- You can run your agent with all permission checks switched off so that the agent can operate for extended periods without interruption.

## What makes this tart so chonky?

Tatin combines several nice technologies toward the goal of virtual machine based sandboxes using Apple native virtualization. The project also aims to ship with an operating system image that installs a rich development environment for multiple languages along with a selection of popular AI agent tools.

- [Packer](https://developer.hashicorp.com/packer) to build the machine image
- [Tart](https://tart.run/) virtualization framework for Apple Silicon
- [Vagrant](https://www.vagrantup.com/) to deploy the machine image
- [vagrant-tart](https://github.com/letiemble/vagrant-tart) provider

> [!NOTE]
> **Tatin does not provide any model inference servers**. You must run your own inference server, like [mlx-lm](https://github.com/ml-explore/mlx-lm), [Ollama](https://ollama.com/), [vLLM](https://docs.vllm.ai/en/latest/), or [LM Studio](https://lmstudio.ai/), and configure the agent tools in Tatin to use the server. You can of course also point the agent tools at cloud based services.

### AI agent tools

- [Pi](https://shittycodingagent.ai/)
- [Claude Code](https://claude.ai/code) - the Anthropic terminal agent app
  - Configured to dangerously skip permissions
- [OpenCode](https://opencode.ai/) - open source terminal agent app
  - Example configuration allows all permissions
- [Crush](https://github.com/charmbracelet/crush) - open source terminal agent app

Tatin enables configuration examples for these agent apps in the `work/` directory:

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

The sandbox is built with the following environment by default:

- Debian 13
- 4 CPU cores, 8GB RAM, 20GB disk
- User **agent** with password-less sudo access (runtime user)
- User **admin** used during Packer image build (not available at runtime)

## Prerequisites

1. Apple Silicon Mac with suitable available resources.
  - You can decrease resources for older Macs. Review the `variables.pkr.hcl` file for related variables.

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

> [!NOTE]
> This is a long-running process that takes 10-15 minutes.

In addition to covering the prerequisites, you must build the base VM image with Packer before proceeding.

```shell
packer init packer/ && packer build packer/
```

Packer builds a `tatin` image in your local Tart registry with all development tools and AI agents pre-installed.

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
    vagrant up
    ```

1. Connect to the sandbox (logs in as `agent` user automatically).

    ```shell
    vagrant ssh
    ```

1. When done, you can shut the system down.

    ```shell
    sudo shutdown -h now
    ```

    or

1. stop the VM.

    ```shell
    vagrant halt
    ```

1. Completely remove the VM to clean up, free up disk space, or start over.

    ```shell
    vagrant destroy -f
    ```

> [!IMPORTANT]
> Don't forget your content in the `work` folder.

## Usage

### Vagrant commands

You can use `vagrant` to manage the VM life-cycle.

```shell
vagrant up              # Start VM
vagrant halt            # Stop VM
vagrant destroy -f      # Delete VM
vagrant ssh             # Connect to VM
vagrant provision       # Re-run provisioning
vagrant status          # Check status
```

## Provisioning stages

The Packer build runs these provisioning stages to create the base image:

1. **base-system** installs core packages, build tools, shell utilities
2. **create-agent-user** creates the `agent` user with sudo privileges
3. **bun** installs Bun runtime (as agent user)
4. **agent-tools** installs Claude Code and OpenCode (as agent user)
5. **bun-tools** installs Pi, Crush, and qmd (as agent user)
6. **finalize** configures shell environment and cleans up (as agent user)

All provisioning runs as the `admin` user initially, then creates and switches to the `agent` user for tool installation.

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

#### Environment variable overrides

You can override VM resources using environment variables without editing the `Vagrantfile`:

```shell
export TATIN_CPUS=8         # Override CPU cores
export TATIN_MEMORY=16384    # Override RAM in MB
export TATIN_DISK=50         # Override disk in GB

vagrant up
```

Or use with the tatin wrapper script:

```shell
TATIN_CPUS=8 ./scripts/tatin.sh up
```

Defaults are: 4 CPUs, 8192MB RAM, 20GB disk.

### Synced folders

```plaintext
┌─────────────────────────────────────────────────────────────────┐
│  Tart VM Host (macOS)                                           │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  ./work/                                                │    │
│  │  ┌─────────────────────────────────────────────────┐    │    │
│  │  │  project files                                  │    │    │
│  │  └─────────────────────────────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │  Vagrant synced_folder
                              │  (Tatin VM)
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Tatin VM (Debian 13)                                           │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  /home/agent/work/                                      │    │
│  │  ┌─────────────────────────────────────────────────┐    │    │
│  │  │  project files                                  │    │    │
│  │  └─────────────────────────────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

The VM only shares the `work/` folder with the host; this folder is the only direct point of contact with the host system from the guest system for safety.

```ruby
config.vm.synced_folder "./work", "/home/agent/work"
```

Place files in `./work` on the host to access them at `/home/agent/work` in the VM.

### Secure shell credentials

Default credentials:

- Username: `agent`
- Password: `xmLGFhZqGlXvB2lJ/s+J8g=`

The VM also has a sudoers rule allowing password-less sudo for the agent user.

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
