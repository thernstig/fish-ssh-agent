if test -z "$SSH_ENV"
    set -xg SSH_ENV "$HOME/.ssh/ssh_agent_env.fish"
end

if not _ssh_agent_is_started
    _ssh_agent_start
end
