# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MatthewRDale::Application.initialize!

IMAGE_MAGICK_PATH = "/usr/bin"
AADG_AUTHENTICATE = :authenticate_user!
