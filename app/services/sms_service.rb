class SmsService
  require "uri"
  require "net/http"

  def perform
    url = URI.parse("https://textbelt.com/text")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true # Use HTTPS

    # Prepare the request data
    data = {
      number: "01003344146",
      message: "I sent this message for free with Textbelt",
      key: "textbelt",
    }

    # Create the request
    request = Net::HTTP::Post.new(url.path, { "Content-Type" => "application/x-www-form-urlencoded" })
    request.set_form_data(data)

    # Make the request
    response = http.request(request)

    # Print the response
    puts "Response Code: #{response.code}"
    puts "Response Body: #{response.body}"
  end
end
