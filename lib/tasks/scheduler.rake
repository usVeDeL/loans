task :send_reminders => :environment do
  InterestsWeeklyJob.perform_now
end