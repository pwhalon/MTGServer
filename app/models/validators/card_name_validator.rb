class CardNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless record.present?

    return unless value.present? && value.is_a?(String)

    if MagicCard.with_name(value).empty?
      record.errors.add(:name, 'Invalid Magic card name. Must be an actual card')
    end
  end
end