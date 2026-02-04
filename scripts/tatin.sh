#!/usr/bin/env bash
#
# tatin - Lifecycle management for Tatin LLM agent sandbox
#
# Usage:
#   tatin up       Start the VM
#   tatin down     Stop the VM
#   tatin delete   Delete the VM
#   tatin status   Check VM status
#   tatin ssh      Connect to the VM
#   tatin logs     View provisioning logs
#

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="${PROJECT_DIR}/.tatin"
LOG_FILE="${LOG_DIR}/tatin.log"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Colors (muted, not emoji-heavy per AGENTS.md)
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Unicode symbols (per AGENTS.md visual design)
readonly SYM_PENDING="○"
readonly SYM_PROGRESS="◐"
readonly SYM_DONE="●"
readonly SYM_CHECK="✓"
readonly SYM_FAIL="✗"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Logging
log() {
    echo "[${TIMESTAMP}] $*" >> "$LOG_FILE"
}

# Print with symbol
print_status() {
    local symbol="$1"
    local color="$2"
    local message="$3"
    echo -e "${color}${symbol}${NC} ${message}"
}

# Spinner for long-running operations
spinner() {
    local pid=$1
    local message="${2:-Working}"
    local spin_chars=("◐" "◓" "◑" "◒")
    local spin_index=0
    local delay=0.1

    # Hide cursor - suppress errors if terminal doesn't support it
    tput civis 2>/dev/null || true

    # Cleanup function to ensure cursor is restored
    cleanup() {
        tput cnorm 2>/dev/null || true
        printf "\r"
    }
    trap cleanup EXIT

    while kill -0 "$pid" 2>/dev/null; do
        printf "\r${BLUE}%s${NC} %s..." "${spin_chars[$((spin_index++ % 4))]}" "$message" > /dev/tty
        sleep "$delay"
    done

    # Restore cursor
    tput cnorm 2>/dev/null || true
    printf "\r"
}

# Run vagrant command with spinner and logging
run_vagrant() {
    local action="$1"
    local message="$2"
    shift 2
    local extra_args=("$@")

    cd "$PROJECT_DIR"
    log "Running: vagrant $action ${extra_args[*]}"

    # Run in background
    vagrant "$action" "${extra_args[@]}" >> "$LOG_FILE" 2>&1 &
    local pid=$!

    # Show spinner
    spinner $pid "$message"

    # Wait and get exit code
    if wait $pid; then
        print_status "$SYM_CHECK" "$GREEN" "$message complete"
        log "Success: vagrant $action"
        return 0
    else
        print_status "$SYM_FAIL" "$RED" "$message failed (see: tatin logs)"
        log "Failed: vagrant $action"
        return 1
    fi
}

# Get current VM status
get_status() {
    cd "$PROJECT_DIR"
    vagrant status --machine-readable 2>/dev/null | grep ",state," | cut -d',' -f4
}

# Commands
cmd_up() {
    print_status "$SYM_PENDING" "$BLUE" "Starting Tatin sandbox"
    log "Command: up"

    local status
    status=$(get_status)

    if [[ "$status" == "running" ]]; then
        print_status "$SYM_DONE" "$GREEN" "Tatin is already running"
        return 0
    fi

    run_vagrant up "Provisioning VM"

    echo ""
    print_status "$SYM_CHECK" "$GREEN" "Tatin sandbox ready"
    echo "  Connect with: tatin ssh"
}

cmd_down() {
    print_status "$SYM_PENDING" "$BLUE" "Stopping Tatin sandbox"
    log "Command: down"

    local status
    status=$(get_status)

    if [[ "$status" == "poweroff" ]] || [[ -z "$status" ]]; then
        print_status "$SYM_DONE" "$YELLOW" "Tatin is not running"
        return 0
    fi

    run_vagrant halt "Stopping VM"

    print_status "$SYM_CHECK" "$GREEN" "Tatin stopped"
}

cmd_delete() {
    print_status "$SYM_PENDING" "$RED" "Deleting Tatin sandbox"
    log "Command: delete"

    echo -n "Are you sure? [y/N] "
    read -r confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_status "$SYM_PENDING" "$YELLOW" "Cancelled"
        return 0
    fi

    run_vagrant destroy "Destroying VM" -f

    print_status "$SYM_CHECK" "$GREEN" "Tatin deleted"
}

cmd_status() {
    cd "$PROJECT_DIR"
    log "Command: status"

    local status
    status=$(get_status)

    case "$status" in
        running)
            print_status "$SYM_DONE" "$GREEN" "Tatin is running"
            ;;
        poweroff|saved)
            print_status "$SYM_PENDING" "$YELLOW" "Tatin is stopped"
            ;;
        not_created)
            print_status "$SYM_PENDING" "$BLUE" "Tatin is not created"
            ;;
        *)
            print_status "$SYM_PENDING" "$BLUE" "Tatin status: ${status:-unknown}"
            ;;
    esac
}

cmd_ssh() {
    cd "$PROJECT_DIR"
    log "Command: ssh"

    local status
    status=$(get_status)

    if [[ "$status" != "running" ]]; then
        print_status "$SYM_FAIL" "$RED" "Tatin is not running"
        echo "  Start with: tatin up"
        return 1
    fi

    exec vagrant ssh
}

cmd_logs() {
    if [[ -f "$LOG_FILE" ]]; then
        less +G "$LOG_FILE"
    else
        print_status "$SYM_PENDING" "$YELLOW" "No logs yet"
    fi
}

cmd_help() {
    cat << 'EOF'
tatin - Lifecycle management for Tatin LLM agent sandbox

Usage:
  tatin <command>

Commands:
  up       Start the VM and provision if needed
  down     Stop the VM (preserves state)
  delete   Destroy the VM completely
  status   Show current VM status
  ssh      Connect to the running VM
  logs     View provisioning logs
  help     Show this help message

Environment Variables (override VM resources):
  TATIN_CPUS     Number of CPUs (default: 4)
  TATIN_MEMORY   RAM in MB (default: 8192)
  TATIN_DISK     Disk size in GB (default: 20)

Examples:
  tatin up                       # Start the sandbox
  TATIN_CPUS=8 tatin up          # Start with 8 CPUs
  TATIN_MEMORY=16384 tatin up    # Start with 16GB RAM
  tatin ssh                      # Connect to it
  tatin down                     # Stop when done
EOF
}

# Main
main() {
    local cmd="${1:-help}"
    shift || true

    case "$cmd" in
        up)      cmd_up "$@" ;;
        down)    cmd_down "$@" ;;
        delete)  cmd_delete "$@" ;;
        status)  cmd_status "$@" ;;
        ssh)     cmd_ssh "$@" ;;
        logs)    cmd_logs "$@" ;;
        help|-h|--help) cmd_help ;;
        *)
            print_status "$SYM_FAIL" "$RED" "Unknown command: $cmd"
            echo ""
            cmd_help
            exit 1
            ;;
    esac
}

main "$@"
