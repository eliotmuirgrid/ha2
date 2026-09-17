function REPcredentials()
   local Username = os.getenv('REPLICATION_USERNAME')
   local Password = os.getenv('REPLICATION_PASSWORD')

   return {username=Username, password=Password}
end