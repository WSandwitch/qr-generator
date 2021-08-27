# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

Mime::Type.register "image/jpg", :jpg
Mime::Type.register "image/svg+xml", :svg