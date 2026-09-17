function REPremoveExtraChannels(ChannelStatus, CurrentStatus, ProtectedChannels)
   local Protected = {}
   for i = 1, #ProtectedChannels do
      Protected[ProtectedChannels[i]] = true
   end

   local Required = {}
   for i = 1, ChannelStatus.IguanaStatus:childCount("Channel") do
      local Channel = ChannelStatus.IguanaStatus:child("Channel", i)
      Required[Channel.Name:S()] = true
   end

   for i = 1, CurrentStatus.IguanaStatus:childCount("Channel") do
      local Channel = CurrentStatus.IguanaStatus:child("Channel", i)
      local Name = Channel.Name:S()

      if not Required[Name] and not Protected[Name] then
         REPremoveLocalChannel(Name)
      end
   end
end

function REPremoveLocalChannel(Name)
   iguana.logInfo("Removing extra channel: " .. Name)

   net.http.post{
      url=REPlocalUrl().."/remove_channel",
      auth=REPcredentials(),
      parameters={
         name=Name
      },
      live=false
   }
end