require 'open-uri'

namespace :paperclip do
  desc 'Migrate user avatars from Paperclip to Active Storage'
  task migrate_avatars_to_active_storage: :environment do
    # Set up migration tracking
    total_count = User.count
    success_count = 0
    error_count = 0
    skipped_count = 0
    
    puts "Starting migration of #{total_count} User avatar records from Paperclip to Active Storage"
    
    # Get the base path where Paperclip stores images
    # This path needs to be adjusted based on your actual Paperclip configuration
    paperclip_base_path = Rails.root.join('public', 'system', 'users', 'avatars')
    
    # Process each User
    User.find_each.with_index do |user, index|
      begin
        puts "[#{index + 1}/#{total_count}] Processing User ID: #{user.id}"
        
        # Skip if no Paperclip attachment or if ActiveStorage already has an image
        if user.avatar_file_name.blank?
          puts "  - Skipping: No Paperclip attachment"
          skipped_count += 1
          next
        end
        
        if user.avatar.attached?
          puts "  - Skipping: ActiveStorage avatar already attached"
          skipped_count += 1
          next
        end
        
        # Build the path to the original Paperclip image
        paperclip_path = nil
        
        # Paperclip creates paths with ID partition (e.g., 000/000/001 for ID 1)
        id_partition = format('%09d', user.id).scan(/\d{3}/).join('/')
        
        # Try to find the original image file
        original_path = "#{paperclip_base_path}/#{id_partition}/original/#{user.avatar_file_name}"
        if File.exist?(original_path)
          paperclip_path = original_path
        else
          puts "  - Error: Cannot find original file at #{original_path}"
          error_count += 1
          next
        end
        
        # Prepare to attach the file
        filename = user.avatar_file_name
        content_type = user.avatar_content_type
        
        # Create a new blob and attach it to the User
        puts "  - Attaching #{filename} (#{content_type})"
        
        File.open(paperclip_path) do |file|
          user.avatar.attach(
            io: file,
            filename: filename,
            content_type: content_type
          )
        end
        
        puts "  - Success: Attached ActiveStorage avatar to User ID: #{user.id}"
        success_count += 1
        
      rescue => e
        puts "  - Error migrating User ID: #{user.id}: #{e.message}"
        puts e.backtrace.take(5).join("\n  ")
        error_count += 1
      end
    end
    
    # Print summary
    puts "\nMigration summary:"
    puts "  Total users: #{total_count}"
    puts "  Successfully migrated: #{success_count}"
    puts "  Skipped: #{skipped_count}"
    puts "  Errors: #{error_count}"
    
    if error_count > 0
      puts "\nSome errors occurred during migration. Check the logs for details."
    else
      puts "\nMigration completed successfully."
    end
  end
end