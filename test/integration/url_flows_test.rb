require "test_helper"

class UrlFlowsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "home page" do
    get "/"
    assert_response :success
    #Submitting the form should return success
    long_url = "http://qq.qqq.com"
    post "/", params: {long_url: long_url }
    assert_response :success
    #Check if we are reaching the long url
    short_url = ""
    assert_select 'a' do |elements|
      elements.each do |el|
          short_url = el[:href]
          get short_url
      end
    end
    assert_redirected_to long_url

    #check if we can get the stats page
    stats_url = "#{short_url}/stats"
    get stats_url
    assert_response :success
    assert_match long_url, @response.body
    assert_match short_url, @response.body
    hit_count = 1
    assert_match "Hit count: #{hit_count}", @response.body
  end

end
