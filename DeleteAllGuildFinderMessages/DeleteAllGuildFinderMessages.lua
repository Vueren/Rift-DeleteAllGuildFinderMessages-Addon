local function split(str)
    local t = {}
    for s in string.gmatch(str, "%S+") do
        t[#t+1] = s
    end
    return t
end

local function slashHandler(eventHandle, params)
    local isMailOpen = Inspect.Interaction('mail')
    if not isMailOpen then
        print("Please open your mail interface before using /gfdelete.")
        return
    end

    params = params and params:lower() or ""
    local args = split(params)

    local mailList = Inspect.Mail.List()
    for mail,_ in pairs(mailList) do
        local inspectedMail = Inspect.Mail.Detail(mail)
        if inspectedMail.subject == 'Guild Finder message' or inspectedMail.subject == 'Message de la recherche de guilde' or inspectedMail.subject == 'Gildensucher-Nachricht' then
            if args[1] == 'force' or inspectedMail.read then
                print("Deleting mail from " .. inspectedMail.from .. " | Subject: " .. inspectedMail.subject)
                Command.Mail.Delete(mail)
            end
        end
    end
end

Command.Event.Attach(Command.Slash.Register('gfdelete'), slashHandler, 'DeleteAllGuildFinderMails')
