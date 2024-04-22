namespace :migrate do
  desc "Migrate Paperclip avatars to Active Storage"
  task avatars: :environment do
    User.find_each(batch_size: 100) do |user|
      next unless user.avatar.exists?  # Check if the Paperclip attachment exists

      # Open the file and create an Active Storage attachment
      file = File.open(user.avatar.path(:large))
      user.avatar_new.attach(
        io: file,
        filename: user.avatar_file_name,
        content_type: user.avatar_content_type
      )

      # Optional: Output progress to the console
      if user.avatar_new.attached?
        puts "Migrated avatar for user ##{user.id}"
      else
        puts "Failed to migrate avatar for user ##{user.id}"
      end
    end
  end
end
