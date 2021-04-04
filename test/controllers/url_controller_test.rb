require "test_helper"

class UrlControllerTest < ActionDispatch::IntegrationTest
  def post_url(long_url)
    post "/", params: {long_url: long_url }
  end
  test "should get home" do
    get "/"
    assert_response :success
    assert_select 'title', "TinyURL clone"
    #Must have a form for entering url
    assert_select 'form'
    #Must have a text box to enter the url
    assert_select 'form input[type=text]', 1
    #Must have a submit button
    assert_select 'form input[type=submit]', 1
  end
  test "Only valid urls are allowed" do
    post_url("qqq.com")
    assert_response :unprocessable_entity
    error_messge="Not a valid url - should be a url with full path e.g., https://abc.xyz.com/path"
    assert_equal error_messge, flash[:error]
    assert_match error_messge, @response.body
  end
  test "valid urls are saved" do
    long_url = "https://qqq.com"
    post_url(long_url)
    assert_response :success
    success_message = "Url successfully shortened"
    assert_equal success_message, flash[:success]
    assert_match success_message, @response.body
    assert_match long_url, @response.body
    #there should be a shortened url link
    #the url should be home_url/[5 character alpha numeric token]
    home_url = Regexp.escape("#{request.base_url}/")
    short_url_pattern = /^#{home_url}[a-zA-Z0-9]{5}$/
    link = ""
    assert_select 'a', :href => short_url_pattern, :text =>short_url_pattern do |elements|
        elements.each do |el|
          link = el[:href]
        end
     end
     #check the link and text are same
     assert_select 'a', :text => link
  end
  test "can shorten a second url from results page" do
    post_url("https://qqq.com")
    #check there is a new form to enter the next url
    assert_select 'form'
    #Must have a text box to enter the url
    assert_select 'form input[type=text]', 1
    #Must have a submit button
    assert_select 'form input[type=submit]', 1
    post_url("https://qqq2.com")
    assert_response :success
  end
  test "can get to stats page" do
    long_url = LongUrl.new(url:"https://qq.qq.com")
    long_url.save
    hit_count = 1
    get "/#{long_url.token}"
    get "/#{long_url.token}/stats"
    assert_response :success
    assert_match long_url.url, @response.body
    assert_match long_url.token, @response.body
    assert_match "Hit count: #{hit_count}", @response.body
    #The hit count should increment
    get "/#{long_url.token}"
    hit_count = hit_count + 1
    get "/#{long_url.token}/stats"
    assert_match "Hit count: #{hit_count}", @response.body
  end
  test "should save the ip address" do
    ip_address1 = '1.2.3.4'
    #@request.env['REMOTE_ADDR'] = ip_address1
    long_url = LongUrl.new(url:"https://qq.qq.com")
    long_url.save
    get "/#{long_url.token}", headers: { "HTTP_X_FORWARDED_FOR" => "#{ip_address1}" }
    get "/#{long_url.token}/stats"
    assert_match "Last hit from: #{ip_address1}", @response.body
    ip_address2 = '5.6.7.8'
    get "/#{long_url.token}", headers: { "HTTP_X_FORWARDED_FOR" => "#{ip_address2}" }
    get "/#{long_url.token}/stats"
    assert_match "Last hit from: #{ip_address2}", @response.body
  end

end
