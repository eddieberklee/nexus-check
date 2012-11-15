require 'rubygems'
require 'mechanize'
require 'logger'
require 'twilio-ruby'

agent = Mechanize.new
# Needed for SSL
agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
agent.log = Logger.new "mech.log"
agent.user_agent_alias = 'Mac Safari'

url = 'https://play.google.com/store/devices/details?id=nexus_4_16gb'

# Just a file containing account sid on the first line
#   and auth token on the second.
f = File.new("twilio-login.password","r")
account_sid,auth_token = f.read.split("\n")

@client = Twilio::REST::Client.new account_sid, auth_token

while 1
    t = Time.new
    page = agent.get url
    html = page.body
    t = t.strftime("%b %e, %l:%M%P")
    if html.match('Sold out')
        puts "Sold Out Still - #{t}"
    else
        @client.account.sms.messages.create(
            :from => '',
            :to => '',
            :body => 'Nexus 4 16GB is back in stock! GOGOGO',
        )
    end
    sleep(60)
end



