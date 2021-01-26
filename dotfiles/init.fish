set PATH  /usr/local/bin $PATH

if begin
	set -q SSH_AGENT_PID
	and kill -0 $SSH_AGENT_PID
end
	echo "ssh-agent running on pid $SSH_AGENT_PID"
else
	eval (command ssh-agent -c | sed 's/^setenv/set -Ux/')
    ssh-add ~/.ssh/id_git
end


