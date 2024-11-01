function _ssh_agent_is_started --description "Check if ssh agent is already started"
    if test -n "$SSH_CONNECTION"
        # This is an SSH session
        set -l output (ssh-add -l 2>&1)
        if test $status -eq 0
            # An SSH agent was forwarded
            return 0
        else if test $status -eq 1
            if test "$output" = "The agent has no identities."
                # An SSH agent was forwarded but has no identities
                return 0
            end
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
            rm "$SSH_ENV"
        end
        return 1
    end

    # Verify that the ssh-agent can be contacted.
    ssh-add -l >/dev/null 2>&1
    if test "$status" -eq 2
        if test -f "$SSH_ENV"
            rm "$SSH_ENV"
        end
        return 1
    end
end
