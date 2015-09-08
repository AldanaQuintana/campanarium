if notice.has_images?
  json.image_url notice.images_urls[0]
end
json.url notice.url
json.title notice.title
json.body notice.body.try(:truncate, 100)
json.source_logo source_logo(notice)