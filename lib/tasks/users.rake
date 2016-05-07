namespace :users do
  desc "Adds invites to coaches account under a maxiumum"
  task :add_invites => :environment do
  	# Add one per week so we're not keeping everyone at max all the time.
  	if Time.zone.now.wday == 0
  		max_invites = ENV['MAX_INVITES'].try(:to_i) || 3
  		User.coaches.find_each do |coach|
  			coach.add_invite if coach.invites.free.count < max_invites
  		end
  	end
  end

end
