require "REPremoteUrl"
require "REPchannelStatus"
require "REPcreatePlaceHolderChannels"
require "REPremoveExtraChannels"
require "REPreplicateChannels"

local ProtectedChannels = {
      "Replication Manager",
      "Sync Manager",
      "Poller Manager"
}

function main()   local RS = REPchannelStatus(REPremoteUrl(), REPcredentials())
   local S  = REPchannelStatus(REPlocalUrl(), REPcredentials())
   iguana.setChannelStatus{color='green', text='Create Placeholder Channels.'}   
   REPcreatePlaceHolderChannels(RS, S)
   iguana.setChannelStatus{color='green', text='Remove Extra Channels.'}
   REPremoveExtraChannels(RS, S, ProtectedChannels)
   iguana.setChannelStatus{color='green', text='Replicate Channels.'}
   REPreplicateChannels(S, ProtectedChannels)
   iguana.setChannelStatus{color='green', text='Replication complete.'}
end