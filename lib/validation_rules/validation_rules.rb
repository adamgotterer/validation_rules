require 'json'
require 'date'
require 'time'

module ValidationRules
  EMAIL_REGEX = /^(?!(?:(?:\x22?\x5C[\x00-\x7E]\x22?)|(?:\x22?[^\x5C\x22]\x22?)){255,})(?!(?:(?:\x22?\x5C[\x00-\x7E]\x22?)|(?:\x22?[^\x5C\x22]\x22?)){65,}@)(?:(?:[\x21\x23-\x27\x2A\x2B\x2D\x2F-\x39\x3D\x3F\x5E-\x7E]+)|(?:\x22(?:[\x01-\x08\x0B\x0C\x0E-\x1F\x21\x23-\x5B\x5D-\x7F]|(?:\x5C[\x00-\x7F]))*\x22))(?:\.(?:(?:[\x21\x23-\x27\x2A\x2B\x2D\x2F-\x39\x3D\x3F\x5E-\x7E]+)|(?:\x22(?:[\x01-\x08\x0B\x0C\x0E-\x1F\x21\x23-\x5B\x5D-\x7F]|(?:\x5C[\x00-\x7F]))*\x22)))*@(?:(?:(?!.*[^.]{64,})(?:(?:(?:xn--)?[a-z0-9]+(?:-[a-z0-9]+)*\.){1,126}){1,}(?:(?:[a-z][a-z0-9]*)|(?:(?:xn--)[a-z0-9]+))(?:-[a-z0-9]+)*)|(?:\[(?:(?:IPv6:(?:(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){7})|(?:(?!(?:.*[a-f0-9][:\]]){7,})(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,5})?::(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,5})?)))|(?:(?:IPv6:(?:(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){5}:)|(?:(?!(?:.*[a-f0-9]:){5,})(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,3})?::(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,3}:)?)))?(?:(?:25[0-5])|(?:2[0-4][0-9])|(?:1[0-9]{2})|(?:[1-9]?[0-9]))(?:\.(?:(?:25[0-5])|(?:2[0-4][0-9])|(?:1[0-9]{2})|(?:[1-9]?[0-9]))){3}))\]))$/i
  ALPHA_REGEX = /^[[:alpha:]]+$/
  ALPHA_DASH_REGEX = /^[a-z\-_]+$/i
  ALPHA_DASH_DIGIT_REGEX = /^[a-z\-_0-9]+$/i
  ALPHA_DASH_SLASH_REGEX = /^[a-z\-_\/]+$/i
  ALPHA_NUMERIC_REGEX = /^[[:alnum:]]+$/
  ALPHA_NUMERIC_DASH_REGEX = /^[[:alnum:]\-_]+$/i
  NUMERIC_REGEX = /^[0-9]+$/
  DATE_REGEX = /^((?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[0-1]|0[1-9]|[1-2][0-9])$/
  ISO8601_REGEX = /^(-?(?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[0-1]|0[1-9]|[1-2][0-9])(T(2[0-3]|[0-1][0-9]):([0-5][0-9]):([0-5][0-9])(\.[0-9]+)?(Z|[+-](?:2[0-3]|[0-1][0-9]):[0-5][0-9])?)?$/

  def self.alpha(value)
    value =~ ALPHA_REGEX
  end

  # Validates for letters, underscores and dashes
  def self.alpha_dash(value)
    value =~ ALPHA_DASH_REGEX
  end

  # Validates for letters, numbers, underscores and dashes
  def self.alpha_dash_digit(value)
    value =~ ALPHA_DASH_DIGIT_REGEX
  end

  # Validates for letters, numbers, forward-slashes, underscores and dashes
  def self.alpha_dash_slash(value)
    value =~ ALPHA_DASH_SLASH_REGEX
  end

  def self.alpha_numeric(value)
    value =~ ALPHA_NUMERIC_REGEX
  end

  # Validates alphanumeric, dashes and underscores
  def self.alpha_numeric_dash(value)
    value =~ ALPHA_NUMERIC_DASH_REGEX
  end

  def self.date(value)
    value =~ DATE_REGEX
  end 

  def self.iso8601(value)
    value =~ ISO8601_REGEX
  end

  def self.decimal(value, precision = 5, scale = 2)
    before, after = precision - scale, scale
    value.to_s =~ /^[-+]?\d{0,#{before}}?(?:\.\d{0,#{after}})?$/
  end

  def self.email(value)
    value =~ EMAIL_REGEX
  end

  def self.bson_object_id(value)
    ::BSON::ObjectId.legal? value
  end

  def self.integer(value)
    value.is_a? Integer
  end

  def self.future_date(value)
    value = Time.parse(value) if value.is_a? String 
    value.to_i >= Time.now.to_i
  end

  def self.string(value)
    value.is_a? String
  end

  def self.json(value)
    return false unless value
    begin
      JSON.parse(value)
    rescue JSON::ParserError
      return false
    end

    return true
  end

  def self.money(value, decimals = 2)
    value.to_s =~ /^[-+]?([0-9]+)?(?:\.[0-9]{0,#{decimals}})?$/
  end

  def self.length(value, length)
    value.to_s.length == length
  end

  def self.matches(value, value1)
    value == value1
  end

  def self.max_length(value, length)
    value.to_s.length <= length
  end

  def self.min_length(value, length)
    value.to_s.length >= length 
  end

  def self.numeric(value)
    value =~ NUMERIC_REGEX
  end

  def self.numeric_min(value, min)
    value.to_f >= min.to_f
  end

  def self.numeric_max(value, max)
    value.to_f <= max.to_f
  end

  def self.positive(value)
    value.to_f > 0
  end

  def self.range(value, min, max)
    value.to_f >= min.to_f and value.to_f <= max.to_f
  end
end
