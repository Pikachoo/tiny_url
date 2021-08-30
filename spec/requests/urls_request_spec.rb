require 'rails_helper'

RSpec.describe "Urls", type: :request do
  describe '#create' do
    it 'should create a new tiny url' do
      params = { url: Faker::Internet.url }

      expect { post '/urls.json', params: params }.to change(Url, :count).by(1)
      expect(response).to redirect_to(root_path + "#{Url.last.token}/info")
    end

    it "should increase length if can't create a new tiny url" do
      create(:url, token: 'aaa')
      stub_const("TokenGenerator::ALPHABET", ['a'])

      params = { url: Faker::Internet.url }
      post '/urls.json', params: params

      expect(ApplicationSetting.find_by(name: :token_length).value).to eq(4)
      expect(Url.last.token).to eq('aaaa')
    end

    it "should raise an error if increase doesn't help" do
      create(:url, token: 'aaa')
      create(:url, token: 'aaaa')
      stub_const("TokenGenerator::ALPHABET", ['a'])

      params = { url: Faker::Internet.url }

      expect { post '/urls.json', params: params }.to raise_error(StandardError, 'Can not generate an url')
    end

  end

  describe '#open' do
    it 'should create visit record when clicked' do
      tiny_url = create(:url)

      get "/#{tiny_url.token}"

      expect(tiny_url.visits.count).to eq(1)
    end

    it 'should save ip into ipv4 or ipv6 visit record when clicked' do
      tiny_url = create(:url)

      example_ipv4 = Faker::Internet.ip_v4_address
      example_ipv6 = Faker::Internet.ip_v6_address

      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(example_ipv4)
      get "/#{tiny_url.token}"

      expect(tiny_url.visits.last.ipv4).to eq(IPAddr.new(example_ipv4).to_i)
      expect(tiny_url.visits.last.count).to eq(1)
      expect(tiny_url.visits.count).to eq(1)

      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(example_ipv6)
      get "/#{tiny_url.token}"

      expect(tiny_url.visits.last.ipv6).to eq(IPAddr.new(example_ipv6).hton)
      expect(tiny_url.visits.last.count).to eq(1)
      expect(tiny_url.visits.count).to eq(2)
    end

    it 'should increase count if user already visited link' do
      example_ipv4 = Faker::Internet.ip_v4_address
      tiny_url = create(:url)

      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(example_ipv4)
      get "/#{tiny_url.token}"
      expect(tiny_url.visits.count).to eq(1)

      get "/#{tiny_url.token}"
      expect(tiny_url.visits.find_by(ipv4: IPAddr.new(example_ipv4).to_i).count).to eq(2)
    end

    it 'should raise an error if client ip is invalid' do
      invalid_ip = '1.2.3.a'
      tiny_url = create(:url)

      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(invalid_ip)

      expect { get "/#{tiny_url.token}" }.to raise_error(StandardError, 'Invalid client IP')
    end

    it "should render not found if tiny url token doesn't exist" do
      example_ipv4 = Faker::Internet.ip_v4_address
      create(:url)

      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(example_ipv4)

      get "/token_1"
      expect(response.status).to eq(404)
    end
  end
end
