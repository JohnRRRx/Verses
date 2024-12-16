module ApplicationHelper
  def flash_color(type)
    case type.to_sym
    when :notice then 'bg-emerald-300/50'
    when :error then 'bg-red-400/40'
    else 'bg-gray-500/60'
    end
  end

  def default_meta_tags
    {
      site: 'Verses',
      title: 'この瞬間、何の曲を思い出しましたか？',
      reverse: true,
      charset: 'utf-8',
      description: '',
      canonical: 'request.original_url',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: 'request.original_url',
        image: image_url('ogp.png'),
        local: 'ja-JP'
      },
      x: {
        card: 'summary_large_image',
        image: image_url('ogp.png')
      }
    }
  end
end
