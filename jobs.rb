require 'net/http'
require 'active_record'
require File.expand_path("config/environment", File.dirname(__FILE__))

def send_sms(target_number, message)
  sms_uri = URI.parse("http://www.sms.in.th/tunnel/sendsms.php")

  data = {
    "RefNo"=> "1", 
    "Sender"=> "crm service", 
    "Msn"=> target_number, 
    "Msg"=> message, 
    "MsgType"=>"T", 
    "User"=>"chanokwanan", 
    "Password"=>"505050"
  }
  res = Net::HTTP.post_form(sms_uri, data)
  if res.body == "0"
    return true
  else
    return false
  end
end

user = User.find(1)
while(true)
  sleep(10)
  tasks = Task.find(:all, :conditions=>["sms_sent = ?", 0])
  puts "acquiring tasks, found #{tasks.length}}"
  tasks.each do |task|
      tdif = task.due_at - Time.now 
      if tdif <= 600
        if tdif < 0
          task.sms_sent = 1
          task.save
        else
          puts "near! :::::::::::::: 10 more minutes"
          puts "going to send SMS :::::::::::::::::::"
          if send_sms(user.mobile,"Task #{task.name} is going to begin at #{task.due_at.localtime.strftime("%r")}")
            puts "SMS SENT !!!!!!!!!!!!!!!!!!!!!!!!!!"
            task.sms_sent = 1
            task.save
          else
            puts "FAILED TO SENT SMS, trying again soon ::::::"
          end
        end

      else
        puts "tick tock"
      end
  end
end
