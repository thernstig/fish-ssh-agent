# Fish shell SSH agent

Utility functions to start your SSH agent when using the fish shell.

Do you ever login to the same host multiple times? If you are using `ssh-agent`
and `ssh-add` to add your keys (which you should), you need to call these commands
every time you login.

This fisher plugin solves this by exporting the `SSH_AUTH_SOCK` and `SSH_AGENT_PID`
started by the first agent, so subsequent logins can use the same ssh agent and thus
your already added ssh keys.

You will only need to run `ssh-add` and type your password once.
After that the running ssh agent should do the work for you.

## Installation

### Using [Fisher](https://github.com/jorgebucaran/fisher)

```sh
fisher install thernstig/fish-ssh-agent
```

### Manually

Copy `functions` and `conf.d` to your `$__fish_config_dir` directory. That's all.

## Credits

Credits go to <https://github.com/danhper/fish-ssh-agent/> for the original implementation.
