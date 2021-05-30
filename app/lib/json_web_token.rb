class JsonWebToken
  # secret to encode and decode token
  SECRET_KEY = Rails.application.credentials.secret_key_base.to_s

  def self.encode(payload, exp = 24.hours.from_now) 
    # set expiry to 24 hours from creation time
    payload[:exp] = exp.to_i
     # sign token with application secret
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    # get payload; first index in decoded Array
    decoded = JWT.decode(token, SECRET_KEY).first 
    HashWithIndifferentAccess.new decoded
    
  end 
end