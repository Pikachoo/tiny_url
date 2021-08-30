class UrlsController < ApplicationController
  def create
    @tiny_url  = TokenGenerator.new(create_params[:url]).generate

    redirect_to root_path + "#{@tiny_url.token}/info"
  end

  def open
    render_not_found and return unless tiny_url

    # create visit
    ip = IPAddr.new(request.remote_ip)
    if ip.ipv4?
      column_name = :ipv4
      value = ip.to_i
    elsif ip.ipv6?
      column_name = :ipv6
      value = ip.hton
    else
      logger.error StandardError, 'Invalid IP address'
      return
    end

    visit = tiny_url.visits.find_or_initialize_by(column_name =>  value)
    visit.count += 1 unless visit.new_record?
    visit.save!

    redirect_to tiny_url.original
  end

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
end
