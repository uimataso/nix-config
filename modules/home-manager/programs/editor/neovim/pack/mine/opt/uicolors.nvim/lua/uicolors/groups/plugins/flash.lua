local M = {}

M.url = 'https://github.com/folke/flash.nvim'

M.get = function(c)
  return {
    FlashMatch = 'Normal',
    FlashCurrent = 'Normal',
    -- FlashBackdrop 	Comment 	backdrop
    -- FlashMatch 	Search 	search matches
    -- FlashCurrent 	IncSearch 	current match
    -- FlashLabel 	Substitute 	jump label
    -- FlashPrompt 	MsgArea 	prompt
    -- FlashPromptIcon 	Special 	prompt icon
    -- FlashCursor 	Cursor 	cursor
  }
end

return M
