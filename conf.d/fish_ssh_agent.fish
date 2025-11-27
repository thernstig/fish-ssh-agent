if test -z "$SSH_ENV_FILE"
    set -xg SSH_ENV_FILE "$HOME/.ssh/ssh_agent_env.fish"
end

if not _ssh_agent_is_started
    _ssh_agent_start
end
