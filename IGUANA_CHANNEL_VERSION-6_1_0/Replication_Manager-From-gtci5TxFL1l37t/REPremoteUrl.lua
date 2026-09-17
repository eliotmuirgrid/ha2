require "REPcredentials"
require "REPlocalUrl"

function REPremoteUrl()
      local Config = net.http.get{
      url=REPlocalUrl().."get_server_config",
      parameters=REPcredentials(),
      live=true
   }
   -- TODO error check if no remote servers.
   Config = xml.parse{data=Config}
   local Remote = Config.iguana_config.remote_iguana_list:child('remote_iguana', 1)

   local Protocol = Remote.https:S() == 'true' and 'https' or 'http'

   return Protocol .. '://' .. Remote.host:S() .. ':' .. Remote.port:S().."/"
end