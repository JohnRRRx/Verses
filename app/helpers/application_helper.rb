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
      title: 'あの瞬間、何の曲を思い出した？',
      reverse: true,
      charset: 'utf-8',
      description: '文字、写真、音楽をまとめて投稿してみませんか',
      keywords: '音楽',
      canonical: 'request.original_url',
      separator: '|',
      og:{
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: 'request.original_url',
        image: image_url('ogp.png'),
        local: 'ja-JP'
      },
      x: {
        card: 'summary_medium_image',
        image: image_url('ogp.png')
      }
    }
  end
end
