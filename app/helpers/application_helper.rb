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
      canonical: Rails.env.production? ? 'https://verses-take.fly.dev/' : 'http://localhost:3000/',
      separator: '|',
      og:{
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: Rails.env.production? ? 'https://verses-take.fly.dev/' : 'http://localhost:3000/',
        image: image_url('ogp.png'),
        local: 'ja-JP'
      },
      x: {
        card: 'summary_large_image',
        site: '@JohnRRRxx',
        image: image_url('ogp.png')
      }
    }
  end
end
