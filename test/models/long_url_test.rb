require "test_helper"
require 'digest'

class LongUrlTest < ActiveSupport::TestCase
  test "must have an url" do
    long_url = LongUrl.new
    assert_not long_url.save
  end

  test "must have a valid url" do
    long_url = LongUrl.new
    long_url.url = "aaaaa"
    assert_not long_url.save
    long_url.url = "/qq.com/aaaaa"
    assert_not long_url.save
    long_url.url = "http://qqq.qq.com/text"
    assert long_url.save
    long_url.url = "http://qqq.qq.com/"
    assert long_url.save
    long_url.url = "https://qqq.qq.com/1/2/3"
    assert long_url.save
  end

  test "must save MD5 hash" do
    url = "http://qqq.qq.com/text"
    md5hash = Digest::MD5.hexdigest(url)
    long_url = LongUrl.new
    long_url.url = url
    assert_equal long_url.md5hash, md5hash
  end

  test "must save token" do
    url = "http://qqq.qq.com/text"
    long_url = LongUrl.new
    long_url.url = url
    assert_not_nil long_url.token
  end

  test "token should be 5 character alpha numeric" do
    regex = /^[0-9a-zA-Z]{5}$/
    url = "http://qqq.qq.com/text"
    long_url = LongUrl.new
    long_url.url = url
    assert long_url.token.match(regex)
  end

  test "base62 encoding" do
    long_url = LongUrl.new
    assert_equal('0', long_url.to_base62(0.chr))
    assert_equal('0', long_url.to_base62(62.chr))
    assert_equal('Z', long_url.to_base62(123.chr))
  end

  test "token should be unique" do
    url = "http://qqq.qq.com/text"
    long_url1 = LongUrl.new
    long_url1.url = url
    long_url2 = LongUrl.new
    long_url2.url = url
    assert_not_equal long_url1.token, long_url2.token
  end

  test "can retrive from database" do
    url = "http://qqq.qq.com/text"
    md5hash = Digest::MD5.hexdigest(url)
    long_url = LongUrl.new
    long_url.url = url
    assert long_url.save
    id = long_url.id
    url_retrieved = LongUrl.find(id)
    assert_not_nil url_retrieved
    assert_equal url_retrieved.md5hash, md5hash
  end

  test "shortening the same url will return the saved token" do
    long_url = "https://qqq22.com"
    long_url1 = LongUrl.new(url: long_url)
    long_url1.save
    long_url2 = LongUrl.new(url: long_url)
    long_url2.save
    assert_equal long_url1.token, long_url2.token
  end
end
