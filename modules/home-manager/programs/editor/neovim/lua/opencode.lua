local M = {}

M.submit_prompt = function(url)
    vim.fn.system(string.format('curl -X POST %s/tui/submit-prompt', url))
end

M.append_prompt = function(url, text)
    local json_body = vim.json.encode({ text = text })
    vim
        .system({
            'curl',
            '-X',
            'POST',
            url .. '/tui/append-prompt',
            '-H',
            'Content-Type: application/json',
            '-d',
            json_body,
        })
        :wait()
end

M.find_port_in_tmux = function()
    local ppid_cmd = "tmux list-panes -s -F '#{pane_pid} #{pane_current_command}'"
        .. ' | grep opencode'
        .. " | cut -d' ' -f1"
    local ppid = vim.trim(vim.fn.system(ppid_cmd))
    if ppid == '' then
        return nil
    end

    local pid_cmd = 'pstree -s opencode %s'
        .. ' | grep opencode'
        .. " | sed -n 's/^.*=\\s*\\([[:digit:]]\\+\\).*$/\\1/p'"
    local pid = vim.trim(vim.fn.system(string.format(pid_cmd, ppid)))
    if pid == '' then
        return nil
    end

    local lsof_cmd = 'lsof -Pan -p %s -iTCP -sTCP:LISTEN 2>/dev/null'
        .. " | sed -n 's/^.*127.0.0.1:\\([[:digit:]]\\+\\).*$/\\1/p'"
    local port = vim.trim(vim.fn.system(string.format(lsof_cmd, pid)))
    if port == '' then
        return nil
    end

    return port
end

M.url_in_tmux = function()
    return 'localhost:' .. M.find_port_in_tmux()
end

return M
