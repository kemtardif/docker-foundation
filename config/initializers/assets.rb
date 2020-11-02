# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
# Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/
Rails.application.config.assets.paths += Dir["#{Rails.root}/vendor/**/"].sort_by { |dir| -dir.size }

# Rails.application.config.assets.paths += Dir["#{Rails.root}/asset/images/**/"].sort_by { |dir| -dir.size }
# Rails.application.config.assets.paths += Dir["#{Rails.root}/vendor/js/*"].sort_by { |dir| -dir.size }
# Rails.application.config.assets.paths += Dir["#{Rails.root}/vendor/plugins/*"].sort_by { |dir| -dir.size }
# Rails.application.config.assets.paths += Dir["#{Rails.root}/vendor/plugins/bootstrap/*"].sort_by { |dir| -dir.size }
# Rails.application.config.assets.paths += Dir["#{Rails.root}/vendor/plugins/slider.revolution/*"].sort_by { |dir| -dir.size }


# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( revicons.ttf revicons.woff )
