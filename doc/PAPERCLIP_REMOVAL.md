# Paperclip Removal and Active Storage Migration

This document outlines the changes made to migrate from Paperclip to Active Storage.

## Overview

The migration process consisted of the following steps:

1. Added Active Storage attachments to models while maintaining Paperclip compatibility
2. Created migration scripts to transfer existing images from Paperclip to Active Storage
3. Updated models to use Active Storage exclusively, removing Paperclip dependencies
4. Created migrations to remove Paperclip columns from database tables
5. Updated controllers and views to use Active Storage
6. Removed the Paperclip gem from the Gemfile

## Models Modified

### SpaceImage Model
- Replaced `has_attached_file :photo` with `has_one_attached :image`
- Added variant helper methods for different image sizes (thumb, small, medium, large, xlarge)
- Added Active Storage validations for content type and file size

### User Model
- Replaced `has_attached_file :avatar` with `has_one_attached :avatar`
- Added variant helper methods for different avatar sizes
- Added Active Storage validations for content type and file size

## Controllers Modified

### SpacesController
- Updated the `add_image` method to use Active Storage instead of Paperclip
- Implemented proper image deletion for Active Storage attachments

### UsersController
- Updated the `update` method to handle Active Storage avatar uploads
- Updated the allowed attributes list to include the new avatar field

## Views Modified

- Updated all views that referenced Paperclip attachments to use Active Storage variants
- Added a carousel for displaying space images in the space show view
- Updated image upload forms to work with Active Storage

## Migration Scripts

Created two migration scripts to handle the transition:

1. `migrate_paperclip_to_active_storage.rake` - Migrates space images from Paperclip to Active Storage
2. `migrate_avatars_to_active_storage.rake` - Migrates user avatars from Paperclip to Active Storage

## Database Migrations

Created two migrations to remove Paperclip columns:

1. `RemovePaperclipColumns` - Removes Paperclip columns from the space_images table
2. `RemovePaperclipColumnsFromUsers` - Removes Paperclip columns from the users table

## Deployment Steps

1. Install and configure Active Storage
   ```bash
   docker-compose run web rails db:migrate
   ```

2. Run the migration scripts to transfer existing images
   ```bash
   docker-compose run web rails paperclip:migrate_to_active_storage
   docker-compose run web rails paperclip:migrate_avatars_to_active_storage
   ```

3. Apply the migrations to remove Paperclip columns
   ```bash
   docker-compose run web rails db:migrate
   ```

4. Update the Gemfile and install dependencies
   ```bash
   docker-compose run web bundle install
   ```

5. Restart the application
   ```bash
   docker-compose restart web
   ```

## Troubleshooting

If images don't appear correctly after the migration:

1. Check that the migration scripts ran successfully
2. Verify that images were properly transferred to Active Storage
3. Check for errors in the application logs
4. Make sure the proper image variant methods are being called in views

## Benefits of the Migration

1. Active Storage is the official Rails solution for file uploads
2. Better integration with modern Rails features
3. More consistent API and cleaner codebase
4. Removal of deprecated Paperclip gem
5. Support for cloud storage services
6. On-the-fly image transformations with variants