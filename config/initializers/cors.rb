# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:5173' # Replace with your frontend's origin

    resource '/graphql', # or '*' to allow all paths
      headers: :any,
      methods: [:get, :post, :options], # Add other HTTP methods if needed
      credentials: true # Allows cookies and Authorization headers
  end

end
