namespace :css do
  desc "Migrate SCSS to CSS for Propshaft"
  task :migrate => :environment do
    puts "Migrating SCSS to CSS for Propshaft..."
    system "/workspace/bin/compile-scss"
    
    puts "Fixing asset paths..."
    system "/workspace/bin/fix-asset-paths"
    
    puts "Cleaning up..."
    FileUtils.rm_rf(Rails.root.join("tmp/scss_build")) if Dir.exist?(Rails.root.join("tmp/scss_build"))
    
    puts "✅ Migration complete! CSS files are in app/assets/builds/"
    puts "Remember to precompile assets with 'bin/rails assets:precompile' before deploying"
  end
end