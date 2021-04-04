class UrlController < ApplicationController
  def home
  end

  def shorten
    @long_url = LongUrl.new(url: params[:long_url])
    flash.clear
    if !@long_url.save
      flash[:error] = "Not a valid url - should be a url with full path e.g., https://abc.xyz.com/path"
      render :action => "home", :status => :unprocessable_entity
    else
      flash[:success] = "Url successfully shortened"
    end
  end

  def go_to_link
    @long_url = LongUrl.find_by(token: params[:short_url])

    #increment the count
    url_hit = @long_url.url_hits.new
    url_hit.ip_address = request.remote_ip == "::1" ? "127.0.0.1" : request.remote_ip
    url_hit.save
    redirect_to @long_url.url
  end

  def stats
    @long_url = LongUrl.find_by(token: params[:short_url])
    @last_hit = @long_url.url_hits.order("created_at").last
  end
end
