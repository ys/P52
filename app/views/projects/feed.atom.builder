atom_feed do |feed|
  feed.title(@project.title)
  feed.updated(@project.last_picture.postDate)
 
  for picture in @project.pictures.sort {|x,y| y.postDate <=> x.postDate } 
    feed.entry(picture) do |entry|
      entry.title(picture.flickr["title"])
      entry.content(image_tag(picture.url) , :type => 'html')
      entry.updated(picture.postDate.strftime("%Y-%m-%dT%H:%M:%SZ")) # needed to work with Google Reader.
      entry.author do |author|
        author.name(picture.user.name)
      end
    end
  end
end