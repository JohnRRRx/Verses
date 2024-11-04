# frozen_string_literal: true

module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice then 'bg-emerald-300/50'
    when :error then 'bg-red-400/40'
    else 'bg-gray-500/60'
    end
  end
end
