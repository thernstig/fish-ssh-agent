if test -z "$SSH_ENV_FILE"
    set -xg SSH_ENV_FILE "$HOME/.ssh/ssh_agent_env.fish"
end

if not _ssh_agent_is_started
    if _ssh_agent_start
        # Print the message after the prompt to avoid it appearing before the
        # default fish shell greeting
        function _fish_ssh_agent_print_message --on-event fish_prompt
            echo "Started new SSH agent. Run 'ssh-add' to add keys."
            functions --erase _fish_ssh_agent_print_message
        end
    end
end
