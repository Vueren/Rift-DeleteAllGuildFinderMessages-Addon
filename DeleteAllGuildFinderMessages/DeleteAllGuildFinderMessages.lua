-- Following from Imhothar's string split 'cause I'm too lazy to implement myself
local strfind = string.find
local strsub = string.sub

--- Split a string into substrings according to a provided separator.
-- @param sep The separator string.
-- @param patterned If this parameter evaluates to true the separation is performed on search patterns, otherwise plain strings.
-- @return A table with all strings as values in the order they were found.
-- @usage string.split("/a:b/c:d/:", ":")
-- returns { "/a", "b/c", "d/", "" }
-- @usage string.split("/a:b/c:d/:", "[:/]", true)
-- returns { "", "a", "b", "c", "d", "", "" }
-- @usage string.split("/a:b/c:d/:", "[:/]")
-- returns { "/a:b/c:d/:" }
function string:split(sep, patterned)
	local list = {}
	local pos = 1
	if(strfind("", sep, 1)) then -- this would result in endless loops
		error("delimiter matches empty string!", 2)
	end
	while 1 do
		local first, last = strfind(self, sep, pos, not patterned)
		if(first) then -- found?
			list[#list + 1] = strsub(self, pos, first - 1)
			pos = last + 1
		else
			list[#list + 1] = strsub(self, pos)
			break
		end
	end
	return list
end


local function slashHandler(eventHandle, params)
    local isMailOpen = Inspect.Interaction('mail')
    if not isMailOpen then
        print("Please open your mail interface before using /gfdelete.")
        return
    end

    local sanitizedArgs = string.split(string.lower(string.gsub(params, '%s+', '')), '%s+', true)

    local mailList = Inspect.Mail.List()
    for mail,_ in pairs(mailList) do
        local inspectedMail = Inspect.Mail.Detail(mail)
        if inspectedMail.subject == 'Guild Finder message' or inspectedMail.subject == 'Message de la recherche de guilde' or inspectedMail.subject == 'Gildensucher-Nachricht' then
            if sanitizedArgs[1] == 'force' or inspectedMail.read then
                print("Deleting mail from " .. inspectedMail.from .. " | Subject: " .. inspectedMail.subject)
                Command.Mail.Delete(mail)
            end
        end
    end
end

Command.Event.Attach(Command.Slash.Register('gfdelete'), slashHandler, 'DeleteAllGuildFinderMails')
