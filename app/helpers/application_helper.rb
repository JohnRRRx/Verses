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
      title: '文字、写真、音楽をまとめて投稿できるアプリです',
      reverse: true,
      charset: 'utf-8',
      description: 'あの瞬間、何の曲を思い出した？',
      keywords: '音楽',
      canonical: 'https://verses-take.fly.dev/',
      separator: '|',
      og:{
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: 'https://verses-take.fly.dev/',
        image: "#{root_url}images/ogp.png"
        local: 'ja-JP'
      },
      x: {
        card: 'summary_large_image',
        site: '@JohnRRRxx',
        image: "#{root_url}images/ogp.png"
      }
    }
  end
end
