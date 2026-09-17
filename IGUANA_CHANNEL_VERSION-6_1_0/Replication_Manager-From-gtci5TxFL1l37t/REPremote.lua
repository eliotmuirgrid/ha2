require "REPcredentials"

function REPremote()
      local Config = net.http.get{
      url='http://localhost:6543/get_server_config',
      parameters=REPcredentials(),
      live=true
   }

   Config = xml.parse{data=Config}
   return Config.iguana_config.remote_iguana_list:child('remote_iguana', 1)
end