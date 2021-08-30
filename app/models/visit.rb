class Visit < ApplicationRecord
  belongs_to :url

  def ip_address
    ipv4.present? ? IPAddr.new(ipv4, Socket::AF_INET).to_s : IPAddr.ntop(ipv6)
  end
end
