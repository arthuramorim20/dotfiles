require("carrot.core")
require("carrot.lazy")

-- Notify when entering/leaving macro recording so the active register is visible.
local function notify_recording(action)
    return function()
        local register = vim.fn.reg_recording()
        vim.notify(action .. " no registrador " .. register, vim.log.levels.INFO)
    end
end

vim.api.nvim_create_autocmd("RecordingEnter", { callback = notify_recording("Gravação iniciada") })
vim.api.nvim_create_autocmd("RecordingLeave", { callback = notify_recording("Gravação concluída") })
