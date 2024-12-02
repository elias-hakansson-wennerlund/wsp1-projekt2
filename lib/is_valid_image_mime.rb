VALID_MIMES = ["png", "jpg", "jpeg", "webp", "avif", "gif"]

def is_valid_image_mime(mime)
  return false unless mime.is_a?(String)

  parts = mime.split('/')

  return false if parts.length != 2
  return false if parts[0] != 'image'
  return VALID_MIMES.include?(parts[1])
end
