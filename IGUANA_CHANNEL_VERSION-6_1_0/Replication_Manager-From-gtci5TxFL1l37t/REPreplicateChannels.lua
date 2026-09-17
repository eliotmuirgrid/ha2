function REPreplicateChannels(ChannelStatus, ProtectedChannels)
   local Protected = {}

   for i = 1, #ProtectedChannels do
      Protected[ProtectedChannels[i]] = true
   end

   for i = 1, ChannelStatus.IguanaStatus:childCount("Channel") do
      local Channel = ChannelStatus.IguanaStatus:child("Channel", i)
      local Name = Channel.Name:S()

      if not Protected[Name] then
         if REPhasChannelChanged(Name) then
            iguana.logInfo("Replicating changed channel: " .. Name)
            REPreplicateChannel(Name)
         else
            iguana.logInfo("Channel unchanged: " .. Name)
         end
      end
   end
   
end

function REPreplicateChannel(Name)
   local Config = net.http.post{
      url=REPremoteUrl().."/get_channel_config",
      auth=REPcredentials(),
      parameters={
         name=Name,
         compact="true"
      },
      live=true
   }

   iguana.logInfo("Replicating channel: " .. Name)

   return net.http.post{
      url=REPlocalUrl().."/update_channel",
      auth=REPcredentials(),
      parameters={
         config=Config,
         compact="true"
      },
      live=true
   }
end

function REPhasChannelChanged(Name)
   local Credentials = REPcredentials()

   local RemoteConfig = net.http.post{
      url=REPremoteUrl().."/get_channel_config",
      auth=Credentials,
      parameters={
         name=Name,
         compact="true"
      },
      live=true
   }

   local LocalConfig = net.http.post{
      url=REPlocalUrl().."/get_channel_config",
      auth=Credentials,
      parameters={
         name=Name,
         compact="true"
      },
      live=true
   }
   RemoteConfig = REPremoveFalsePositives(RemoteConfig)
   LocalConfig = REPremoveFalsePositives(LocalConfig)
   
   trace(RemoteConfig)
   trace(LocalConfig)

   return RemoteConfig ~= LocalConfig
end

function REPremoveFalsePositives(ChannelXml)
   ChannelXml = ChannelXml:gsub(" commit_id=[\"'][^\"']*[\"']", "")
   ChannelXml = ChannelXml:gsub(" commit_comment=[\"'][^\"']*[\"']", "")
   ChannelXml = ChannelXml:gsub(" translator_commit_id=[\"'][^\"']*[\"']", "")
   ChannelXml = ChannelXml:gsub(" translator_commit_comment=[\"'][^\"']*[\"']", "")

   -- Remove GUIDs.
   ChannelXml = ChannelXml:gsub(" guid=[\"'][^\"']*[\"']", "")
   ChannelXml = ChannelXml:gsub(" dequeue_guid=[\"'][^\"']*[\"']", "")

   -- Normalize line endings.
   ChannelXml = ChannelXml:gsub("\r\n", "\n")
   ChannelXml = ChannelXml:gsub("\r", "\n")

   -- Remove whitespace between XML elements.
   ChannelXml = ChannelXml:gsub(">%s+<", "><")

   -- Remove leading/trailing whitespace.
   ChannelXml = ChannelXml:match("^%s*(.-)%s*$")

   return ChannelXml
end