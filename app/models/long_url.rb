require 'digest'
require 'securerandom'

class LongUrl < ApplicationRecord
  validates :url, presence: true
  validates :url, format: { with: /\A#{URI.regexp.to_s}\z/ }
  validates :token, format: { with: /\A[0-9a-zA-Z]{5}\z/}
  has_many :url_hits, dependent: :destroy

  CHARSET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

  def url=(value)
    self.md5hash = Digest::MD5.hexdigest(value) unless value.blank?
    #Use an uuid to make the token unique
    uuid = SecureRandom.uuid
    self.token = self.to_base62(uuid.to_s)[0..4]  unless value.blank?
    super
  end

  def save
    saved_url = LongUrl.find_by(md5hash: self.md5hash)
    if !saved_url.nil?
      #the url is already saved, use it
      self.id = saved_url.id
      self.token = saved_url.token
    else
      super
    end
  end

  def to_base62(value)
    result = ""
    value.each_char do |char|
      ascii_code = char.ord
      if ascii_code > 0
        result = result + CHARSET[ascii_code % 62]
      else
        result = result + CHARSET[0]
      end
    end
    result
  end
end
