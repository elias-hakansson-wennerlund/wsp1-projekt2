# Rules for passwords:
# - Minimum length: 8 characters
# - Must include uppercase character
# - Must include lowercase character
# - Must include a digit
# - Must include a non-alphabetic character
def is_valid_password(password)
  return false unless password.is_a?(String)
  return false if password.length < 8

  has_upper = false
  has_lower = false
  has_digit = false
  has_non_alpha = false

  password.each_char do |ch|
    if ch >= 'A' and ch <= 'Z'
      has_upper = true
    elsif ch >= 'a' and ch <= 'z'
      has_lower = true
    elsif ch >= '0' and ch <= '9'
      has_digit = true
    else
      has_non_alpha = true
    end

    return true if has_upper and has_lower and has_non_alpha
  end

  has_upper and has_lower and has_non_alpha
end

