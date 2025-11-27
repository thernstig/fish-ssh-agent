function _ssh_agent_is_started --description "Check if ssh agent is already started"
    # Check if the agent is already running and reachable.
    # This covers:
    # 1. Remote SSH sessions (checking for forwarded agent).
    # 2. Local sessions where an agent is already running (e.g. inherited from parent).
    # We check for exit codes 0 (keys present) and 1 (no keys) from ssh-add.
    # Both indicate a valid agent is reachable.
    # (If no agent were reachable, ssh-add would return 2).
    ssh-add -l >/dev/null 2>&1
    if contains $status 0 1
        return 0
    end

    # If the SSH environment file exists, source it. This will set SSH_AUTH_SOCK and SSH_AGENT_PID.
    if test -f "$SSH_ENV_FILE"
        source "$SSH_ENV_FILE"

        # If SSH_AGENT_PID is still not set, something went wrong.
        # Remove the SSH environment file and indicate the agent is not started.
        if test -z "$SSH_AGENT_PID"
            rm -f "$SSH_ENV_FILE"
            return 1
        end

        # Verify that the ssh-agent can be contacted.
        ssh-add -l >/dev/null 2>&1
        if contains $status 0 1
            return 0
        end

        rm -f "$SSH_ENV_FILE"
        return 1
    end

    return 1
end
