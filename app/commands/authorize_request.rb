class AuthorizeRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def user
    result = User.find(decoded_auth_token[:user_id]) if decoded_auth_token

    errors.add(:message, 'Invalid token') if result.nil?
    result
  end

  private

  attr_reader :headers

  def errors
    @errors ||= ActiveModel::Errors.new(self)
  end

  def http_auth_header
    return headers['Authorization'].split.last if headers['Authorization'].present?

    errors.add(:message, 'Missing token')
    nil
  end

  def decoded_auth_token
    JsonWebToken.decode(http_auth_header)
  end
end
