
#########################
LOG_LEVEL  = "3" 
# LEVEL_ERROR = 1
# LEVEL_WARRN = 2
# LEVEL_INFO  = 3
# LEVEL_TRACE = 4
# Chef::Log.info(e.inspect)
# Chef::Log.warn(e.inspect)
# Chef::Log.error(e.inspect)
#########################
def logMsgTrace(message)
  if ( "4" <= LOG_LEVEL ) then
    # p "TRACE: #{message}"
    print "TRACE: #{message}\n"
  end
end

def logMsgInfo(message)
  if ( "3" <= LOG_LEVEL ) then
    # p "INFO: #{message}"   
    print "INFO: #{message}\n"
  end
end

def logMsgWarn(message)
  if ( "2" <= LOG_LEVEL ) then
    # p "WARNING: #{message}"   
    print "WARNING: #{message}\n"
  end
end

def logMsgErr(message)
  if ( "1" <= LOG_LEVEL ) then
    # p "ERROR: #{message}"   
    print "ERROR: #{message}\n"
  end
end

