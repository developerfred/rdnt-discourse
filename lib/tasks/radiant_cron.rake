require 'httparty'
require 'json'

desc 'Radiant Cron Task: terminates user sessions every 10 minutes'
task radiant_cron: :environment do
  # get all users
  # add every day add locked_timestamp field
  daily_users = HTTParty.get('https://community.radiant.capital/directory_items.json?period=daily')
  puts daily_users.body, daily_users.code

  # check if user is has locked field and create field
  def check_locked_field(daily_users)
      if daily_users.code == 200
      daily_users = JSON.parse(daily_users.body)
      daily_users.each do |user|
          if user.lock_timestamp.nil
              LockedObject = UserCustomField.create(user_id: user.id, name: 'locked_timestamp', value: 0)
              LockedObject.save
          else
          puts "User #{user.username} has locked_timestamp field"
          end
          puts "we just added the locked_timestamp field to User #{user.username} "
      end
  end

  # call the function check_locked_field
  check_locked_field(daily_users)

  no_proposers = []
  group_select = Group.find_by(name: "proposer")
  proposers = group_select.users
  propenser.each do |user|
    if user.lock_timestamp + 1800 > Time.now
      no_proposers << user
    end
  end

  no_proposers_json = no_proposers.to_json

  # remove list of users
  # change "X-Auth-Key" => "7456785476856789567965"
  response = HTTParty.delete("https://community.radiant.capital/groups/1",
              :headers => { "X-Auth-Key" => "7456785476856789567965","Content-Type" => "application/json" } ,
              :body => {:"usernames" => no_proposers.to_json}.to_json
              )
  puts response.body, response.message
end
