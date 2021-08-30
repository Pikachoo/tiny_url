class TokenGenerator
  ALPHABET = [*'a'..'z', *'A'..'Z', *'0'..'9', '-', '_']
  ATTEMPT_TRIES = 10

  attr_reader :url

  def initialize(url)
    @url = url
    @token_length = ApplicationSetting.find_by(name: :token_length).value
    @increased = false
  end

  def generate
    Url.create!(original: url,
                token: token)
  end

  private

  def token
    alphabet_length = ALPHABET.length

    ATTEMPT_TRIES.times do
      token = ''
      @token_length.times do
        token << ALPHABET[Random.rand(0...alphabet_length)]
      end

      return token unless Url.find_by(token: token)
    end

    @increased ? raise(StandardError.new("Can not generate an url")): increase_length

    token
  end

  def increase_length
    setting = ApplicationSetting.find_by(name: :token_length)
    setting.update!(value: @token_length + 1)
    @token_length = setting.value
    @increased = true
  end
end