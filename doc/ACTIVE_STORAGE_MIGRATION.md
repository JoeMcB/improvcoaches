# Migrating Space Images from Paperclip to Active Storage

This document outlines the process for migrating space images from Paperclip to Active Storage.

## Overview

The migration process consists of the following steps:

1. Update the models to support both Paperclip and Active Storage during the transition
2. Run a migration script to transfer existing images from Paperclip to Active Storage
3. Remove Paperclip columns after successful migration

## Prerequisites

- Active Storage must be installed and configured
- The application must be using Rails 6.1 or newer
- Enough disk space to temporarily hold both Paperclip and Active Storage images

## Migration Steps

### 1. Install and Configure Active Storage

Make sure you have the Active Storage migration applied:

```bash
docker-compose run web rails db:migrate
```

### 2. Update Configuration for Development

For development, you can use the local disk service. In `config/environments/development.rb`, ensure that Active Storage is configured:

```ruby
# Store files locally.
config.active_storage.service = :local
```

### 3. Run the Migration Script

The migration script will transfer all Paperclip images to Active Storage:

```bash
docker-compose run web rails paperclip:migrate_to_active_storage
```

The script will:
- Process each SpaceImage with a Paperclip attachment
- Find the original file in the Paperclip storage location
- Create a new Active Storage attachment with the same content
- Track progress and report success/failure

### 4. Verify the Migration

After running the migration, verify that all images were successfully migrated:

1. Check the Rails console to confirm image attachments:

```bash
docker-compose run web rails c
```

```ruby
# Count all space images that should have attachments
total = SpaceImage.count

# Count images with Active Storage attachments
with_active_storage = SpaceImage.joins("INNER JOIN active_storage_attachments ON active_storage_attachments.record_id = space_images.id AND active_storage_attachments.record_type = 'SpaceImage'").count

# Compare
puts "Total: #{total}, With Active Storage: #{with_active_storage}"
```

2. Visually verify that images display correctly in the application

### 5. Update Views

Update your views to use Active Storage instead of Paperclip. Example:

Before:
```erb
<%= image_tag space_image.photo.url(:thumb) %>
```

After:
```erb
<%= image_tag space_image.image.variant(resize_to_fill: [75, 50]) %>
```

### 6. Remove Paperclip Columns

After confirming that the migration was successful and the application works with Active Storage, you can remove the Paperclip columns:

```bash
docker-compose run web rails paperclip:remove_paperclip_columns
```

When prompted, type `y` to confirm and create the migration. Then run:

```bash
docker-compose run web rails db:migrate
```

### 7. Remove Paperclip Dependencies

Once the migration is complete and the columns are removed, you can:

1. Remove the Paperclip gem from your Gemfile
2. Remove Paperclip configuration from the SpaceImage model

## Troubleshooting

- If images are not found during migration, check the Paperclip base path in the migration script
- If Active Storage serving is not working, check the Active Storage configuration in your environment files
- For production, ensure that your storage service is properly configured

## Additional Resources

- [Active Storage Documentation](https://edgeguides.rubyonrails.org/active_storage_overview.html)
- [Paperclip to Active Storage Migration Guide](https://github.com/thoughtbot/paperclip/blob/master/MIGRATING.md)