class AuthenticateUser
  prepend SimpleCommand
  include ActiveModel::Validations

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    return JsonWebToken.encode(user_id: user.id) if user
  end

  def user
    user = User.find_by_email(@email)
    return user if user&.authenticate(@password)

    errors.add :message, 'Invalid credentials'
    nil
  end

  def errors
    @errors ||= ActiveModel::Errors.new(self)
  end
end
