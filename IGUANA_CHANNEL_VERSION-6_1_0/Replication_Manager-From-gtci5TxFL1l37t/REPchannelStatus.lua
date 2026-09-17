function REPchannelStatus(Url, Credentials)
   local Status = net.http.post{
      url=Url.."/status",
      auth=Credentials,
      live=true
   }

   return xml.parse{data=Status}
end