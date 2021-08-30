class UrlsController < ApplicationController
  # POST /urls
  def create
    @tiny_url  = TokenGenerator.new(create_params[:url]).generate

    redirect_to root_path + "#{@tiny_url.token}/info"
  end

  # GET /:token
  def open
    render_not_found and return unless tiny_url
    raise StandardError, 'Invalid client IP' unless ip_valid?

    ip = IPAddr.new(request.remote_ip)

    # create visit
    if ip.ipv4?
      column_name = :ipv4
      value = ip.to_i
    elsif ip.ipv6?
      column_name = :ipv6
      value = ip.hton
    end

    visit = tiny_url.visits.find_or_initialize_by(column_name =>  value)
    visit.count += 1 unless visit.new_record?
    visit.save!

    redirect_to tiny_url.original
  end

  # GET /:token/info
  def show
    tiny_url
  end

  private

  def tiny_url
    @tiny_url ||= Url.find_by(token: url_params[:token])
  end

  def create_params
    params.permit(:url)
  end

  def url_params
    params.permit(:token)
  end

  def ip_valid?
    IPAddr.new(request.remote_ip)

    true
  rescue
    false
  end
end
