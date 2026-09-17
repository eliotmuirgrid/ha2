function REPcreatePlaceHolderChannels(ChannelStatus, CurrentStatus)
   local Existing = {}

   for i = 1, CurrentStatus.IguanaStatus:childCount("Channel") do
      local Channel = CurrentStatus.IguanaStatus:child("Channel", i)
      Existing[Channel.Name:S()] = true
   end

   for i = 1, ChannelStatus.IguanaStatus:childCount("Channel") do
      local Channel = ChannelStatus.IguanaStatus:child("Channel", i)
      local Name = Channel.Name:S()

      if not Existing[Name] then
         iguana.logInfo("Creating channel: " .. Name)

         local Config = net.http.post{
            url=REPremoteUrl().."/get_channel_config",
            auth=REPcredentials(),
            parameters={
               name=Name,
               compact="true"
            },
            live=true
         }

         net.http.post{
            url=REPlocalUrl().."/add_channel",
            auth=REPcredentials(),
            parameters={
               config=Config,
               compact="true"
            },
            live=true
         }
      end
   end
end