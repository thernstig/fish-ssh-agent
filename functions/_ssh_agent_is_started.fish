function _ssh_agent_is_started --description "Check if ssh agent is already started"

    # Check if it is an SSH session. The SSH_CONNECTION environment variable is automatically
    # set by the remote SSH server (sshd) when you log in to a remote machine via SSH.
    # We check for exit codes 0 (keys present) and 1 (no keys) from ssh-add.
    # Both indicate a valid agent is reachable (usually via forwarding, but could be a pre-existing local agent).
    # (If no agent were reachable, ssh-add would return 2).
    if test -n "$SSH_CONNECTION"
        set -l output (ssh-add -l 2>&1)
        if test $status -eq 0
            # Success - Agent running, keys present.
            return 0
        else if test $status -eq 1
            # Command failed - Agent running, but no keys present.
            return 0
        end
    end

    # If an SSH agent is already started, we do nothing. This is the case when opening a subshell
    # or a new tab in a terminal emulator that inherits the environment from the parent shell.
    if test "$SSH_AGENT_PID"; and test "$SSH_AUTH_SOCK"
        return 0
    end

    # If the SSH environment file exists, source it. This will set SSH_AUTH_SOCK and SSH_AGENT_PID.
    if test -f "$SSH_ENV"
        source "$SSH_ENV"
    end

    # If SSH_AGENT_PID is still not set, something went wrong.
    # Remove the SSH environment file and indicate the agent is not started.
    if test -z "$SSH_AGENT_PID"
        if test -f "$SSH_ENV"
            rm -f "$SSH_ENV"
        end
        return 1
    end

    # Verify that the ssh-agent can be contacted.
    ssh-add -l >/dev/null 2>&1
    if test "$status" -eq 2
        if test -f "$SSH_ENV"
            rm -f "$SSH_ENV"
        end
        return 1
    end
end
