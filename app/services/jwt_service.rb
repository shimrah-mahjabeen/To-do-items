class JwtService
    HMAC_SECRET = Rails.application.secret_key_base.to_s
  
    def self.encode(payload)
      JWT.encode(payload, HMAC_SECRET)
    end
  
    def self.decode(token)
      body = JWT.decode(token, HMAC_SECRET)[0]
      HashWithIndifferentAccess.new(body)
    rescue JWT::DecodeError => e
      nil
    end
  end
  