require 'open-uri'

namespace :paperclip do
  desc 'Migrate space images from Paperclip to Active Storage'
  task migrate_to_active_storage: :environment do
    # Set up migration tracking
    total_count = SpaceImage.count
    success_count = 0
    error_count = 0
    skipped_count = 0
    
    puts "Starting migration of #{total_count} SpaceImage records from Paperclip to Active Storage"
    
    # Get the base path where Paperclip stores images
    # This path needs to be adjusted based on your actual Paperclip configuration
    paperclip_base_path = Rails.root.join('public', 'system', 'space_images', 'photos')
    
    # Process each SpaceImage
    SpaceImage.find_each.with_index do |space_image, index|
      begin
        puts "[#{index + 1}/#{total_count}] Processing SpaceImage ID: #{space_image.id}"
        
        # Skip if no Paperclip attachment or if ActiveStorage already has an image
        if space_image.photo_file_name.blank?
          puts "  - Skipping: No Paperclip attachment"
          skipped_count += 1
          next
        end
        
        if space_image.image.attached?
          puts "  - Skipping: ActiveStorage image already attached"
          skipped_count += 1
          next
        end
        
        # Build the path to the original Paperclip image
        paperclip_path = nil
        
        # Paperclip creates paths with ID partition (e.g., 000/000/001 for ID 1)
        id_partition = format('%09d', space_image.id).scan(/\d{3}/).join('/')
        
        # Try to find the original image file
        original_path = "#{paperclip_base_path}/original/#{id_partition}/#{space_image.photo_file_name}"
        if File.exist?(original_path)
          paperclip_path = original_path
        else
          puts "  - Error: Cannot find original file at #{original_path}"
          error_count += 1
          next
        end
        
        # Prepare to attach the file
        filename = space_image.photo_file_name
        content_type = space_image.photo_content_type
        
        # Create a new blob and attach it to the SpaceImage
        puts "  - Attaching #{filename} (#{content_type})"
        
        File.open(paperclip_path) do |file|
          space_image.image.attach(
            io: file,
            filename: filename,
            content_type: content_type
          )
        end
        
        puts "  - Success: Attached ActiveStorage image to SpaceImage ID: #{space_image.id}"
        success_count += 1
        
      rescue => e
        puts "  - Error migrating SpaceImage ID: #{space_image.id}: #{e.message}"
        puts e.backtrace.take(5).join("\n  ")
        error_count += 1
      end
    end
    
    # Print summary
    puts "\nMigration summary:"
    puts "  Total space images: #{total_count}"
    puts "  Successfully migrated: #{success_count}"
    puts "  Skipped: #{skipped_count}"
    puts "  Errors: #{error_count}"
    
    if error_count > 0
      puts "\nSome errors occurred during migration. Check the logs for details."
    else
      puts "\nMigration completed successfully."
    end
  end
  
  # Task to remove Paperclip columns after successful migration
  desc 'Remove Paperclip columns after successful migration to Active Storage'
  task remove_paperclip_columns: :environment do
    puts "This task will remove Paperclip columns from SpaceImage table."
    puts "Make sure you have already migrated all data to Active Storage."
    puts "Do you want to continue? (y/n)"
    
    confirmation = STDIN.gets.chomp.downcase
    
    if confirmation == 'y'
      puts "Creating migration to remove Paperclip columns..."
      
      migration_content = <<~RUBY
        class RemovePaperclipColumns < ActiveRecord::Migration[6.1]
          def up
            remove_column :space_images, :photo_file_name
            remove_column :space_images, :photo_content_type
            remove_column :space_images, :photo_file_size
            remove_column :space_images, :photo_updated_at
          end
          
          def down
            add_column :space_images, :photo_file_name, :string
            add_column :space_images, :photo_content_type, :string
            add_column :space_images, :photo_file_size, :integer
            add_column :space_images, :photo_updated_at, :datetime
          end
        end
      RUBY
      
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      migration_file = Rails.root.join('db', 'migrate', "#{timestamp}_remove_paperclip_columns.rb")
      
      File.write(migration_file, migration_content)
      puts "Migration file created at #{migration_file}"
      puts "Run 'rails db:migrate' to apply the migration."
    else
      puts "Operation cancelled."
    end
  end
end