vim.keymap.set("t", "<ESC><ESC>", "<C-\\><C-N>")

local function smallterm()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 15)
	return vim.bo.channel
end

vim.keymap.set("n", "<leader>jb", function()
	local job_id = smallterm()
	vim.fn.chansend(job_id, { "just build\r\n" })
end)
