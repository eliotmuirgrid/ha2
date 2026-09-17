function REPlocalUrl()
   local Info = iguana.webInfo()

   local Protocol = Info.web_config.use_https and 'https' or 'http'

   return Protocol .. '://localhost:' .. Info.web_config.port.."/"
end
