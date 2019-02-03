class TitleBracketsValidator < ActiveModel::Validator
  def validate(record)
    return if validate_string(record.title)
    record.errors.add(:base, "Title brackets does not match.")
  end

  private

  def validate_string(string)
    bracket_string = string.chars.select { |char| "(){}[]".include? char }.join
    balanced?(bracket_string) && no_empty_brackets?(string)
  end

  # rubocop:disable Metrics/MethodLength
  def balanced?(string)
    return false if string.length.odd?
    return false if string =~ /[^\[\]\(\)\{\}]/

    pairs = { "{" => "}", "[" => "]", "(" => ")" }

    stack = []
    string.chars do |bracket|
      if expectation = pairs[bracket]
        stack << expectation
      else
        return false unless stack.pop == bracket
      end
    end

    stack.empty?
  end
  # rubocop:enable Metrics/MethodLength

  def no_empty_brackets?(string)
    !(["()", "{}", "[]"].any? { |bracket| string.include?(bracket) })
  end
end
