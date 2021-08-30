require 'rails_helper'

RSpec.describe Visit, type: :model do
  describe '#ip_address' do
      it 'should convert back ipv4 or ipv6' do
        tiny_url = create(:url)

        example_ipv4 = Faker::Internet.ip_v4_address
        example_ipv6 = Faker::Internet.ip_v6_address

        ipv4_visit = create(:visit, url: tiny_url, ipv4: IPAddr.new(example_ipv4).to_i)
        ipv6_visit = create(:visit, url: tiny_url, ipv6: IPAddr.new(example_ipv6).hton)

        expect(IPAddr.new(ipv4_visit.ip_address)).to eq(IPAddr.new(example_ipv4))
        expect(IPAddr.new(ipv6_visit.ip_address)).to eq(IPAddr.new(example_ipv6))
      end
  end

  describe '#validations' do
    it 'should raise an error if ip visit already exists' do
      tiny_url = create(:url)

      example_ipv4 = Faker::Internet.ip_v4_address

      create(:visit, url: tiny_url, ipv4: IPAddr.new(example_ipv4).to_i)

      expect{create(:visit, url: tiny_url, ipv4: IPAddr.new(example_ipv4).to_i)}.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Url has already been taken')
    end
  end
end
